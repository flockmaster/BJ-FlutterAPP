import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'bind_vehicle_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 绑定车辆页面 - 严格遵循 BAIC 架构规范
/// 架构规范: .rules (Stacked MVVM + AppColors + BaicBounceButton)
class BindVehicleView extends StackedView<BindVehicleViewModel> {
  const BindVehicleView({super.key});

  @override
  Widget builder(BuildContext context, BindVehicleViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(viewModel),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildTitle(),
                const SizedBox(height: 32),
                _buildVINInput(viewModel),
                const SizedBox(height: 16),
                _buildPlateNumberInput(viewModel),
                const SizedBox(height: 32),
                _buildTips(),
                const SizedBox(height: 32),
                _buildSubmitButton(context, viewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BindVehicleViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 54, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderPrimary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaicBounceButton(
            onPressed: () => viewModel.goBack(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.centerLeft,
              child: Icon(
                LucideIcons.arrowLeft,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '绑定车辆',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '添加我的车辆',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '请输入车辆信息以完成绑定',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildVINInput(BindVehicleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '车架号 (VIN)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: viewModel.vinError != null 
                ? AppColors.error 
                : AppColors.borderPrimary,
              width: 1,
            ),
          ),
          child: TextField(
            controller: viewModel.vinController,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontFamily: 'Oswald',
            ),
            decoration: InputDecoration(
              hintText: '请输入17位车架号',
              hintStyle: TextStyle(
                fontSize: 15,
                color: AppColors.textTertiary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: viewModel.vinController.text.isNotEmpty
                ? BaicBounceButton(
                    onPressed: () => viewModel.clearVIN(),
                    child: Icon(
                      LucideIcons.x,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                  )
                : null,
            ),
            textCapitalization: TextCapitalization.characters,
            maxLength: 17,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
            onChanged: (value) => viewModel.onVINChanged(value),
          ),
        ),
        if (viewModel.vinError != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                LucideIcons.alertCircle,
                size: 14,
                color: AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                viewModel.vinError!,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPlateNumberInput(BindVehicleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '车牌号',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderPrimary,
              width: 1,
            ),
          ),
          child: TextField(
            controller: viewModel.plateController,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontFamily: 'Oswald',
            ),
            decoration: InputDecoration(
              hintText: '选填，如：京A·12345',
              hintStyle: TextStyle(
                fontSize: 15,
                color: AppColors.textTertiary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: viewModel.plateController.text.isNotEmpty
                ? BaicBounceButton(
                    onPressed: () => viewModel.clearPlate(),
                    child: Icon(
                      LucideIcons.x,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                  )
                : null,
            ),
            textCapitalization: TextCapitalization.characters,
            maxLength: 10,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
            onChanged: (value) => viewModel.onPlateChanged(value),
          ),
        ),
      ],
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.lightbulb,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                '温馨提示',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('车架号可在行驶证、车辆铭牌或保险单上找到'),
          const SizedBox(height: 8),
          _buildTipItem('绑定后需要1-2个工作日审核，请耐心等待'),
          const SizedBox(height: 8),
          _buildTipItem('审核通过后可享受远程控制、维保预约等服务'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: AppColors.warning,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, BindVehicleViewModel viewModel) {
    final isValid = viewModel.isFormValid;
    
    return BaicBounceButton(
      onPressed: isValid && !viewModel.isBusy
        ? () => viewModel.submitBinding(context)
        : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isValid ? AppColors.brandDark : AppColors.bgFill,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isValid ? [
            BoxShadow(
              color: AppColors.shadowBase.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : [],
        ),
        child: Center(
          child: viewModel.isBusy
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.bgSurface),
                ),
              )
            : Text(
                '提交绑定申请',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isValid ? AppColors.bgSurface : AppColors.textTertiary,
                ),
              ),
        ),
      ),
    );
  }

  @override
  BindVehicleViewModel viewModelBuilder(BuildContext context) => BindVehicleViewModel();

  @override
  void onViewModelReady(BindVehicleViewModel viewModel) => viewModel.init();

  @override
  void onDispose(BindVehicleViewModel viewModel) => viewModel.dispose();
}
