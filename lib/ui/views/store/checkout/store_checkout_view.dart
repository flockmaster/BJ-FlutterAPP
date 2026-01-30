import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'store_checkout_viewmodel.dart';
import '../../../../core/theme/app_dimensions.dart';

/// 结算页面 - 像素级还原原型，支持三种商品类型
class StoreCheckoutView extends StackedView<StoreCheckoutViewModel> {
  final List<Map<String, dynamic>> items;

  const StoreCheckoutView({super.key, required this.items});

  @override
  StoreCheckoutViewModel viewModelBuilder(BuildContext context) => 
      StoreCheckoutViewModel(items: items);

  @override
  void onViewModelReady(StoreCheckoutViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(BuildContext context, StoreCheckoutViewModel viewModel, Widget? child) {
    // 支付处理中
    if (viewModel.step == CheckoutStep.paying) {
      return _buildPayingScreen();
    }

    // 支付成功
    if (viewModel.step == CheckoutStep.success) {
      return _buildSuccessScreen(context, viewModel);
    }

    // 确认订单
    return _buildConfirmScreen(context, viewModel);
  }

  /// 确认订单页面
  Widget _buildConfirmScreen(BuildContext context, StoreCheckoutViewModel viewModel) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // 顶部栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: viewModel.goBack,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Icon(LucideIcons.arrowLeft, size: 24),
                    ),
                  ),
                  const Text(
                    '确认订单',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // 内容区域
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 60,
            bottom: 0,
            child: ListView(
              padding: EdgeInsets.only(
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 140,
              ),
              children: [
                // 1. 地址信息
                if (viewModel.orderType == 'physical')
                  _buildAddressSection(viewModel, context),
                
                const SizedBox(height: 12),

                // 2. 商品信息
                _buildProductSection(viewModel),
                
                const SizedBox(height: 12),

                // 3. 优惠券和积分
                _buildAssetsSection(viewModel, context),
                
                const SizedBox(height: 12),

                // 4. 发票
                _buildInvoiceSection(viewModel),
                
                const SizedBox(height: 12),

                // 5. 价格明细
                _buildPriceBreakdown(viewModel),
                
                const SizedBox(height: 12),

                // 6. 协议
                _buildAgreementSection(viewModel),
              ],
            ),
          ),

          // 底部操作栏
          _buildBottomBar(context, viewModel),
        ],
      ),
    );
  }

  /// 地址选择区域（物理商品）
  Widget _buildAddressSection(StoreCheckoutViewModel viewModel, BuildContext context) {
    final address = viewModel.selectedAddress;
    if (address == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => viewModel.selectAddress(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.mapPin,
                size: 20,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.contactName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        address.maskedPhone,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                          fontFamily: 'Oswald',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '默认',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.fullAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }

  /// 商品信息区域
  Widget _buildProductSection(StoreCheckoutViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.shoppingBag,
                size: 12,
                color: Color(0xFF9CA3AF),
              ),
              SizedBox(width: 8),
              Text(
                '北京汽车官方自营',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...viewModel.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < viewModel.items.length - 1 ? 24 : 0,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 72,
                      height: 72,
                      color: const Color(0xFFF5F7FA),
                      child: CachedNetworkImage(
                        imageUrl: item['product'].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 72,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['product'].title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111111),
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['spec'].toString().toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'x${item['quantity']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD1D5DB),
                                  fontFamily: 'Oswald',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '¥${item['product'].price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oswald',
                              color: Color(0xFF111111),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF9FAFB)),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '配送方式',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '顺丰速运 · 免运费',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 价格明细
  Widget _buildPriceBreakdown(StoreCheckoutViewModel viewModel) {
    final rewardPoints = (viewModel.finalTotal / 10).floor();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow('商品总额', viewModel.productTotal),
          const SizedBox(height: 16),
          _buildPriceRow('运费', 0, isShipping: true),
          const SizedBox(height: 16),
          _buildPriceRow('优惠券', -viewModel.couponDiscount, isDiscount: true),
          if (viewModel.pointsDiscount > 0) ...[
            const SizedBox(height: 16),
            _buildPriceRow('积分抵扣', -viewModel.pointsDiscount, isDiscount: true),
          ],
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFF9FAFB),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '实付款',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      border: Border.all(color: const Color(0xFFFFE0B2)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '返 ',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                        Text(
                          '$rewardPoints',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                        const Text(
                          ' 积分',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '¥${viewModel.finalTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald',
                  color: Color(0xFFFF6B00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false, bool isShipping = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9CA3AF),
          ),
        ),
        Text(
          isShipping && amount == 0
              ? '免运费'
              : '¥${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oswald',
            color: isShipping && amount == 0
                ? const Color(0xFF10B981)
                : (isDiscount ? const Color(0xFFFF6B00) : const Color(0xFF111111)),
          ),
        ),
      ],
    );
  }

  /// 协议区域
  Widget _buildAgreementSection(StoreCheckoutViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: viewModel.toggleAgreement,
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: viewModel.agreedToTerms
                    ? const Color(0xFF111111)
                    : Colors.white,
                border: Border.all(
                  color: viewModel.agreedToTerms
                      ? const Color(0xFF111111)
                      : const Color(0xFFD1D5DB),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: viewModel.agreedToTerms
                  ? const Icon(
                      LucideIcons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '我已阅读并同意 '),
                  TextSpan(
                    text: '《北京汽车商城服务协议》',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '、'),
                  TextSpan(
                    text: '《发票规则》',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' 及隐私条款。'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 底部操作栏
  Widget _buildBottomBar(BuildContext context, StoreCheckoutViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFF0F0F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '合计金额',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '¥',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald',
                        color: Color(0xFFFF6B00),
                      ),
                    ),
                    Text(
                      viewModel.finalTotal.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald',
                        color: Color(0xFFFF6B00),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                await viewModel.submitOrder();
                if (viewModel.orderId != null && context.mounted) {
                  await viewModel.showPaymentMethodSheet();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 56,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppDimensions.borderRadiusFull,
                  color: const Color(0xFF111111),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  '立即支付',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 支付处理中页面
  Widget _buildPayingScreen() {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 40,
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF111111)),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '正在处理支付请求...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 支付成功页面
  Widget _buildSuccessScreen(BuildContext context, StoreCheckoutViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.checkCircle2,
                  size: 44,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '支付成功',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),
              if (viewModel.orderType == 'service')
                _buildServiceSuccessInfo(viewModel)
              else if (viewModel.orderType == 'virtual')
                _buildVirtualSuccessInfo(viewModel)
              else
                _buildPhysicalSuccessInfo(viewModel),
              const SizedBox(height: 40),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => viewModel.viewOrderDetail(),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: AppDimensions.borderRadiusFull,
                        color: const Color(0xFF111111),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '查看订单详情',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => viewModel.backToStore(),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: AppDimensions.borderRadiusFull,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '回到商城',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceSuccessInfo(StoreCheckoutViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.qrCode,
              size: 120,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '服务核销码',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '8930 2931',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oswald',
              letterSpacing: 4,
              color: Color(0xFF111111),
            ),
          ),
          if (viewModel.appointmentDate != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                '预约时间: ${viewModel.appointmentDate}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVirtualSuccessInfo(StoreCheckoutViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          const Text(
            '卡券兑换码',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Text(
              'ABCD-1234-EFGH',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
                letterSpacing: 2,
                color: Color(0xFF111111),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalSuccessInfo(StoreCheckoutViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '支付方式',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                viewModel.paymentMethod == 'wechat' ? '微信支付' : '支付宝',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '实付金额',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '¥',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald',
                        color: Color(0xFF111111),
                      ),
                    ),
                    Text(
                      viewModel.finalTotal.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald',
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 优惠券和积分区域（合并）
  Widget _buildAssetsSection(StoreCheckoutViewModel viewModel, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // 优惠券
          GestureDetector(
            onTap: () async {
              final availableCoupons = viewModel.getAvailableCoupons();
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _CouponSelectionSheet(
                  coupons: availableCoupons,
                  selectedId: viewModel.selectedCoupon?['id'],
                  productTotal: viewModel.productTotal,
                ),
              );
              
              if (result != null) {
                viewModel.setSelectedCoupon(result);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF9FAFB)),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.ticket,
                    size: 18,
                    color: Color(0xFF111111),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '优惠券',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    viewModel.couponDiscount > 0
                        ? '-¥${viewModel.couponDiscount.toStringAsFixed(2)}'
                        : '${StoreCheckoutViewModel.AVAILABLE_COUPONS.length} 张可用',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: viewModel.couponDiscount > 0
                          ? const Color(0xFFFF6B00)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: Color(0xFFD1D5DB),
                  ),
                ],
              ),
            ),
          ),

          // 积分抵扣
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.coins,
                  size: 18,
                  color: Color(0xFF111111),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '积分抵扣',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                          children: [
                            TextSpan(text: '可用 2,450 积分，最高抵扣 '),
                            TextSpan(
                              text: '¥20',
                              style: TextStyle(
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (viewModel.pointsToUse > 0) {
                      viewModel.clearPoints();
                    } else {
                      viewModel.useAllPoints();
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: viewModel.pointsToUse > 0
                          ? const Color(0xFF111111)
                          : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: viewModel.pointsToUse > 0
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 2,
                            ),
                          ],
                        ),
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

  /// 发票区域
  Widget _buildInvoiceSection(StoreCheckoutViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // 发票头部
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: viewModel.needInvoice
                  ? const Border(bottom: BorderSide(color: Color(0xFFF9FAFB)))
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      LucideIcons.fileText,
                      size: 18,
                      color: Color(0xFF111111),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '开具发票',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _InvoiceTypeButton(
                      label: '不开',
                      selected: !viewModel.needInvoice && viewModel.invoiceType == 'none',
                      onTap: () {
                        if (viewModel.needInvoice) {
                          viewModel.toggleInvoice();
                        }
                        viewModel.setInvoiceType('none');
                      },
                    ),
                    const SizedBox(width: 8),
                    _InvoiceTypeButton(
                      label: '个人',
                      selected: viewModel.needInvoice && viewModel.invoiceType == 'personal',
                      onTap: () {
                        if (!viewModel.needInvoice) {
                          viewModel.toggleInvoice();
                        }
                        viewModel.setInvoiceType('personal');
                      },
                    ),
                    const SizedBox(width: 8),
                    _InvoiceTypeButton(
                      label: '企业',
                      selected: viewModel.needInvoice && viewModel.invoiceType == 'company',
                      onTap: () {
                        if (!viewModel.needInvoice) {
                          viewModel.toggleInvoice();
                        }
                        viewModel.setInvoiceType('company');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 发票表单
          if (viewModel.needInvoice)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
              ),
              child: viewModel.invoiceType == 'personal'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '发票抬头',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9CA3AF),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: viewModel.invoiceTitleController,
                          decoration: InputDecoration(
                            hintText: '请输入发票抬头姓名',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF111111)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '企业信息',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9CA3AF),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: viewModel.invoiceTitleController,
                          decoration: InputDecoration(
                            hintText: '单位全称',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF111111)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: viewModel.taxNumberController,
                          decoration: InputDecoration(
                            hintText: '纳税人识别号',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                              fontFamily: 'Oswald',
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF111111)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}

/// 开关组件（已废弃，不再使用）
class _Switch extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;

  const _Switch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF111111) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// 发票类型按钮
class _InvoiceTypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _InvoiceTypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF111111) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF111111) : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}

/// 优惠券选择底部弹窗 - 像素级还原原型设计
class _CouponSelectionSheet extends StatefulWidget {
  final List<Map<String, dynamic>> coupons;
  final int? selectedId;
  final double productTotal;

  const _CouponSelectionSheet({
    required this.coupons,
    this.selectedId,
    required this.productTotal,
  });

  @override
  State<_CouponSelectionSheet> createState() => _CouponSelectionSheetState();
}

class _CouponSelectionSheetState extends State<_CouponSelectionSheet> {
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 头部
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '选择优惠券',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                    Text(
                      '${widget.coupons.length} 张可用',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 优惠券列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.coupons.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // "不使用优惠券"选项
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedId == null
                              ? const Color(0xFF111111)
                              : const Color(0xFFE5E7EB),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              '不使用优惠券',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111111),
                              ),
                            ),
                          ),
                          if (_selectedId == null)
                            const Icon(
                              LucideIcons.check,
                              size: 20,
                              color: Color(0xFF111111),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                final coupon = widget.coupons[index - 1];
                final isSelected = _selectedId == coupon['id'];
                final amount = coupon['amount'] as double;
                final title = coupon['title'] as String;
                final condition = coupon['condition'] as String;
                final expiry = coupon['expiry'] as String;

                // 检查是否可用
                bool isAvailable = true;
                if (condition.contains('满')) {
                  final match = RegExp(r'满\s*(\d+)').firstMatch(condition);
                  if (match != null) {
                    final minAmount = double.parse(match.group(1)!);
                    isAvailable = widget.productTotal >= minAmount;
                  }
                }

                return GestureDetector(
                  onTap: isAvailable
                      ? () {
                          Navigator.pop(context, coupon);
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        // 主体容器
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.white : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // 左侧金额区域
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? const Color(0xFFFF6B00)
                                      : const Color(0xFF9CA3AF),
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          amount.toStringAsFixed(0),
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Oswald',
                                            color: Colors.white,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            '元',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '代金券',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 右侧信息区域
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: isAvailable
                                                  ? const Color(0xFF111111)
                                                  : const Color(0xFF6B7280),
                                              height: 1.2,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            condition,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isAvailable
                                                  ? const Color(0xFF6B7280)
                                                  : const Color(0xFF9CA3AF),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 6),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Color(0xFFF0F0F0),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '有效期至 $expiry',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF9CA3AF),
                                                  fontFamily: 'Oswald',
                                                ),
                                              ),
                                            ),
                                            if (isAvailable && isSelected)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF6B00),
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                                                      blurRadius: 6,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: const Text(
                                                  '去使用',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 左侧打孔圆圈
                        Positioned(
                          left: 94,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F7FA),
                                shape: BoxShape.circle,
                              ),
                            ),
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
    );
  }
}
