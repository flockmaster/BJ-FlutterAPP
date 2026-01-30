# car_owner_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## 📱 HarmonyOS Next 适配说明

本项目已完成对 HarmonyOS Next (API 12+) 的适配。

### 分支管理
*   🏁 **鸿蒙代码分支**：`feature/harmony-support`
*   主分支 (`main`)：保留标准 Android/iOS 代码。

### 🚀 如何体验鸿蒙版

1.  **切换到适配分支**：
    ```bash
    git checkout feature/harmony-support
    ```

2.  **使用专用脚本构建**（推荐）：
    由于鸿蒙构建配置的特殊性，请使用根目录下的脚本进行一键构建和安装：
    ```bash
    # 极速体验 (Profile模式 + 自动修正配置 + 安装启动)
    ./build_profile_and_run.sh
    ```

### ⚠️ 主要差异
*   **依赖调整**：修复了 `geolocator` 等插件的模块名冲突。
*   **功能隔离**：地图、VR 等暂不支持的模块已做降级/占位处理。
*   **构建方式**：推荐使用脚本手动触发 `ohpm install` 和 `hvigor` 构建，以确保依赖链接正确。
