import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/profile_detail_service.dart';
import '../../../core/services/profile_service.dart';
import '../../../core/utils/number_utils.dart';
import '../../../app/app.locator.dart';

/// 个人资料详情页面的ViewModel
/// [ProfileDetailViewModel] - 个人主页/资料详情业务逻辑类
///
/// 核心职责：
/// 1. 聚合展示用户的个人信息：UID、地理位置、个性签名、关注/粉丝统计及动态内容（帖子/相册）。
/// 2. 管理用户车辆列表在个人主页的展示逻辑。
/// 3. 管理“荣誉勋章”的佩戴状态映射，与 [IProfileService] 全局同步。
class ProfileDetailViewModel extends BaicBaseViewModel {
  // 依赖注入
  final _profileDetailService = locator<IProfileDetailService>();
  final _profileService = locator<IProfileService>();

  // 聚合状态数据
  Map<String, dynamic>? _profileData; /// 基础资料原始映射
  List<Map<String, dynamic>> _posts = []; /// 发布的动态列表
  List<String> _photos = []; /// 个人相册列表
  List<Map<String, dynamic>> _vehicles = []; /// 认证车辆列表

  // 数据获取器

  /// 安全获取用户昵称
  String get displayName => _profileData?['displayName'] ?? '张越野';
  /// 用户唯一标识号
  String get userId => _profileData?['userId'] ?? '88293011';
  /// 归属地标识
  String get location => _profileData?['location'] ?? '北京·朝阳';
  /// 个性签名
  String get bio => _profileData?['bio'] ?? '热爱越野，热爱生活。周末不在山里，就在去山里的路上。🚙🏕️📸';
  /// 头像地址
  String get avatarUrl => _profileData?['avatar'] ?? 'https://randomuser.me/api/portraits/men/75.jpg';
  /// 主页背景封面图
  String get coverImage => _profileData?['coverImage'] ?? 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop';
  
  // 社交统计（运用 NumberUtils 进行万位级格式化）
  String get followingCount => NumberUtils.formatCount(_profileData?['followingCount'] ?? 0);
  String get followersCount => NumberUtils.formatCount(_profileData?['followersCount'] ?? 0);
  String get likesCount => NumberUtils.formatCount(_profileData?['likesCount'] ?? 0);
  
  // 内容列表
  List<Map<String, dynamic>> get posts => _posts;
  List<String> get photos => _photos;
  List<Map<String, dynamic>> get vehicles => _vehicles;
  
  /// 获取当前正在佩戴的勋章 ID（源自全局配置 Service）
  int? get wornMedalId => _profileService.wornMedalId;

  /// 生命周期：启动时全量加载个人空间所需的所有业务数据
  Future<void> init() async {
    setBusy(true);
    await loadProfileData();
    setBusy(false);
  }

  /// 业务加载：并发拉取资料、动态、相册及车辆信息
  Future<void> loadProfileData() async {
    try {
      _profileData = await _profileDetailService.getProfileData();
      _posts = await _profileDetailService.getUserPosts();
      _photos = await _profileDetailService.getUserPhotos();
      _vehicles = await _profileDetailService.getUserVehicles();
      notifyListeners();
    } catch (e) {
      setError('加载资料失败: ${e.toString()}');
    }
  }

  /// 交互：唤起系统分享面板展示个人名片
  void handleShare() {
    // TODO: 实现 H5 名片或海报分享
  }

  /// 交互：更多菜单（拉黑/举报等）
  void handleMore() {
  }

  /// 交互：导向个人资料编辑表单
  void handleEditProfile() {
  }

  /// 关键业务：更新当前账号的活跃佩戴勋章
  /// 此操作会触发布局中所有勋章占位符的实时重绘
  void updateWornMedal(int? medalId) {
    _profileService.setWornMedalId(medalId);
    notifyListeners();
  }
}

