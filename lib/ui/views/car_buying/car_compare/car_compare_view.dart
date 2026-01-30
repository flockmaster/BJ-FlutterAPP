import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../core/components/baic_ui_kit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/models/car_model.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart' as skeleton;
import 'car_compare_viewmodel.dart';

/// 车型对比页面
/// 遵循 BAIC 架构规范：
/// - ViewModel: 继承 BaicBaseViewModel
/// - View: 使用 ViewModelBuilder.reactive()
/// - 颜色: 只使用 AppColors
/// - 字体: 数字使用 Oswald (AppTypography)
/// - 按钮: 必须使用 BaicBounceButton 包裹
/// - 加载状态: 使用 _SkeletonView
class CarCompareView extends StackedView<CarCompareViewModel> {
  final CarModel initialModel;
  final List<CarModel> allModels;

  const CarCompareView({
    super.key,
    required this.initialModel,
    required this.allModels,
  });

  @override
  CarCompareViewModel viewModelBuilder(BuildContext context) =>
      CarCompareViewModel();

  @override
  void onViewModelReady(CarCompareViewModel viewModel) {
    viewModel.init(initialModel, allModels);
  }

  @override
  Widget builder(
    BuildContext context,
    CarCompareViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: AppColors.bgSurface,
        body: _SkeletonView(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: Column(
        children: [
          // Header
          _buildHeader(context, viewModel),
          
          // Main Content
          Expanded(
            child: _buildContent(context, viewModel),
          ),
        ],
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildHeader(BuildContext context, CarCompareViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: AppDimensions.spaceML,
        right: AppDimensions.spaceML,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderPrimary,
            width: AppDimensions.borderWidthThin,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮
          BaicBounceButton(
            onPressed: () => viewModel.navigateBack(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: AppDimensions.iconL,
                color: AppColors.textTitle,
              ),
            ),
          ),
          
          // 标题
          Text(
            '车型对比',
            style: AppTypography.headingS.copyWith(
              color: AppColors.textTitle,
            ),
          ),
          
          // 隐藏相同按钮
          BaicBounceButton(
            onPressed: () => viewModel.toggleHideSame(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: viewModel.hideSame
                    ? AppColors.brandBlack
                    : AppColors.bgFill,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    viewModel.hideSame
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 14,
                    color: viewModel.hideSame
                        ? AppColors.textInverse
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    viewModel.hideSame ? '显示全部' : '隐藏相同',
                    style: AppTypography.label.copyWith(
                      color: viewModel.hideSame
                          ? AppColors.textInverse
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
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

  /// 构建主要内容
  Widget _buildContent(BuildContext context, CarCompareViewModel viewModel) {
    return Stack(
      children: [
        Column(
          children: [
            // 车型信息头部（固定）
            _buildCarHeader(viewModel),
            
            // 参数对比列表
            Expanded(
              child: _buildComparisonList(viewModel),
            ),
          ],
        ),
        
        // 添加车型弹窗
        if (viewModel.showAddModal)
          _buildAddModelModal(context, viewModel),
      ],
    );
  }

  /// 构建车型信息头部
  Widget _buildCarHeader(CarCompareViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderPrimary,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        boxShadow: AppDimensions.shadowL1,
      ),
      child: Row(
        children: [
          // 左侧标签列
          Container(
            width: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.bgFill,
                  width: AppDimensions.borderWidthThin,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '车型信息',
                style: AppTypography.label.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // 车型列
          Expanded(
            child: Row(
              children: List.generate(2, (index) {
                if (index >= viewModel.selectedModels.length) {
                  // 添加车型按钮
                  return Expanded(
                    child: _buildAddCarButton(viewModel),
                  );
                }
                
                final car = viewModel.selectedModels[index];
                return Expanded(
                  child: _buildCarColumn(car, viewModel, index),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建车型列
  Widget _buildCarColumn(
    CarModel car,
    CarCompareViewModel viewModel,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          right: index == 0
              ? BorderSide(
                  color: Colors.transparent,
                  width: AppDimensions.borderWidthThin,
                )
              : BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          // 车型图片
          Stack(
            children: [
              SizedBox(
                height: 60,
                child: OptimizedImage(
                  imageUrl: car.backgroundImage,
                  fit: BoxFit.contain,
                ),
              ),
              
              // 删除按钮
              if (viewModel.selectedModels.length > 1)
                Positioned(
                  top: -4,
                  right: -4,
                  child: BaicBounceButton(
                    onPressed: () => viewModel.removeModel(car),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.bgFill,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 车型名称
          Text(
            car.name,
            style: AppTypography.headingS.copyWith(
              fontSize: 13,
              color: AppColors.textTitle,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          // 价格
          Text(
            '¥${car.price}',
            style: AppTypography.dataDisplayS.copyWith(
              color: AppColors.brandOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建添加车型按钮
  Widget _buildAddCarButton(CarCompareViewModel viewModel) {
    return BaicBounceButton(
      onPressed: () => viewModel.setShowAddModal(true),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderPrimary,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: const Icon(
                Icons.add,
                size: AppDimensions.iconM,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '添加车型',
              style: AppTypography.label.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建参数对比列表
  Widget _buildComparisonList(CarCompareViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceL),
      children: [
        _buildCategory(
          '基本参数',
          [
            _CompareItem(label: '参考价格', specKey: 'price'),
            _CompareItem(label: '车身结构', specKey: 'structure'),
            _CompareItem(label: '发动机', specKey: 'engine'),
            _CompareItem(label: '变速箱', specKey: 'transmission'),
          ],
          viewModel,
        ),
        _buildCategory(
          '车身尺寸',
          [
            _CompareItem(label: '长*宽*高(mm)', specKey: 'size'),
            _CompareItem(label: '轴距(mm)', specKey: 'wheelbase'),
            _CompareItem(label: '最小离地间隙', specKey: 'ground_clearance'),
          ],
          viewModel,
        ),
        _buildCategory(
          '越野性能',
          [
            _CompareItem(label: '驱动方式', specKey: 'drive_mode'),
            _CompareItem(label: '接近/离去角', specKey: 'angles'),
            _CompareItem(label: '差速锁', specKey: 'diff_lock'),
          ],
          viewModel,
        ),
        _buildCategory(
          '智能配置',
          [
            _CompareItem(label: '屏幕尺寸', specKey: 'screen'),
            _CompareItem(label: '辅助驾驶', specKey: 'adas'),
            _CompareItem(label: '扬声器系统', specKey: 'speaker'),
            _CompareItem(label: '座椅材质', specKey: 'seat'),
          ],
          viewModel,
        ),
      ],
    );
  }

  /// 构建分类
  Widget _buildCategory(
    String title,
    List<_CompareItem> items,
    CarCompareViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分类标题
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceML,
            vertical: 8,
          ),
          color: AppColors.bgFill,
          child: Text(
            title,
            style: AppTypography.label.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // 参数行
        ...items.map((item) {
          final isDiff = viewModel.isDifferent(item.specKey);
          
          // 如果隐藏相同且参数相同，则不显示
          if (viewModel.hideSame && !isDiff) {
            return const SizedBox.shrink();
          }
          
          return _buildCompareRow(item, isDiff, viewModel);
        }),
      ],
    );
  }

  /// 构建对比行
  Widget _buildCompareRow(
    _CompareItem item,
    bool isDifferent,
    CarCompareViewModel viewModel,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.bgFill,
            width: AppDimensions.borderWidthThin,
          ),
        ),
      ),
      child: Row(
        children: [
          // 参数名称
          Container(
            width: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              border: Border(
                right: BorderSide(
                  color: AppColors.bgFill,
                  width: AppDimensions.borderWidthThin,
                ),
              ),
            ),
            child: Text(
              item.label,
              style: AppTypography.captionPrimary.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          
          // 参数值
          Expanded(
            child: Row(
              children: List.generate(2, (index) {
                String value = '-';
                
                if (index < viewModel.selectedModels.length) {
                  value = viewModel.getSpecValue(
                    viewModel.selectedModels[index].modelKey,
                    item.specKey,
                  );
                }
                
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDifferent &&
                              index < viewModel.selectedModels.length &&
                              viewModel.selectedModels.length == 2
                          ? AppColors.brandOrange.withValues(alpha: 0.05)
                          : AppColors.bgSurface,
                    ),
                    child: Text(
                      value,
                      style: AppTypography.bodySecondary.copyWith(
                        fontSize: 13,
                        color: AppColors.textTitle,
                        fontWeight: isDifferent &&
                                index < viewModel.selectedModels.length &&
                                viewModel.selectedModels.length == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建添加车型弹窗
  Widget _buildAddModelModal(
    BuildContext context,
    CarCompareViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () => viewModel.setShowAddModal(false),
      child: Container(
        color: AppColors.bgOverlay.withValues(alpha: 0.6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {}, // 阻止点击穿透
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusL),
                      topRight: Radius.circular(AppDimensions.radiusL),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 弹窗头部
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.borderPrimary,
                              width: AppDimensions.borderWidthThin,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '选择对比车型',
                              style: AppTypography.headingS.copyWith(
                                color: AppColors.textTitle,
                              ),
                            ),
                            BaicBounceButton(
                              onPressed: () => viewModel.setShowAddModal(false),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.bgFill,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusFull,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 车型列表
                      Flexible(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: viewModel.availableModels.length,
                          itemBuilder: (context, index) {
                            final car = viewModel.availableModels[index];
                            final isSelected = viewModel.selectedModels
                                .any((m) => m.id == car.id);
                            
                            return BaicBounceButton(
                              onPressed: isSelected
                                  ? null
                                  : () => viewModel.addModel(car),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.bgFill
                                      : AppColors.bgSurface,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.borderPrimary
                                        : AppColors.borderPrimary,
                                    width: AppDimensions.borderWidthThin,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusM,
                                  ),
                                  boxShadow: isSelected
                                      ? null
                                      : AppDimensions.shadowL1,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: OptimizedImage(
                                        imageUrl: car.backgroundImage,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      car.name,
                                      style: AppTypography.headingS.copyWith(
                                        fontSize: 14,
                                        color: AppColors.textTitle,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '¥${car.price}',
                                      style: AppTypography.dataDisplayXS.copyWith(
                                        color: AppColors.brandOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 骨架屏
class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return skeleton.SkeletonLoader(
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: AppDimensions.spaceML,
              right: AppDimensions.spaceML,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const skeleton.SkeletonCircle(size: 36),
                skeleton.SkeletonBox(
                  width: 80,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
                skeleton.SkeletonBox(
                  width: 100,
                  height: 32,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ],
            ),
          ),
          
          // Car Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                skeleton.SkeletonBox(
                  width: 100,
                  height: 100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: skeleton.SkeletonBox(
                          height: 100,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: skeleton.SkeletonBox(
                          height: 100,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // List Items
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      skeleton.SkeletonBox(
                        width: 100,
                        height: 40,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusS,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: skeleton.SkeletonBox(
                                height: 40,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: skeleton.SkeletonBox(
                                height: 40,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 对比项数据类
class _CompareItem {
  final String label;
  final String specKey;

  const _CompareItem({
    required this.label,
    required this.specKey,
  });
}
