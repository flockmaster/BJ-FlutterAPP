import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'order_detail_viewmodel.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';

/// 订单详情页面 - 像素级还原原型，支持三种订单类型
class OrderDetailView extends StackedView<OrderDetailViewModel> {
  final String orderId;
  final String orderType;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String paymentMethod;
  final String? appointmentDate;
  
  // 新增：价格明细
  final double productTotal;
  final double shippingFee;
  final double couponDiscount;
  final double pointsDiscount;
  final int rewardPoints;
  
  // 新增：优惠信息
  final Map<String, dynamic>? selectedCoupon;
  final int pointsUsed;
  
  // 新增：发票信息
  final String invoiceMode;
  final String? invoiceTitle;
  final String? taxNumber;
  
  // 新增：其他信息
  final String? remark;
  final DateTime? orderTime;
  final DateTime? paymentTime;

  const OrderDetailView({
    Key? key,
    required this.orderId,
    required this.orderType,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    this.appointmentDate,
    this.productTotal = 0.0,
    this.shippingFee = 0.0,
    this.couponDiscount = 0.0,
    this.pointsDiscount = 0.0,
    this.rewardPoints = 0,
    this.selectedCoupon,
    this.pointsUsed = 0,
    this.invoiceMode = 'none',
    this.invoiceTitle,
    this.taxNumber,
    this.remark,
    this.orderTime,
    this.paymentTime,
  }) : super(key: key);

  @override
  OrderDetailViewModel viewModelBuilder(BuildContext context) => 
      OrderDetailViewModel(
        orderId: orderId,
        orderType: orderType,
        items: items,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        appointmentDate: appointmentDate,
        productTotal: productTotal,
        shippingFee: shippingFee,
        couponDiscount: couponDiscount,
        pointsDiscount: pointsDiscount,
        rewardPoints: rewardPoints,
        selectedCoupon: selectedCoupon,
        pointsUsed: pointsUsed,
        invoiceMode: invoiceMode,
        invoiceTitle: invoiceTitle,
        taxNumber: taxNumber,
        remark: remark,
        orderTime: orderTime,
        paymentTime: paymentTime,
      );

  @override
  Widget builder(BuildContext context, OrderDetailViewModel viewModel, Widget? child) {
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
                    onTap: () => viewModel.handleGoBack(),
                    child: Container(
                      width: 36,
                      height: 36,
                      child: const Icon(LucideIcons.arrowLeft, size: 24),
                    ),
                  ),
                  const Text(
                    '订单详情',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      child: const Icon(
                        LucideIcons.moreHorizontal,
                        size: 20,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 内容区域
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 60,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 80,
              ),
              child: Column(
                children: [
                  // 状态横幅
                  _buildStatusBanner(viewModel),

                  // 内容卡片
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 特殊信息卡片（根据类型）
                        if (orderType == 'service')
                          _buildServiceCard(viewModel)
                        else if (orderType == 'virtual')
                          _buildVirtualCard(viewModel)
                        else
                          _buildPhysicalCard(viewModel),

                        const SizedBox(height: 16),

                        // 商品信息
                        _buildProductCard(viewModel),
                        
                        const SizedBox(height: 16),

                        // 订单信息
                        _buildOrderInfoCard(viewModel),
                        
                        const SizedBox(height: 16),

                        // 价格明细
                        _buildPriceDetailCard(viewModel),
                        
                        // 发票信息（如果有）
                        if (viewModel.invoiceMode != 'none') ...[
                          const SizedBox(height: 16),
                          _buildInvoiceCard(viewModel),
                        ],
                        
                        // 订单备注（如果有）
                        if (viewModel.remark != null && viewModel.remark!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildRemarkCard(viewModel),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 底部操作栏
          _buildBottomBar(context, viewModel),
        ],
      ),
    );
  }

  /// 状态横幅
  Widget _buildStatusBanner(OrderDetailViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '已完成',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getStatusDescription(orderType),
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String type) {
    switch (type) {
      case 'physical':
        return '包裹已由顺丰速运送达';
      case 'service':
        return '请前往预约门店核销服务';
      case 'virtual':
        return '兑换码已发送至您的账户';
      default:
        return '订单已完成';
    }
  }

  /// 服务类订单卡片
  Widget _buildServiceCard(OrderDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(28),
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
          Row(
            children: [
              Icon(
                LucideIcons.qrCode,
                size: 18,
                color: const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 8),
              const Text(
                '服务核销码',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 176,
            height: 176,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: const Icon(
              LucideIcons.qrCode,
              size: 152,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '8930 2931',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oswald',
              letterSpacing: 8,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '请出示给店员进行扫码核销',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 虚拟类订单卡片
  Widget _buildVirtualCard(OrderDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(28),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.ticket,
                    size: 18,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '兑换码',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  '复制',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B00),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Text(
              'ABCD-1234-EFGH',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
                letterSpacing: 4,
                color: Color(0xFF111111),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 物理类订单卡片
  Widget _buildPhysicalCard(OrderDetailViewModel viewModel) {
    return Column(
      children: [
        // 物流信息
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.truck,
                    size: 20,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '您的快件已签收，感谢使用顺丰速运。',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '2024-01-14 18:30',
                        style: TextStyle(
                          fontSize: 11,
                          color: const Color(0xFF9CA3AF),
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
        ),
        const SizedBox(height: 16),

        // 收货地址
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF111111),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.mapPin,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          '张越野',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '138****8888',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '北京市朝阳区建国路88号 SOHO现代城',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 商品信息卡片
  Widget _buildProductCard(OrderDetailViewModel viewModel) {
    return Container(
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
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.shoppingBag,
                size: 18,
                color: Color(0xFF111111),
              ),
              const SizedBox(width: 10),
              const Text(
                '北京汽车商城自营',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFF9FAFB),
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < items.length - 1 ? 16 : 0,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 84,
                      height: 84,
                      color: const Color(0xFFF9FAFB),
                      child: CachedNetworkImage(
                        imageUrl: item['product'].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 84,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['product'].title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
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
                                  item['spec'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '¥',
                                    style: AppTypography.priceCurrency.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFF111111),
                                    ),
                                  ),
                                  Text(
                                    item['product'].price.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oswald',
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'x${item['quantity']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 订单信息卡片
  Widget _buildOrderInfoCard(OrderDetailViewModel viewModel) {
    return Container(
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
          Row(
            children: [
              const Icon(
                LucideIcons.fileText,
                size: 18,
                color: Color(0xFF111111),
              ),
              const SizedBox(width: 10),
              const Text(
                '订单信息',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFF9FAFB),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('订单编号', viewModel.orderId, canCopy: true),
          const SizedBox(height: 12),
          _buildInfoRow(
            '下单时间',
            viewModel.orderTime != null
                ? _formatDateTime(viewModel.orderTime!)
                : '2024-01-14 15:30',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            '支付时间',
            viewModel.paymentTime != null
                ? _formatDateTime(viewModel.paymentTime!)
                : '2024-01-14 15:32',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            '支付方式',
            viewModel.paymentMethod == 'wechat' ? '微信支付' : '支付宝',
          ),
          if (orderType == 'physical') ...[
            const SizedBox(height: 12),
            _buildInfoRow('配送方式', '顺丰速运 · 免运费'),
          ],
        ],
      ),
    );
  }

  /// 价格明细卡片
  Widget _buildPriceDetailCard(OrderDetailViewModel viewModel) {
    return Container(
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
          Row(
            children: [
              const Icon(
                LucideIcons.receipt,
                size: 18,
                color: Color(0xFF111111),
              ),
              const SizedBox(width: 10),
              const Text(
                '价格明细',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFF9FAFB),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('商品总额', viewModel.productTotal),
          const SizedBox(height: 12),
          _buildPriceRow('运费', viewModel.shippingFee, isFree: viewModel.shippingFee == 0),
          if (viewModel.couponDiscount > 0) ...[
            const SizedBox(height: 12),
            _buildPriceRow(
              viewModel.selectedCoupon != null
                  ? '优惠券（${viewModel.selectedCoupon!['title']}）'
                  : '优惠券',
              -viewModel.couponDiscount,
              isDiscount: true,
            ),
          ],
          if (viewModel.pointsDiscount > 0) ...[
            const SizedBox(height: 12),
            _buildPriceRow(
              '积分抵扣（${viewModel.pointsUsed}积分）',
              -viewModel.pointsDiscount,
              isDiscount: true,
            ),
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  if (viewModel.rewardPoints > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        border: Border.all(color: const Color(0xFFFFE0B2)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '返 ${viewModel.rewardPoints} 积分',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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
                    viewModel.totalAmount.toStringAsFixed(0),
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
        ],
      ),
    );
  }

  /// 发票信息卡片
  Widget _buildInvoiceCard(OrderDetailViewModel viewModel) {
    return Container(
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
          Row(
            children: [
              const Icon(
                LucideIcons.fileText,
                size: 18,
                color: Color(0xFF111111),
              ),
              const SizedBox(width: 10),
              const Text(
                '发票信息',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFF9FAFB),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            '发票类型',
            viewModel.invoiceMode == 'personal' ? '个人' : '企业',
          ),
          if (viewModel.invoiceTitle != null && viewModel.invoiceTitle!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              viewModel.invoiceMode == 'personal' ? '发票抬头' : '单位全称',
              viewModel.invoiceTitle!,
            ),
          ],
          if (viewModel.invoiceMode == 'company' &&
              viewModel.taxNumber != null &&
              viewModel.taxNumber!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow('纳税人识别号', viewModel.taxNumber!),
          ],
        ],
      ),
    );
  }

  /// 订单备注卡片
  Widget _buildRemarkCard(OrderDetailViewModel viewModel) {
    return Container(
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
          Row(
            children: [
              const Icon(
                LucideIcons.messageSquare,
                size: 18,
                color: Color(0xFF111111),
              ),
              const SizedBox(width: 10),
              const Text(
                '订单备注',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: const Color(0xFFF9FAFB),
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.remark!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 信息行组件
  Widget _buildInfoRow(String label, String value, {bool canCopy = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              if (canCopy) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: 实现复制功能
                  },
                  child: const Icon(
                    LucideIcons.copy,
                    size: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 价格行组件
  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ),
        Text(
          isFree
              ? '免运费'
              : '¥${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oswald',
            color: isFree
                ? const Color(0xFF10B981)
                : (isDiscount ? const Color(0xFFFF6B00) : const Color(0xFF111111)),
          ),
        ),
      ],
    );
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// 底部操作栏
  Widget _buildBottomBar(BuildContext context, OrderDetailViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFF0F0F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 30,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppDimensions.borderRadiusFull,
                  border: Border.all(
                    color: const Color(0xFFF0F0F0),
                    width: 2,
                  ),
                ),
                child: const Text(
                  '售后申请',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => viewModel.buyAgain(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppDimensions.borderRadiusFull,
                  color: const Color(0xFF111111),
                ),
                child: const Text(
                  '再次购买',
                  style: TextStyle(
                    fontSize: 13,
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
}
