import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'maintenance_booking_viewmodel.dart';
import '../../../core/theme/app_colors.dart';

/// 预约保养页面 - 像素级还原
/// 严格遵守无负数margin规范
class MaintenanceBookingView extends StatelessWidget {
  const MaintenanceBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MaintenanceBookingViewModel>.reactive(
      viewModelBuilder: () => MaintenanceBookingViewModel(),
      onViewModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Header
                _buildHeader(context, model),
                
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 160, // Space for footer
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Car Info Card
                        _buildCarInfoCard(model),
                        const SizedBox(height: 20),
                        
                        // Package Selection
                        _buildPackageSelection(model),
                        const SizedBox(height: 24),
                        
                        // Dealer Card
                        _buildDealerCard(model),
                        const SizedBox(height: 20),
                        
                        // Time Selection
                        _buildTimeSelection(model),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Footer
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildFooter(context, model),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MaintenanceBookingViewModel model) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0x0D000000),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                LucideIcons.arrowLeft,
                size: 24,
                color: Color(0xFF111827),
              ),
            ),
          ),
          
          // Title
          const Expanded(
            child: Text(
              '预约保养',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                height: 1.2,
              ),
            ),
          ),
          
          // Spacer
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildCarInfoCard(MaintenanceBookingViewModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Car Image
          Container(
            width: 80,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.network(
              'https://i.imgs.ovh/2025/12/23/CpkkOO.webp',
              fit: BoxFit.contain,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Car Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '北京BJ40 PLUS',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Oswald',
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: '京A·12345'),
                      TextSpan(text: ' · '),
                      TextSpan(
                        text: '行驶 8,521 km',
                        style: TextStyle(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSelection(MaintenanceBookingViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '选择保养套餐',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    LucideIcons.info,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
              Text(
                '查看项目详情',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        
        // Package Cards
        ...model.packages.asMap().entries.map((entry) {
          final index = entry.key;
          final package = entry.value;
          final isSelected = model.selectedPackageIndex == index;
          
          return Padding(
            padding: EdgeInsets.only(bottom: index < model.packages.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => model.selectPackage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF111827) : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 14,
                            offset: Offset(0, 2),
                          ),
                        ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Package Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    package['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    (package['items'] as List<String>).join(' + '),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '¥${package['price']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Oswald',
                                    color: Color(0xFFFF6B00),
                                    height: 1.2,
                                  ),
                                ),
                                if (package['recommend'] == true) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B00),
                                      borderRadius: BorderRadius.circular(6), // 稍微加大由 4 -> 6
                                    ),
                                    child: const Text(
                                      '推荐',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Selected Badge
                    if (isSelected)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Transform.translate(
                          offset: const Offset(20, -20),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFF111827),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                topRight: Radius.circular(14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDealerCard(MaintenanceBookingViewModel model) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '服务门店',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  height: 1.3,
                ),
              ),
              Row(
                children: [
                  Text(
                    '更换门店',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Store Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  LucideIcons.mapPin,
                  size: 22,
                  color: Color(0xFF111827),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Store Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '北京汽车越野4S店（朝阳）',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '北京市朝阳区建国路88号',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6), // 稍微加大由 4 -> 6
                          ),
                          child: const Text(
                            '官方直营',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF059669),
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(6), // 稍微加大由 4 -> 6
                          ),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                                height: 1.2,
                              ),
                              children: [
                                TextSpan(text: '距您 '),
                                TextSpan(
                                  text: '2.3',
                                  style: TextStyle(fontFamily: 'Oswald'),
                                ),
                                TextSpan(text: 'km'),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTimeSelection(MaintenanceBookingViewModel model) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                LucideIcons.calendar,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              SizedBox(width: 8),
              Text(
                '到店时间',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  height: 1.3,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Date Scroller
          SizedBox(
            height: 74,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index + 1));
                final isSelected = model.selectedDateIndex == index;
                
                return Padding(
                  padding: EdgeInsets.only(right: index < 6 ? 12 : 0),
                  child: GestureDetector(
                    onTap: () => model.selectDate(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF111827) : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekday(date.weekday),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? const Color(0x99FFFFFF) : const Color(0xFF9CA3AF),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${date.month}-${date.day}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Oswald',
                              color: isSelected ? Colors.white : const Color(0xFF111827),
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Time Slots
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: model.timeSlots.length,
            itemBuilder: (context, index) {
              final time = model.timeSlots[index];
              final isSelected = model.selectedTimeIndex == index;
              
              return GestureDetector(
                onTap: () => model.selectTime(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF9FAFB) : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10), // 统一微调为 10，保持与商品卡片图片一致性
                    border: Border.all(
                      color: isSelected ? const Color(0xFF111827) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? const Color(0xFF111827) : const Color(0xFF6B7280),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, MaintenanceBookingViewModel model) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // 顶部倒角加大到 20，对标帮助中心底部栏
        border: Border(
          top: BorderSide(
            color: Color(0x0D000000),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                const Text(
                  '预计费用 (含工时)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                    height: 1.3,
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
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF6B00),
                      height: 1.2,
                    ),
                  ),
                  Text(
                    '${model.selectedPackage['price']}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Oswald',
                      color: Color(0xFFFF6B00),
                      height: 1.0,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Confirm Button
          GestureDetector(
            onTap: () => model.confirmBooking(),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(14), // 统一调整确认按钮圆角，对标帮助中心风格
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '确认预约',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }
}
