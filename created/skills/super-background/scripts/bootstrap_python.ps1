param(
    [switch]$DryRun,
    [string]$BootstrapVersion = "1.0.0"
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillRoot = Resolve-Path (Join-Path $ScriptDir "..")
$RuntimeDir = Join-Path $SkillRoot "runtime"
$StateFile = Join-Path $RuntimeDir "bootstrap.json"
$MinPythonVersion = [version]"3.10.0"
$PreferredWingetId = "Python.Python.3.13"
$FallbackInstallerVersion = "3.13.14"
$FallbackInstallerUrl = "https://www.python.org/ftp/python/$FallbackInstallerVersion/python-$FallbackInstallerVersion-amd64.exe"
$ProbeScript = @'
import json, sys
print(json.dumps({
    "version": ".".join(map(str, sys.version_info[:3])),
    "exe": sys.executable,
}))
'@

function Get-PythonInfoFromExecutable {
    param([string]$ExePath)
    if (-not (Test-Path -LiteralPath $ExePath)) {
        return $null
    }
    try {
        $raw = & $ExePath -c $ProbeScript 2>$null
        if ($LASTEXITCODE -ne 0) {
            return $null
        }
        if (-not $raw) {
            return $null
        }
        $info = $raw | ConvertFrom-Json
        $version = [version]$info.version
        if ($version -lt $MinPythonVersion) {
            return $null
        }
        return [pscustomobject]@{
            Path = [string]$info.exe
            Version = $version.ToString()
        }
    } catch {
        return $null
    }
}

function Get-PythonInfoFromLauncher {
    param([string]$LauncherPath)
    if (-not (Test-Path -LiteralPath $LauncherPath)) {
        return $null
    }
    try {
        $raw = & $LauncherPath -3 -c $ProbeScript 2>$null
        if ($LASTEXITCODE -ne 0) {
            return $null
        }
        if (-not $raw) {
            return $null
        }
        $info = $raw | ConvertFrom-Json
        $version = [version]$info.version
        if ($version -lt $MinPythonVersion) {
            return $null
        }
        return [pscustomobject]@{
            Path = [string]$info.exe
            Version = $version.ToString()
        }
    } catch {
        return $null
    }
}

function Find-Python {
    $candidates = New-Object System.Collections.Generic.List[string]

    $cmdPython = Get-Command python -ErrorAction SilentlyContinue
    if ($cmdPython -and $cmdPython.Source -notmatch 'WindowsApps') {
        $candidates.Add($cmdPython.Source)
    }

    $cmdPy = Get-Command py -ErrorAction SilentlyContinue
    if ($cmdPy) {
        $info = Get-PythonInfoFromLauncher -LauncherPath $cmdPy.Source
        if ($info) {
            return $info
        }
    }

    $roots = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Python"),
        (Join-Path $env:ProgramFiles "Python"),
        (Join-Path ${env:ProgramFiles(x86)} "Python")
    ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }

    foreach ($root in $roots) {
        Get-ChildItem -LiteralPath $root -Recurse -Filter python.exe -ErrorAction SilentlyContinue |
            ForEach-Object { $candidates.Add($_.FullName) }
    }

    foreach ($candidate in $candidates | Select-Object -Unique) {
        $info = Get-PythonInfoFromExecutable -ExePath $candidate
        if ($info) {
            return $info
        }
    }

    return $null
}

function Ensure-PipPackage {
    param(
        [string]$PythonExe,
        [string]$PackageName
    )

    try {
        & $PythonExe -m pip --version 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) {
            & $PythonExe -m ensurepip --upgrade | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "ensurepip failed."
            }
        }
    } catch {
        & $PythonExe -m ensurepip --upgrade | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "ensurepip failed."
        }
    }

    & $PythonExe -m pip install --user --upgrade $PackageName | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "package install failed: $PackageName"
    }
}

function Install-PythonViaWinget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        return $false
    }

    Write-Host "Installing Python via winget..."
    & winget install --id $PreferredWingetId --exact --scope user --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        return $false
    }
    return $true
}

function Install-PythonViaOfficialInstaller {
    $tempDir = Join-Path $env:TEMP "super-background-bootstrap"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    $installerPath = Join-Path $tempDir "python-$FallbackInstallerVersion-amd64.exe"

    Write-Host "Downloading Python from python.org..."
    Invoke-WebRequest -Uri $FallbackInstallerUrl -OutFile $installerPath

    Write-Host "Running Python installer..."
    $args = @(
        "/quiet",
        "InstallAllUsers=0",
        "PrependPath=1",
        "Include_pip=1",
        "Include_test=0",
        "SimpleInstall=1"
    )
    $proc = Start-Process -FilePath $installerPath -ArgumentList $args -Wait -PassThru -WindowStyle Hidden
    if ($proc.ExitCode -ne 0) {
        throw "Python installer exited with code $($proc.ExitCode)."
    }
}

function Read-State {
    if (-not (Test-Path -LiteralPath $StateFile)) {
        return $null
    }
    try {
        return Get-Content -LiteralPath $StateFile -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        return $null
    }
}

function Write-State {
    param([string]$PythonExe, [string]$PythonVersion)
    $state = [ordered]@{
        bootstrap_version = $BootstrapVersion
        python_exe = $PythonExe
        python_version = $PythonVersion
        pip_package = "python-docx"
        completed_at = (Get-Date).ToString("o")
    }
    New-Item -ItemType Directory -Force -Path $RuntimeDir | Out-Null
    $state | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $StateFile -Encoding UTF8
}

function Test-StateIsValid {
    param($State)
    if (-not $State) {
        return $false
    }
    if ([string]$State.bootstrap_version -ne $BootstrapVersion) {
        return $false
    }
    if (-not $State.python_exe -or -not (Test-Path -LiteralPath [string]$State.python_exe)) {
        return $false
    }
    $info = Get-PythonInfoFromExecutable -ExePath ([string]$State.python_exe)
    if (-not $info) {
        return $false
    }
    try {
        & ([string]$State.python_exe) -c "import docx" 2>$null | Out-Null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

$existingState = Read-State
if (Test-StateIsValid -State $existingState) {
    if ($DryRun) {
        Write-Host "Bootstrap already complete. Skipping."
    }
    exit 0
}

$python = Find-Python
if (-not $python) {
    if ($DryRun) {
        Write-Host "Would install Python and python-docx, then write $StateFile"
        exit 0
    }

    $installed = Install-PythonViaWinget
    if (-not $installed) {
        Install-PythonViaOfficialInstaller
    }

    $python = Find-Python
    if (-not $python) {
        throw "Python installation finished, but no usable python.exe was found."
    }
}

if ($DryRun) {
    Write-Host "Would ensure pip package python-docx in $($python.Path)"
    exit 0
}

Ensure-PipPackage -PythonExe $python.Path -PackageName "python-docx"
Write-State -PythonExe $python.Path -PythonVersion $python.Version
Write-Host "Bootstrap complete: $($python.Path) ($($python.Version))"
