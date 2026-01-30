# Flutter 项目标准模版 (Standard Flutter Project Template)

这是一个基于 **Stacked Framework (MVVM)** 架构的高级 Flutter 项目模版，集成了严格的代码规范、自动化 AI 代码审查、原型同步机制以及 AI 辅助开发工作流。

## 🌟 核心特性

- **架构约束 (Stacked Framework)**: 强制解耦 UI 与业务逻辑，预置 `BaicBaseViewModel` 等基类。
- **设计系统规约**: 严禁硬编码，统一使用 `AppColors` 和 `AppDimensions`。
- **自动化同步**: 一键同步 GitHub 上的 AI Studio 产品原型。
- **全栈式基础设施**:
  - **网络层**: 预置基于 Dio 的 `ApiClient` 和 `MockInterceptor`，支持零感知的 Mock 数据切换。
  - **工具库**: 预置通用的 `TimeUtils` (相对时间转换)、`NumberUtils` (大额数字缩写) 和 `CacheService`。
- **AI 赋能**:
  - `scripts/ai_code_review.dart`: 自动分析 Git Diff，检查逻辑错误与风格规范。
  - `.agent/workflows/`: 针对 AI 助手的标准操作指南 (SOP)。
- **错误治理**: 强制执行 "Step 0" 错误记录与晋升流程，防止同类错误重复发生。

## 📁 目录结构

```
.
├── .agent/                # AI 助手工作流配置
│   └── workflows/         # 各种 SOP (异常分析、原型转代码等)
├── .rules                 # 项目全局铁律 (AI 强制执行)
├── docs/                  # 项目文档
│   ├── ai_specs/          # 详细的设计与业务规范
│   └── PROJECT_SPECIFICATIONS.md # 核心开发指南
├── lib/                   # Flutter 源代码 (标准结构)
├── prototypes/            # 产品原型 (自动同步目标)
├── scripts/               # 自动化脚本
│   ├── config.sh          # 脚本配置文件 (抽离 GitHub 地址等)
│   ├── sync_prototypes.sh # 原型同步脚本
│   └── ai_code_review.dart # AI 自动评审脚本
└── templates/             # 代码模板 (如 ViewModel 模版)
```

## 🚀 快速开始

### 1. 初始化配置

在 `scripts/config.sh` 中配置你的项目参数：
- `PROTOTYPE_REPO_URL`: 设置你的产品原型仓库地址。
- `AI_REVIEW_API_URL`: 设置 AI 评审使用的 API 节点。

### 2. 同步产品原型

```bash
chmod +x scripts/sync_prototypes.sh
./scripts/sync_prototypes.sh
```

### 3. 执行 AI 代码评审

需先设置 API Key 环境：
```bash
export AI_API_KEY="你的API密钥"
# 可选：设置模型和地址
# export AI_MODEL="gpt-4o"
# export AI_API_URL="https://api.openai.com/v1/..."

dart scripts/ai_code_review.dart
```

## 📏 开发铁律 (TL;DR)

1. **ViewModel 唯一论**: 所有业务逻辑必须在 ViewModel 中，禁止在 View 中使用 `BuildContext` 跳转或弹窗。
2. **视觉零容忍**: 严禁使用裸数字圆角和裸色值，必须引用 `AppDimensions` 和 `AppColors`。
3. **先写后改**: 遇到错误必须先在 `exception_history.md` 记录，严禁直接跳转修复代码。
4. **原型即真理**: UI 还原必须以 `prototypes/` 中的代码为准。

## 🛠 技术栈推荐

- **State Management**: [Stacked](https://pub.dev/packages/stacked)
- **Dependency Injection**: [Get_it](https://pub.dev/packages/get_it)
- **JSON Serialization**: [json_serializable](https://pub.dev/packages/json_serializable)
- **Network**: [Dio](https://pub.dev/packages/dio)
- **UI Feedback**: [BaicBounceButton](lib/core/components/baic_bounce_button.dart) (需自行实现或复制)

---
*Created by Antigravity AI*
