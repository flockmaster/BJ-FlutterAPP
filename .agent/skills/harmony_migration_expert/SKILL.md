---
name: harmony_migration_expert
description: 专门协助 Flutter 应用迁移至 HarmonyOS Next (API 12+) 的专家技能，包含依赖侦察、环境配置和代码桥接生成。
---

# GOAL
协助用户将 Flutter 应用迁移至 HarmonyOS Next (API 12+)，同时严格保护 iOS/Android 现有逻辑。

# INSTRUCTIONS
当用户请求“适配鸿蒙”、“迁移到鸿蒙”或“检查鸿蒙兼容性”时，请按以下步骤执行：

## STEP 1: 依赖侦察 (Dependency Intelligence)
1. 读取项目根目录下的 `pubspec.yaml`。
2. 识别所有 `dependencies`。
3. 针对每个插件，使用 Google Search 查找 "OpenHarmony SIG gitee [插件名]"。
4. **禁止**修改原 `dependencies` 字段。
5. 必须构建一个 `dependency_overrides` 列表，指向 Gitee 的 git 仓库或 path。

## STEP 2: 环境注入 (Environment Injection)
1. 检查 `ohos/` 目录是否存在。若不存在，建议运行 `flutter create --platforms=ohos .`。
2. 检查 `ohos/build-profile.json5` 的签名配置。
3. 任何对 `pubspec.yaml` 的修改，必须在操作前向用户展示 Diff。

## STEP 3: 桥接生成 (Bridging)
1. 扫描 `lib/` 文件夹，寻找 `MethodChannel` 的定义。
2. 对于每个 Channel，在 `ohos/entry/src/main/ets/plugins` 下生成对应的 ArkTS 类。
3. 生成代码时，严格使用 ArkTS 强类型语法（禁止使用 `any`）。

# CONSTRAINTS (约束)
- 🔴 **CRITICAL:** 严禁修改 `ios/`, `android/`, `macos/` 目录下的任何文件。
- 🔴 优先使用 OpenHarmony-SIG 官方维护的库，其次是 OpenHarmony-TPC。

# EXAMPLES
User: 帮我检查一下 camera 插件能不能在鸿蒙上跑。
Assistant: 正在扫描 pubspec.yaml... 发现 `camera: ^0.10.5`。
(调用 Search 工具...)
已找到鸿蒙适配版本。建议在 `pubspec.yaml` 中添加以下 `dependency_overrides`：
```yaml
dependency_overrides:
  camera:
    git:
      url: [https://gitee.com/openharmony-sig/flutter_packages.git](https://gitee.com/openharmony-sig/flutter_packages.git)
      path: packages/camera/camera