# quietpress Cosmic Hero Prompt / quietpress 宇宙感 Hero 提示词

![Source preview](assets/source-preview.png)

## What It Is / 这是什么

这是一个用于生成单屏品牌 Hero 的前端提示词。它以虚构黑胶唱片厂牌 `quietpress` 为主题，要求使用 React、TypeScript、Tailwind CSS、Vite 和 lucide-react，实现全屏视频背景、boomerang 视频循环、liquid glass 按钮、移动端导航和 Now Playing 播放卡片。
This is a frontend prompt for building a full-screen brand hero for a fictional vinyl record label called `quietpress`. It uses React, TypeScript, Tailwind CSS, Vite, and lucide-react to create a video background, boomerang loop, liquid glass buttons, mobile navigation, and now-playing widget.

## Source / 来源

- Source asset / 来源素材：[MotionSites cosmic portfolio preview GIF](https://motionsites.ai/assets/hero-portfolio-cosmic-preview-BpvWJ3Nc.gif)
- Preview / 预览：screenshot captured from the source GIF URL for reference. 预览图来自来源 GIF 链接截图，仅供理解效果。

## Best For / 适合谁

- 想学习“一个屏幕就很抓人”的品牌首页。Beginners learning how to make a strong single-screen brand hero.
- 想做音乐、唱片、艺术家、播客、展览或创意工作室官网。Creators building music, vinyl, artist, podcast, exhibition, or studio websites.
- 想练习视频背景、玻璃拟态、动效入场和响应式 Header。Frontend learners practicing video backgrounds, glassmorphism, entrance animation, and responsive headers.
- 想让 AI 生成更像真实设计稿的 Hero，而不是普通营销首屏。Designers who want a hero section that feels closer to a real design reference.

## Beginner Usage / 小白使用方法

1. 新建 React + Vite + TypeScript 项目。Create a React + Vite + TypeScript project.
2. 安装图标库。Install the icon library:

```powershell
npm install lucide-react
```

3. 打开 [`prompt.md`](prompt.md)，复制完整提示词。Open [`prompt.md`](prompt.md) and copy the full prompt.
4. 粘贴给 AI，并说明你希望生成到哪个文件，例如 `src/App.tsx` 和 `src/index.css`。Paste it into your AI tool and tell it where to place the code, such as `src/App.tsx` and `src/index.css`.
5. 生成后运行。Run the generated app:

```powershell
npm run dev
```

6. 在浏览器检查：视频是否加载、移动端菜单是否可点、Now Playing 卡片是否不会遮挡标题。Check video loading, mobile menu behavior, and whether the now-playing card overlaps the headline.

## Copy Starter / 可复制开场白

```text
Use the prompt in prompt.md to create a single-screen React + TypeScript hero. Keep the implementation beginner-friendly, split the video background into a reusable component, and explain where each file should go.
```

```text
请使用 prompt.md 中的提示词生成一个单屏 React + TypeScript Hero。请保持实现适合新手理解，把视频背景拆成可复用组件，并说明每个文件应该放在哪里。
```

## Newbie Notes / 新手注意

- 该 prompt 使用外部 CloudFront 视频链接，若加载慢，可先替换成本地 mp4。The prompt uses an external CloudFront video; replace it with a local mp4 if loading is slow.
- `liquid-glass` 依赖 `backdrop-filter`，某些浏览器或父级 transform 会影响效果。`liquid-glass` depends on `backdrop-filter`, which can be affected by browser support or parent transforms.
- prompt 里特别强调 `animation-fill-mode: backwards`，不要随手改成 `forwards`。The prompt requires `animation-fill-mode: backwards`; avoid changing it to `forwards`.
- 这是静态页面，不需要 Supabase、数据库或后端。This is a static page and does not need Supabase, a database, or a backend.

## Files / 文件

- [`prompt.md`](prompt.md): original prompt text / 原始提示词。
- [`assets/source-preview.png`](assets/source-preview.png): source GIF preview screenshot / 来源 GIF 预览截图。
