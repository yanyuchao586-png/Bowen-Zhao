# super-background

![Version](https://img.shields.io/badge/version-4.5.0-blue)
![License: MIT](https://img.shields.io/badge/license-MIT-green)
![Output](https://img.shields.io/badge/output-chat%20%2B%20docx-orange)

`super-background` 是一个 10 维客户背调 Skill。它面向 B2B 客户开发、外贸销售、客户尽调和销售线索研究场景，从公司名、官网 URL 或截图线索出发，输出客户全息档案、决策人图谱，并可按内置 Word 模板生成报告。

核心原则很简单：禁止编造，禁止推测，找不到就写「暂未找到」。

## Features

- 10 维客户背调：客户类型、公司情报、规模、产品业务、贸易海关、决策人、社媒资产、风险评估、跟进策略、进出口贸易数据。
- 两种输出：聊天框 Markdown 报告，或基于 `assets/customer-background-report-template.docx` 的 Word 报告。
- 决策人图谱：要求尽量补齐姓名、职位、LinkedIn、邮箱验证状态和跟进优先级。
- 来源约束：所有 URL 必须经过访问验证；社媒链接必须精确到账号页。
- 文档模式按需补齐 Python 和 `python-docx`，纯文字模式不强制依赖本地环境。

## Quick Start

在支持 Skills 的 AI 工作区中安装或复制本目录，然后触发：

```text
#超级背调 [公司名 OR 官网 URL]
```

首次使用会确认两个偏好：

- 回复深度：快速回复 / 深度回复
- 输出形式：纯文字 / Word 文档

如果选择 Word 文档模式，可使用内置脚本从 JSON payload 生成报告：

```powershell
python .\scripts\build_report.py --input .\examples\report_payload.sample.json
```

默认输出到当前 skill 目录下的 `outputs/`。

## Install

克隆仓库后，把 skill 目录复制到你的本地 skills 目录：

```powershell
git clone https://github.com/yanyuchao586-png/Bowen-Zhao.git
Copy-Item -Recurse ".\Bowen-Zhao\created\skills\super-background" "$env:USERPROFILE\.codex\skills\super-background"
```

## Directory

```text
super-background/
├── SKILL.md
├── README.md
├── manifest.json
├── agents/
│   └── openai.yaml
├── assets/
│   └── customer-background-report-template.docx
├── examples/
│   └── report_payload.sample.json
├── references/
│   ├── email-verification-guide.md
│   └── report-template-map.md
└── scripts/
    ├── bootstrap_python.ps1
    └── build_report.py
```

## Quality Rules

- 没有可靠来源的信息统一写「暂未找到」。
- 不根据姓名和公司名拼 LinkedIn slug。
- 不根据邮箱格式猜测邮箱；如果是推测，必须显式标注 `(推测，未验证)`。
- 不把平台首页当作社媒账号页。
- 不把 AI 工具 token、API key、账号密码或内部路径写入报告。

## License

Released under the MIT License. See the repository root `LICENSE`.

品牌名称、商标和第三方数据源归各自权利人所有。
