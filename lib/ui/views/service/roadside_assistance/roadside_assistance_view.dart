import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'roadside_assistance_viewmodel.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/components/baic_ui_kit.dart';

class RoadsideAssistanceView extends StackedView<RoadsideAssistanceViewModel> {
  const RoadsideAssistanceView({super.key});

  @override
  Widget builder(BuildContext context, RoadsideAssistanceViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Map Simulation
          _buildBackgroundMap(),

          // Header
          _buildHeader(viewModel),

          // Bottom Panel
          _buildBottomPanel(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildBackgroundMap() {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?q=80&w=1000&auto=format&fit=crop',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.2),
            colorBlendMode: BlendMode.dstATop, // Simulate grayscale/opacity
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(RoadsideAssistanceViewModel viewModel) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaicBounceButton(
                onPressed: viewModel.goBackCustom,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.arrowLeft, size: 22, color: AppColors.brandBlack),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  '道路救援',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandBlack,
                  ),
                ),
              ),
              BaicBounceButton(
                onPressed: viewModel.contactSupport,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.headphones, size: 20, color: AppColors.brandBlack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context, RoadsideAssistanceViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildContentByStatus(viewModel),
        ),
      ),
    );
  }

  Widget _buildContentByStatus(RoadsideAssistanceViewModel viewModel) {
    switch (viewModel.status) {
      case RescueStatus.requesting:
        return _buildRequestingView(viewModel);
      case RescueStatus.enRoute:
        return _buildEnRouteView(viewModel);
      case RescueStatus.idle:
      default:
        return _buildIdleView(viewModel);
    }
  }

  Widget _buildIdleView(RoadsideAssistanceViewModel viewModel) {
    return Container(
      key: const ValueKey('idle'),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 50,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(3),
            ),
            margin: const EdgeInsets.only(bottom: 24),
          ),
          const Text(
            '您需要什么帮助？',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBlack,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildRescueOption(LucideIcons.alertTriangle, '故障拖车')),
              const SizedBox(width: 12),
              Expanded(child: _buildRescueOption(LucideIcons.batteryCharging, '电瓶搭电')),
              const SizedBox(width: 12),
              Expanded(child: _buildRescueOption(LucideIcons.car, '更换备胎')),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[50]!),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(LucideIcons.mapPin, size: 18, color: AppColors.textTertiary),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前位置',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandBlack,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '北京市朝阳区建国路88号 SOHO现代城附近',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          BaicBounceButton(
            onPressed: viewModel.requestRescue,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.brandBlack,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.alertTriangle, size: 20, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    '立即呼叫救援',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRescueOption(IconData icon, String label) {
    return BaicBounceButton(
      onPressed: () {},
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: AppColors.brandBlack),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestingView(RoadsideAssistanceViewModel viewModel) {
    return Container(
      key: const ValueKey('requesting'),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 50,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              color: AppColors.brandOrange,
              strokeWidth: 5,
              backgroundColor: Color(0xFFFFF7ED),
            ),
          ),
          SizedBox(height: 24),
          Text(
            '正在匹配救援力量...',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBlack,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '系统正在调度距离您最近的服务网点',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnRouteView(RoadsideAssistanceViewModel viewModel) {
    return Container(
      key: const ValueKey('en_route'),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 50,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '救援车已出发',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandBlack,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          '预计',
                          style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '${viewModel.arrivalTime}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oswald',
                              color: AppColors.brandOrange,
                              height: 1.0,
                            ),
                          ),
                        ),
                        const Text(
                          '分钟内到达',
                          style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(LucideIcons.navigation, size: 26, color: Color(0xFF10B981)),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://randomuser.me/api/portraits/men/32.jpg',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '王师傅',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '京A·9527 救援专车 · 4.9分',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              BaicBounceButton(
                onPressed: viewModel.contactDriver,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.brandBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.phone, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: BaicBounceButton(
                  onPressed: viewModel.cancelRescue,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '取消订单',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BaicBounceButton(
                  onPressed: viewModel.contactSupport,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '联系专员',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandOrange,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  RoadsideAssistanceViewModel viewModelBuilder(BuildContext context) =>
      RoadsideAssistanceViewModel();
}
