/// [ViewState] - UI 异步操作的状态枚举
/// 
/// 用于驱动 View 层的状态切换（如：显示骨架屏、加载中、成功或错误界面）。
enum ViewState {
  idle,    // 空闲状态：尚未发起请求
  loading, // 加载中：正在进行网络请求或异步计算
  success, // 成功：数据获取并处理完成
  error,   // 错误：发生异常或业务逻辑失败
}

/// [Result] - API 响应的函数式包装类
/// 
/// 旨在提供一种类型安全且强制处理错误的方式来封装后端返回的结果。
class Result<T> {
  final T? data;      // 成功时的业务数据
  final String? error; // 失败时的错误信息（通常用于 UI 提示）
  final bool isSuccess; // 业务执行是否成功

  Result._({this.data, this.error, required this.isSuccess});

  /// 工厂方法：创建一个成功的 Result
  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  /// 工厂方法：创建一个失败的 Result
  factory Result.failure(String error) {
    return Result._(error: error, isSuccess: false);
  }

  /// 模式匹配回调：根据 Result 的状态执行对应的闭包
  /// 
  /// 强制调用方在使用数据前必须显式处理错误路径。
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    }
    return failure(error ?? '未知错误');
  }
}

/// [PaginationState] - 列表分页状态管理类
/// 
/// 遵循铁律 4.2 (列表加载策略)：所有长列表必须支持分页加载。
/// 该类用于记录分页请求中的关键指标，确保 UI 能够正确显示“没有更多数据”等状态。
class PaginationState<T> {
  final List<T> items;      // 当前已加载的所有数据项
  final int currentPage;    // 当前页码
  final int totalPages;     // 总页数
  final bool hasMore;       // 是否还有更多数据（决定是否触发下一页请求）
  final bool isLoadingMore; // 是否正在加载下一页

  const PaginationState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  /// 状态更新辅助方法
  PaginationState<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
