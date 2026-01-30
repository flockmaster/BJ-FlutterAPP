import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/models/invite_models.dart';
import '../../../core/services/invite_service.dart';

/// 邀请好友页面的ViewModel
/// [InviteFriendsViewModel] - 邀请好友与品牌推广业务逻辑类
///
/// 核心职责：
/// 1. 展示用户的专属邀请码及邀请激励政策（如邀约成功奖励）。
/// 2. 统计并展示历史邀请记录与当前进度。
/// 3. 管理推广媒介的分发：复制邀请码至剪贴板、生成分享海报（H5/原生）、对接微信社交分发。
class InviteFriendsViewModel extends BaicBaseViewModel {
  final _inviteService = locator<IInviteService>();

  /// 用户的唯一邀请标识码
  String _inviteCode = '';
  /// 历史成功的邀请名单及状态
  List<InviteRecord> _inviteList = [];
  /// 累计成功邀约的人数统计
  int _successfulInvites = 0;
  /// 页面滚动实时偏移量（用于吸顶 Header 效果）
  double _scrollOffset = 0.0;

  String get inviteCode => _inviteCode;
  List<InviteRecord> get inviteList => _inviteList;
  int get successfulInvites => _successfulInvites;
  double get scrollOffset => _scrollOffset;

  /// 生命周期：初始化时全量同步邀请体系数据
  Future<void> init() async {
    setBusy(true);
    await loadInviteData();
    setBusy(false);
  }

  /// 业务加载：从 [IInviteService] 提取码、列表及统计
  Future<void> loadInviteData() async {
    try {
      final result = await _inviteService.getInviteData();
      
      result.when(
        success: (data) {
          _inviteCode = data.inviteCode;
          _inviteList = data.inviteList;
          _successfulInvites = data.successfulInvites;
          notifyListeners();
        },
        failure: (error) {
          setError(error);
        },
      );
    } catch (e) {
      setError('加载邀请数据失败: ${e.toString()}');
    }
  }

  /// 交互：将邀请码写入系统剪贴板并提示
  Future<void> copyInviteCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _inviteCode));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('邀请码已复制'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xFF111111),
        ),
      );
    }
  }

  /// 交互：唤起品牌预设的邀请指令
  void handleInvite() {
    // 逻辑：可根据具体需求选择直接分享 Link 或生成二维码海报
  }

  /// 交互：对接微信 SDK 发起会话分享
  void shareToWeChat() {
  }

  /// 交互：对接微信 SDK 发起朋友圈分享
  void shareToMoments() {
  }

  /// 交互：调用 share_plus 唤起系统原生分享看板
  void shareMore() {
  }

  /// 反馈：响应页面滚动，调整 Header 交互态
  void updateScrollOffset(double offset) {
    _scrollOffset = offset;
    notifyListeners();
  }
}
