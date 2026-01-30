import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'car_order_viewmodel.dart';

class CarOrderView extends StackedView<CarOrderViewModel> {
  final CarModel car;
  final String? initialVersionId;

  const CarOrderView({
    super.key,
    required this.car,
    this.initialVersionId,
  });

  @override
  Widget builder(
    BuildContext context,
    CarOrderViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const _SkeletonView();
    }

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Stack(
        fit: StackFit.expand, // 强制 Stack 占满全屏
        children: [
          // 1. 背景展示区 (占比 45vh，给车更多呼吸空间)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: _VisualizerSection(viewModel: viewModel),
          ),

          // 2. 内容滚动区 (层级在 Header 之下)
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.42, // 向上覆盖，形成卡片堆叠感
            bottom: 0, 
            child: _ContentSection(viewModel: viewModel),
          ),

          // 3. 头部导航 (绝对定位，层级高)
          _HeaderSection(viewModel: viewModel),

          // 4. 底部操作栏 (层级最高)
          _BottomBar(viewModel: viewModel),
        ],
      ),
    );
  }

  @override
  CarOrderViewModel viewModelBuilder(BuildContext context) =>
      CarOrderViewModel(car: car, initialVersionId: initialVersionId);

  @override
  void onViewModelReady(CarOrderViewModel viewModel) => viewModel.init();
}

/// 头部导航组件
class _HeaderSection extends StatelessWidget {
  final CarOrderViewModel viewModel;
  const _HeaderSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPadding + 10,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaicBounceButton(
            onPressed: viewModel.previousStep,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  )
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: CarOrderViewModel.steps.map((step) {
                final isCurrent = viewModel.currentStep == step.id;
                final isDone = viewModel.currentStep > step.id;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.brandBlack : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isCurrent
                          ? Colors.white
                          : (isDone ? AppColors.brandBlack : Colors.grey[300]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 36), // 占位保持左右平衡
        ],
      ),
    );
  }
}

/// 视觉展示组件 (动态修改 SVG)
class _VisualizerSection extends StatelessWidget {
  final CarOrderViewModel viewModel;
  const _VisualizerSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      color: AppColors.bgCanvas,
      padding: const EdgeInsets.only(top: 40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 渐变光晕
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.white.withValues(alpha: 0.8), Colors.transparent],
                radius: 0.6,
              ),
            ),
          ),
          
          // 根据步骤显示不同内容
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildVisualContent(context),
          ),

          // 车型选配标签 (仅在非确认页展示)
          if (viewModel.currentStep != 4)
            Positioned(
              bottom: 60,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.selectedTrim.name,
                      style: AppTypography.headingS.copyWith(
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      viewModel.selectedColor.name,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          
          // 底部模糊阴影 - 已移除
        ],
      ),
    );
  }

  Widget _buildVisualContent(BuildContext context) {
    if (viewModel.currentStep == 2) {
      // 步骤 2: 显示内饰
      return Column(
        key: const ValueKey('interior'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SeatVector(colorHex: viewModel.selectedInterior.hex ?? '#000000'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              '${viewModel.selectedInterior.name}主题',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }

    // 默认或步骤 1, 3: 显示外饰 (SVG)
    return Padding(
      key: const ValueKey('exterior'),
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 投影 - 已移除
          // 车辆 SVG (动态变色模拟)
          _CarSvgVisualizer(
            colorId: viewModel.selectedColor.id,
            wheelId: viewModel.selectedWheel.id,
          ),
        ],
      ),
    );
  }
}

/// 车辆 SVG 渲染器 - 实现同原型中的 RGB 动态替换逻辑
class _CarSvgVisualizer extends StatelessWidget {
  final String colorId;
  final String wheelId;

  const _CarSvgVisualizer({required this.colorId, required this.wheelId});

  @override
  Widget build(BuildContext context) {
    // 根据颜色 ID 提供对应的 RGB 方案
    final palette = _getPalette(colorId);

    return FutureBuilder<String>(
      // 注意：这里假设 bj40.svg 存在于 assets。实际开发中需确保路径正确。
      // 为保证演示，如果加载失败，在此放置一个占位图。
      future: DefaultAssetBundle.of(context).loadString('assets/images/BJ40.svg').catchError((e) => ""),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // 如果没找到 SVG 资源，显示原型中的占位方案
          return Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'BJ40 3D Vector\n(Asset Loading...)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        String svgContent = snapshot.data!;
        
        // 执行正则替换 (模拟 React 中的逻辑)
        // 1. Main Body: rgb(241, 137, 33)
        svgContent = svgContent.replaceAll(RegExp(r'rgb\(\s*241\s*,\s*137\s*,\s*33\s*\)', caseSensitive: false), palette['main']!);
        // 2. Shadow: rgb(195, 92, 6)
        svgContent = svgContent.replaceAll(RegExp(r'rgb\(\s*195\s*,\s*92\s*,\s*6\s*\)', caseSensitive: false), palette['shadow']!);
        // 3. Highlight: rgb(227, 149, 65)
        svgContent = svgContent.replaceAll(RegExp(r'rgb\(\s*227\s*,\s*149\s*,\s*65\s*\)', caseSensitive: false), palette['highlight']!);
        // 4. Background: rgb(253, 253, 253) -> transparent
        svgContent = svgContent.replaceAll(RegExp(r'rgb\(\s*253\s*,\s*253\s*,\s*253\s*\)', caseSensitive: false), 'none');

        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SvgPicture.string(
            svgContent,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Map<String, String> _getPalette(String id) {
    switch (id) {
      case 'black':
        return {
          'main': 'rgb(38, 38, 38)',
          'shadow': 'rgb(10, 10, 10)',
          'highlight': 'rgb(80, 80, 80)',
        };
      case 'white':
        return {
          'main': 'rgb(235, 235, 235)',
          'shadow': 'rgb(160, 160, 160)',
          'highlight': 'rgb(255, 255, 255)',
        };
      case 'green':
        return {
          'main': 'rgb(74, 93, 72)',
          'shadow': 'rgb(40, 50, 40)',
          'highlight': 'rgb(110, 130, 105)',
        };
      case 'orange':
      default:
        return {
          'main': 'rgb(241, 137, 33)',
          'shadow': 'rgb(195, 92, 6)',
          'highlight': 'rgb(227, 149, 65)',
        };
    }
  }
}

/// 内容区组件
class _ContentSection extends StatelessWidget {
  final CarOrderViewModel viewModel;
  const _ContentSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildStepContent(context),
          const SizedBox(height: 140), // 底部留白，防止被 BottomBar 遮挡
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (viewModel.currentStep) {
      case 0: // 版本选择
        return Column(
          children: viewModel.car.versions.values.map((v) {
            final isSelected = viewModel.selectedTrim.name == v.name;
            return BaicBounceButton(
              onPressed: () => viewModel.selectTrim(v),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.brandBlack : Colors.transparent,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isSelected ? 0.1 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.brandBlack : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            children: v.features.take(2).map((f) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCanvas,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(f, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '¥${v.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: AppTypography.priceMain.copyWith(
                            fontSize: 18,
                            color: isSelected ? AppColors.brandOrange : AppColors.brandBlack,
                          ),
                        ),
                      ],
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle, color: AppColors.brandBlack, size: 20),
                    ]
                  ],
                ),
              ),
            );
          }).toList(),
        );

      case 1: // 外观选择
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.palette_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('选择外观', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: viewModel.colors.length,
                itemBuilder: (context, index) {
                  final color = viewModel.colors[index];
                  final isSelected = viewModel.selectedColor.id == color.id;
                  return BaicBounceButton(
                    onPressed: () => viewModel.selectColor(color),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(int.parse(color.hex!.replaceAll('#', '0xFF'))),
                            border: Border.all(
                              color: isSelected ? AppColors.brandBlack : Colors.grey[200]!,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(color: AppColors.brandBlack.withOpacity(0.1), blurRadius: 10)]
                                : null,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: isSelected
                              ? const Center(child: Icon(Icons.check, color: Colors.white, size: 16))
                              : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );

      case 2: // 内饰选择
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.layers_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('选择内饰', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              ...viewModel.interiorColors.map((interior) {
                final isSelected = viewModel.selectedInterior.id == interior.id;
                return BaicBounceButton(
                  onPressed: () => viewModel.selectInterior(interior),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.bgCanvas : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? AppColors.brandBlack : Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(interior.hex!.replaceAll('#', '0xFF'))),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(interior.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (isSelected) const Icon(Icons.check, size: 16, color: AppColors.brandBlack),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );

      case 3: // 轮毂选择
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.adjust, size: 18),
                  SizedBox(width: 8),
                  Text('选择轮毂', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: viewModel.wheels.length,
                itemBuilder: (context, index) {
                  final wheel = viewModel.wheels[index];
                  final isSelected = viewModel.selectedWheel.id == wheel.id;
                  return BaicBounceButton(
                    onPressed: () => viewModel.selectWheel(wheel),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.bgCanvas : AppColors.bgCanvas.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? AppColors.brandBlack : Colors.transparent, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: _WheelVector(wheelId: wheel.id),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            wheel.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );

      case 4: // 确认汇总
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_user_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('配置清单', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SummaryRow(label: '车型版本', value: viewModel.selectedTrim.name),
                  _SummaryRow(label: '外观颜色', value: viewModel.selectedColor.name),
                  _SummaryRow(label: '内饰主题', value: viewModel.selectedInterior.name),
                  _SummaryRow(label: '轮毂规格', value: viewModel.selectedWheel.name),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: viewModel.toggleFinanceExpanded,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.credit_card, size: 18),
                            SizedBox(width: 8),
                            Text('金融方案估算', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Icon(
                          viewModel.isFinanceExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.isFinanceExpanded) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: '首付 (10%)',
                      value: '¥${viewModel.downPayment.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      isValuePrice: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('预计月供', style: TextStyle(fontSize: 13)),
                        Text(
                          '¥${viewModel.monthlyPayment.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: AppTypography.priceMain.copyWith(fontSize: 20, color: AppColors.brandOrange),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}

/// 底部栏组件
class _BottomBar extends StatelessWidget {
  final CarOrderViewModel viewModel;
  const _BottomBar({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 16, 24, bottomPadding + 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[100]!)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 30,
              offset: const Offset(0, -8),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('预计总价', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text('¥', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.brandOrange)),
                      const SizedBox(width: 2),
                      Text(
                        viewModel.totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                        style: AppTypography.priceMain.copyWith(fontSize: 28, color: AppColors.brandOrange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (viewModel.currentStep == 4) ...[
              BaicBounceButton(
                onPressed: viewModel.saveToWishlist,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: const Icon(Icons.favorite_border, color: AppColors.brandOrange, size: 20),
                ),
              ),
              const SizedBox(width: 12),
            ],
            BaicBounceButton(
              onPressed: viewModel.nextStep,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: AppColors.brandBlack,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Text(
                      viewModel.currentStep == 4 ? '立即订购' : '下一步',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 辅助组件: 汇总行
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isValuePrice;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isValuePrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            value,
            style: isValuePrice
                ? AppTypography.priceMain.copyWith(fontSize: 14)
                : const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// 辅助组件: 内饰座椅矢量图
class _SeatVector extends StatelessWidget {
  final String colorHex;
  const _SeatVector({required this.colorHex});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    return SizedBox(
      width: 200,
      height: 200,
      child: SvgPicture.string(
        '''
        <svg width="200" height="200" viewBox="0 0 200 200" fill="none">
          <path d="M70 40C70 34.4772 74.4772 30 80 30H120C125.523 30 130 34.4772 130 40V60H70V40Z" fill="${_toRgb(color)}" />
          <path d="M60 65C60 62.2386 62.2386 60 65 60H135C137.761 60 140 62.2386 140 65V140C140 151.046 131.046 160 120 160H80C68.9543 160 60 151.046 60 140V65Z" fill="${_toRgb(color)}" />
        </svg>
        ''',
      ),
    );
  }

  String _toRgb(Color c) => 'rgb(${c.red},${c.green},${c.blue})';
}

/// 辅助组件: 轮毂矢量图
class _WheelVector extends StatelessWidget {
  final String wheelId;
  const _WheelVector({required this.wheelId});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
      <svg viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="48" fill="#1A1A1A" />
        <circle cx="50" cy="50" r="32" fill="#000" stroke="#333" stroke-width="1" />
        ${wheelId == '18' 
          ? '<circle cx="50" cy="50" r="28" fill="#2A2A2A" stroke="#555" stroke-width="2" stroke-dasharray="4 2"/><circle cx="50" cy="50" r="8" fill="#111" />'
          : '<circle cx="50" cy="50" r="30" fill="#111" stroke="#333" stroke-width="1"/><circle cx="50" cy="50" r="5" fill="#000" />'}
      </svg>
      ''',
    );
  }
}

/// 骨架屏
class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BaicSkeleton(width: 36, height: 36, radius: 100),
                BaicSkeleton(width: MediaQuery.of(context).size.width * 0.5, height: 36, radius: 100),
                const SizedBox(width: 36),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const BaicSkeleton(width: 300, height: 200, radius: 16),
          const SizedBox(height: 60),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: const BaicSkeleton(width: double.infinity, height: 100, radius: 16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BaicSkeleton(width: 100, height: 40),
                BaicSkeleton(width: MediaQuery.of(context).size.width * 0.4, height: 48, radius: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
