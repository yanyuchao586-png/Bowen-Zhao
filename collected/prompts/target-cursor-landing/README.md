# Target Cursor Landing Prompt

![Source preview](assets/source-preview.png)

## What It Is

这是一个适合生成暗色高级作品集首页的前端提示词。它覆盖 React、Vite、Tailwind CSS、TypeScript、GSAP、Framer Motion、hls.js 等实现细节，能帮助 AI 生成带加载页、视频 Hero、动效导航、作品 Bento Grid、Journal、Parallax Gallery、Stats 和 Footer 的完整单页作品集。

## Source

- Source website: [React Bits - Target Cursor](https://www.reactbits.dev/animations/target-cursor)
- Preview: captured from the source page for reference.

## Best For

- 想学习“热门作品集 landing page”结构的新手。
- 想让 AI 一次性生成完整页面，而不是只生成一个小组件。
- 想复刻暗色、玻璃质感、视频背景、GSAP 入场动画和滚动视差。
- 想把 React Bits 的交互灵感融入个人作品集。

## Beginner Usage

1. 新建 React + Vite + TypeScript 项目。
2. 安装 prompt 里提到的依赖：

```powershell
npm install gsap framer-motion hls.js react-router-dom tailwindcss-animate
```

3. 打开 [`prompt.md`](prompt.md)，复制完整内容。
4. 粘贴给 AI，并补充你的名字、作品集项目名、头像/作品图片来源。
5. 要求 AI 先生成文件结构，再分文件实现。
6. 生成后重点检查：HLS 视频是否可播放、移动端文字是否溢出、GSAP ScrollTrigger 是否正确清理。

## Copy Starter

```text
Use the prompt in prompt.md to build this landing page in my existing React + Vite + Tailwind project. Keep the existing folder style, make it responsive, and verify the page works on desktop and mobile.
```

## Customization Ideas

- 把姓名、城市、角色文案换成自己的。
- 用自己的项目图替换 Bento Grid 图片。
- 把导航改为真实锚点：Home / Work / Resume / Contact。
- 如果项目没有视频素材，先用静态海报图替代 HLS 视频。

## Files

- [`prompt.md`](prompt.md): original prompt text.
- [`assets/source-preview.png`](assets/source-preview.png): source page preview.
