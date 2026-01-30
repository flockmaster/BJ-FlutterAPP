import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/ui_converters.dart';
import 'trade_in_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 置换购车服务页面 - 严格遵循 BAIC 架构规范
/// 架构规范: .rules (Stacked MVVM + AppColors + BaicBounceButton)
/// [TradeInView] - 置换购车主入口（以旧换新全链路引导）
/// 
/// 视觉设计标准：
/// 1. 业务色调：采用品牌强调色作为 Header 背景，强化“置换无忧”的心智。
/// 2. 引导式流程：垂直点阵步进器，清晰展示“车辆评估 -> 二手车报价 -> 签约过户”路径。
/// 3. 表单直达：底部固定 Action 栏，引导用户快速提交置换意向。
class TradeInView extends StackedView<TradeInViewModel> {
  const TradeInView({super.key});

  @override
  TradeInViewModel viewModelBuilder(BuildContext context) => TradeInViewModel();

  @override
  void onViewModelReady(TradeInViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(BuildContext context, TradeInViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context, viewModel),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Column(
                    children: [
                      _buildProcessSection(viewModel),
                      _buildFormSection(viewModel),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomAction(context, viewModel),
          ),
        ],
      ),
    );
  }

  /// 构建极具品牌辨识度的 Header（含水印背景与磨砂白文字）
  Widget _buildHeader(BuildContext context, TradeInViewModel viewModel) {
    return Container(
      color: AppColors.error,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative Icon (Watermark)
          Positioned(
             right: -40,
             bottom: -40,
             child: Transform.rotate(
               angle: -15 * 3.14159 / 180,
               child: Icon(
                 Icons.directions_car,
                 size: 240,
                 color: AppColors.bgSurface.withOpacity(0.1),
               ),
             ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BaicBounceButton(
                  onPressed: () => viewModel.goBack(),
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                ),
                const Text(
                  '北汽车主置换购车服务',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                ),
                BaicBounceButton(
                  onPressed: viewModel.handleSharePressed,
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建可视化的置换流程步进器 (Dotted Line + Step Icons)
  Widget _buildProcessSection(TradeInViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        children: [
          const Text(
            '非本品置换流程',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          Stack(
            children: [
              // Vertical Dotted Line
              Positioned(
                left: 6.5,
                top: 12,
                bottom: 40,
                child: CustomPaint(
                  size: const Size(1, double.infinity),
                  painter: _DottedLinePainter(color: AppColors.borderPrimary),
                ),
              ),
              Column(
                children: [
                  _buildStepItem(
                    title: '车辆评估',
                    content: '在您选购新车时，如您有二手车出售需求，北京汽车为您提供专业的二手车置换服务，北京汽车将会安排优质的官方合作服务商，为您提供车辆的评估和检测服务。',
                    hasButton: true,
                    onButtonPressed: viewModel.handleFreeEvaluationPressed,
                  ),
                  const SizedBox(height: 40),
                  _buildStepItem(
                    title: '二手车报价',
                    content: '北京汽车通过官方合作服务商，依据市场行情及车况评估结果，为您提供具有市场竞争力的二手车收购价格。',
                  ),
                  const SizedBox(height: 40),
                  _buildStepItem(
                    title: '签约过户',
                    content: '新车交付前，您可以自主选择二手车的过户时间，北京汽车的官方合作服务商将为您支付车款并办理车辆过户。',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({required String title, required String content, bool hasButton = false, VoidCallback? onButtonPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
           // Dot
           Positioned(
             left: -24,
             top: 6,
             child: Container(
               width: 14,
               height: 14,
               decoration: const BoxDecoration(
                 color: AppColors.borderPrimary,
                 shape: BoxShape.circle,
               ),
             ),
           ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
               const SizedBox(height: 8),
               Text(
                 content,
                 textAlign: TextAlign.justify,
                 style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
               ),
               hasButton.visible(
                 Column(
                   children: [
                     const SizedBox(height: 12),
                     BaicBounceButton(
                       onPressed: onButtonPressed,
                       child: Container(
                         decoration: BoxDecoration(
                           border: Border.all(color: AppColors.error),
                           borderRadius: BorderRadius.circular(16),
                         ),
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                         child: const Text('免费在线评估 >', style: TextStyle(fontSize: 13, color: AppColors.error)),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
        ],
      ),
    );
  }

  /// 构建关键置换意向收集表单 (城市/联系方式预填)
  Widget _buildFormSection(TradeInViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            '填写申请信息',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          _buildFormRow('所在城市', viewModel.city, hasArrow: true),
          _buildFormRow('联系电话', viewModel.phone),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '提交申请后，工作人员会尽快与您取得联系',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormRow(String label, String value, {bool hasArrow = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.bgCanvas)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              hasArrow.visible(
                const Row(
                  children: [
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.textDisabled),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, TradeInViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(top: BorderSide(color: AppColors.bgCanvas)),
      ),
      child: BaicBounceButton(
        onPressed: viewModel.isSubmitting ? null : viewModel.handleSubmitApplication,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: viewModel.isSubmitting ? AppColors.textDisabled : AppColors.brandDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: viewModel.isSubmitting.visible(
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ).orElse(
              const Text('申请置换', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + 4), paint);
      startY += 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}