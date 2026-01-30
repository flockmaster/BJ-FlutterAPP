import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'medal_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 勋章详情展示页 - 重构
class MedalDetailView extends StatelessWidget {
  final Map<String, dynamic> medal;
  final bool isWorn;
  final VoidCallback onBack;
  final Function(int) onWear;

  const MedalDetailView({
    super.key,
    required this.medal,
    required this.isWorn,
    required this.onBack,
    required this.onWear,
  });

  bool get isEarned => medal['date'] != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSurface,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildMedalDisplay(),
                  const SizedBox(height: 40),
                  Text(medal['name'], style: AppTypography.headingL.copyWith(fontSize: 28)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      medal['desc'] ?? medal['task'] ?? '',
                      style: AppTypography.bodyPrimary.copyWith(color: AppColors.textSecondary, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildStatusCard(),
                  const SizedBox(height: 40),
                  _buildActionButtons(),
                  const SizedBox(height: 40),
                  _buildHonorBadge(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaicBounceButton(
              onPressed: onBack,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(LucideIcons.arrowLeft, color: AppColors.brandBlack),
              ),
            ),
            Text('勋章详情', style: AppTypography.headingS),
            BaicBounceButton(
              onPressed: () {}, // 预留分享
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(LucideIcons.share2, color: AppColors.brandBlack, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedalDisplay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isEarned)
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.brandOrange.withOpacity(0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        MedalWidget(
          id: medal['id'],
          grayscale: !isEarned,
          size: 200,
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.circular(16),
      ),
      child: isEarned ? _buildEarnedStatus() : _buildProgressStatus(),
    );
  }

  Widget _buildEarnedStatus() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
          child: const Icon(LucideIcons.award, color: AppColors.success, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('获得时间', style: AppTypography.captionPrimary.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: 4),
            Text(
              medal['date'],
              style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('已达成', style: AppTypography.captionSecondary.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildProgressStatus() {
    final progress = medal['progress'] ?? '0/1';
    final parts = progress.split('/');
    final val = (double.tryParse(parts[0]) ?? 0) / (double.tryParse(parts[1]) ?? 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.lock, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 8),
                Text('解锁进度', style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            Text(progress, style: AppTypography.bodyPrimary.copyWith(color: AppColors.brandOrange, fontWeight: FontWeight.bold, fontFamily: 'Oswald')),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 8,
          decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(4)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: val.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.brandOrange, Color(0xFFFF9E00)]),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(child: Text('继续努力，即将点亮这份荣誉！', style: AppTypography.captionPrimary.copyWith(color: AppColors.textTertiary))),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (isEarned) {
      return Row(
        children: [
          Expanded(
            child: BaicBounceButton(
              onPressed: () {}, // 预留分享
              child: Container(
                height: 54,
                decoration: BoxDecoration(color: AppColors.bgCanvas, borderRadius: BorderRadius.circular(27)),
                alignment: Alignment.center,
                child: Text('炫耀一下', style: AppTypography.button.copyWith(color: AppColors.brandBlack)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BaicBounceButton(
              onPressed: () => onWear(medal['id']),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: isWorn ? AppColors.bgCanvas : AppColors.brandBlack,
                  borderRadius: BorderRadius.circular(27),
                ),
                alignment: Alignment.center,
                child: Text(
                  isWorn ? '取消佩戴' : '佩戴勋章',
                  style: AppTypography.button.copyWith(color: isWorn ? AppColors.textDisabled : AppColors.textInverse),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return BaicBounceButton(
      onPressed: () {}, // 预留跳转
      child: Container(
        height: 54,
        decoration: BoxDecoration(color: AppColors.brandBlack, borderRadius: BorderRadius.circular(27)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('立即去完成', style: AppTypography.button.copyWith(color: AppColors.textInverse)),
            const SizedBox(width: 8),
            const Icon(LucideIcons.arrowRight, size: 18, color: AppColors.textInverse),
          ],
        ),
      ),
    );
  }

  Widget _buildHonorBadge() {
    return Opacity(
      opacity: 0.3,
      child: Column(
        children: [
          const Icon(LucideIcons.shield, size: 24, color: AppColors.textTertiary),
          const SizedBox(height: 8),
          Text(
            'BAIC OFFICIAL HONOR',
            style: AppTypography.captionSecondary.copyWith(letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
