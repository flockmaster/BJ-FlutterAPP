# 🚀 BAIC 开发避坑指南 (Prevention Rules)

这些规则基于开发过程中实际发生超过 3 次的错误总结而成。在开始任何新功能、新页面或重大重构前，**AI 必须阅读并遵循这些规则**。

---

## 🛠 避坑规则列表

### [DR01] 依赖注入缺失 (Dependency Injection Registration)
- **现象**: 运行时抛出 `Bad state: GetIt: Object/factory with type X is not registered`。
- **原因**: 新增 Service 或 Model 后，未在 `lib/app/app.dart` 的 `dependencies` 列表中注册。
- **强制规约**: 
    1. 任何新增的 Service 接口及实现类，必须立即同步到 `lib/app/app.dart`。
    2. 对于接口实现，必须使用 `LazySingleton(classType: CacheService, asType: ICacheService)` 这种显式映射格式。
    3. 修改后必须执行 `flutter pub run build_runner build --delete-conflicting-outputs`。
