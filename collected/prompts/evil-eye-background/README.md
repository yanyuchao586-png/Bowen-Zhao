# Evil Eye Background Prompt / Evil Eye 背景组件提示词

![Source preview](assets/source-preview.png)

## What It Is / 这是什么

这是一个用于集成 React Bits `EvilEye` 背景组件的提示词。它提供了完整 React 组件源码、CSS、props 表和集成步骤，适合把一个 WebGL shader 风格的“火焰眼睛”背景加入 React 页面。
This prompt helps integrate the React Bits `EvilEye` background component. It includes component source, CSS, props, and integration instructions for adding a WebGL shader-style eye background to a React page.

## Source / 来源

- Source website / 来源网站：[React Bits - Evil Eye](https://www.reactbits.dev/backgrounds/evil-eye?glowIntensity=0.3&flameSpeed=0.9)
- Preview / 预览：captured from the source page for reference. 预览图来自来源页面截图，仅供理解效果。

## Best For / 适合谁

- 想学习 React + WebGL/OGL 组件集成的新手。Beginners learning React + WebGL/OGL integration.
- 想给登录页、游戏页、暗黑风品牌页、音乐视觉页添加动态背景。Builders adding animated backgrounds to login pages, game pages, dark brand sites, or music visuals.
- 想快速获得可调参数的 shader 组件，而不是从零写 GLSL。Developers who want a configurable shader component without writing GLSL from scratch.

## Beginner Usage / 小白使用方法

1. 在你的 React 项目里安装依赖。Install the dependency:

```powershell
npm install ogl
```

2. 打开 [`prompt.md`](prompt.md)，复制完整提示词。Open [`prompt.md`](prompt.md) and copy the full prompt.
3. 粘贴给 AI，并说明你的项目使用 JavaScript 还是 TypeScript。Paste it into your AI tool and tell it whether your project uses JavaScript or TypeScript.
4. 让 AI 创建两个文件：`EvilEye.jsx` 和 `EvilEye.css`。Ask the AI to create `EvilEye.jsx` and `EvilEye.css`.
5. 在页面中这样使用。Use it like this:

```jsx
import EvilEye from './EvilEye';

export default function Hero() {
  return (
    <section style={{ position: 'relative', minHeight: '100vh', overflow: 'hidden' }}>
      <EvilEye glowIntensity={0.3} flameSpeed={0.9} />
      <div style={{ position: 'relative', zIndex: 1 }}>
        Your content here
      </div>
    </section>
  );
}
```

## Newbie Notes / 新手注意

- 这个组件依赖 WebGL，低端设备上要注意性能。This component uses WebGL, so test performance on low-end devices.
- 如果页面黑屏，先检查容器是否有明确高度。If the page is black, check whether the container has a fixed height.
- 如果鼠标跟随太强，降低 `pupilFollow`。Lower `pupilFollow` if cursor tracking feels too intense.
- 如果火焰太亮，降低 `intensity` 或 `glowIntensity`。Lower `intensity` or `glowIntensity` if the glow is too bright.
- 如果你用 TypeScript，让 AI 把 props 类型补成 interface。If you use TypeScript, ask the AI to add a props interface.

## Files / 文件

- [`prompt.md`](prompt.md): original prompt text / 原始提示词。
- [`assets/source-preview.png`](assets/source-preview.png): source page preview / 来源页预览图。
