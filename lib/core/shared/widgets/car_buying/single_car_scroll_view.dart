
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:car_owner_app/app/routes.dart';
import 'package:car_owner_app/core/extensions/context_extensions.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:car_owner_app/core/constants/app_constants.dart';
import '../optimized_image.dart';
import 'package:car_owner_app/ui/views/vr_experience/vr_experience_enhanced_view.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';
import 'package:car_owner_app/ui/views/car_buying/car_specs/car_specs_view.dart';
import 'package:car_owner_app/ui/views/car_buying/finance_calculator/finance_calculator_view.dart';
import 'package:car_owner_app/ui/views/car_buying/trade_in/trade_in_view.dart';


class SingleCarScrollView extends StatefulWidget {
  final CarModel car;
  final VoidCallback onOrder;
  final VoidCallback onTestDrive;
  final VoidCallback onDetail;
  final VoidCallback? onAllStores;
  final VoidCallback? onConsultant;
  final VoidCallback? onCompare; // 新增：车型对比回调
  final ScrollController? scrollController;

  const SingleCarScrollView({
    super.key,
    required this.car,
    required this.onOrder,
    required this.onTestDrive,
    required this.onDetail,
    this.onAllStores,
    this.onConsultant,
    this.onCompare, // 新增参数
    this.scrollController,
  });

  @override
  State<SingleCarScrollView> createState() => _SingleCarScrollViewState();
}

class _SingleCarScrollViewState extends State<SingleCarScrollView> {
  bool _isPromoExpanded = false;
  String? _selectedVersionKey;

  @override
  void initState() {
    super.initState();
    if (widget.car.versions != null && widget.car.versions!.isNotEmpty) {
      _selectedVersionKey = widget.car.versions!.keys.first;
    }
  }

  /// 构建倒计时组件
  Widget _buildCountdown(DateTime releaseDate) {
    final now = DateTime.now();
    final difference = releaseDate.difference(now);
    
    if (difference.isNegative) {
      return const Column(
        children: [
          Text('已发布', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text('敬请关注', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      );
    }
    
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    
    return Column(
      children: [
        const Text('距离发布还有', style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCountdownItem(days.toString().padLeft(2, '0'), '天'),
            const SizedBox(width: 8),
            _buildCountdownItem(hours.toString().padLeft(2, '0'), '时'),
            const SizedBox(width: 8),
            _buildCountdownItem(minutes.toString().padLeft(2, '0'), '分'),
          ],
        ),
      ],
    );
  }
  
  Widget _buildCountdownItem(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  /// 构建图片组件，支持本地assets和网络图片（使用缓存优化）
  Widget _buildCarImage(String imagePath, {BoxFit fit = BoxFit.cover}) {
    return OptimizedImage(
      imageUrl: imagePath,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.only(bottom: 100), // Space for floating bar
      children: [
        _buildHeroSection(),
        if (!widget.car.isPreview) _buildPromoSection(),
        if (!widget.car.isPreview && widget.car.highlightImage != null) _buildHighlightsSection(),
        if (widget.car.isPreview) _buildPreviewInfo(),
        if (!widget.car.isPreview && widget.car.versions != null) _buildVersionSelector(),
        if (!widget.car.isPreview) _buildToolsSection(),
        if (!widget.car.isPreview && widget.car.vrImage != null) _buildVRSection(),
        if (!widget.car.isPreview) _buildStoreSection(),
      ],
    );
  }

  Widget _buildHeroSection() {
    final car = widget.car;
    return Container(
      height: 480,
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          _buildCarImage(car.backgroundImage),
          
          // Gradients
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
          if (car.isPreview)
            BackdropFilter(
              filter:  const ColorFilter.mode(Colors.black26, BlendMode.darken) as dynamic, // Simplified blur simulation
              child: Container(color: Colors.black12),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  car.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  car.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    letterSpacing: 4,
                  ),
                ),
                
                const SizedBox(height: 16),
                InkWell(
                  onTap: widget.onDetail,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '了解详情',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white.withOpacity(0.8),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Price or Countdown
                // Price
                if (car.isPreview && car.releaseDate != null)
                  _buildCountdown(car.releaseDate!)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center align
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('售价 ', style: AppTypography.headingS.copyWith(color: Colors.white)),
                      Text(
                        '${car.price}',
                        style: AppTypography.dataDisplayL.copyWith(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(width: 2),
                      Text(' ${car.priceUnit ?? '万'}元起', style: AppTypography.headingS.copyWith(color: Colors.white)),
                    ],
                  ),
               const SizedBox(height: 20),
                
                // Buttons
                if (car.isPreview)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('预约通知', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: AppDimensions.borderRadiusFull,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: OutlinedButton(
                              onPressed: widget.onTestDrive,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                side: const BorderSide(color: Colors.white54, width: 1.5), // Thicker border
                                padding: const EdgeInsets.symmetric(vertical: 14), // Smaller padding
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('预约试驾', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14), // Smaller padding
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('立即定购', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          
          if (car.isPreview)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('预告', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return GestureDetector(
      onTap: () => setState(() => _isPromoExpanded = !_isPromoExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.4, 0.6, 1.0],
            colors: [
              Color(0xFFFFF9F2), // #FFF9F2
              Color(0xFFFFFFFF), // #FFFFFF
              Color(0xFFFFF5EC), // #FFF5EC
              Color(0xFFFDF1E0), // #FDF1E0
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPromoExpanded ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            )
          ] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13),
                      children: [
                        const TextSpan(text: '12月31日24:00前定购可享限时权益，最高价值 '),
                        TextSpan(
                          text: widget.car.promoPrice ?? '',
                          style: AppTypography.dataDisplayS.copyWith(color: const Color(0xFFC18E58)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isPromoExpanded) ...[
              const Divider(color: Color(0xFFEAD6C0), height: 24),
              // Hardcoded for now as per React constant PROMO_BENEFITS
              ...[
                {'title': '置换礼', 'desc': '本品置换享 10000 元补贴'},
                {'title': '金融礼', 'desc': '至高贴息 7000 元'},
                {'title': '无忧礼', 'desc': '首任车主终身免费质保'},
              ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFFFF0E5), borderRadius: BorderRadius.circular(4)),
                      child: Text(item['title']!, style: const TextStyle(color: Color(0xFFC18E58), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(item['desc']!, style: const TextStyle(color: Color(0xFF333333), fontSize: 12)),
                  ],
                ),
              )),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_isPromoExpanded ? '收起权益' : '查看全部权益', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Icon(_isPromoExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('车型亮点', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildCarImage(widget.car.highlightImage!),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        ),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                      ),
                      child: Text(
                        widget.car.highlightText ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
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

  Widget _buildVersionSelector() {
    final versions = widget.car.versions;
    if (versions == null || versions.isEmpty) return const SizedBox.shrink();

    // Ensure selection is valid
    if (_selectedVersionKey == null || !versions.containsKey(_selectedVersionKey)) {
      _selectedVersionKey = versions.keys.first;
    }
    
    final selectedVersion = versions[_selectedVersionKey]!;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('在售车型', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
              GestureDetector(
                onTap: widget.onCompare,
                child: Row(
                  children: const [
                    Text(
                      '车型对比',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 14, color: AppColors.textTertiary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: versions.entries.map((entry) {
                      final isSelected = entry.key == _selectedVersionKey;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedVersionKey = entry.key),
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent, width: 2)),
                          ),
                          child: Text(
                            entry.value.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Badge
                if (selectedVersion.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: _getBadgeGradient(selectedVersion.badgeColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      selectedVersion.badge!,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                  
                // Feature List
                if (selectedVersion.features.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedVersion.features.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.textSecondary, height: 1.4, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                feature, 
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),

                const Divider(height: 1, color: Color(0xFFF5F5F5)),
                const SizedBox(height: 16),

                // Price and Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('¥ ', style: AppTypography.captionPrimary),
                        Text(
                          '${selectedVersion.price}',
                          style: AppTypography.dataDisplayM.copyWith(color: const Color(0xFF1A1A1A)),
                        ),
                        Text('万起', style: AppTypography.captionPrimary),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => widget.onOrder(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        elevation: 0,
                      ),
                      child: const Text('选择配置', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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

  LinearGradient _getBadgeGradient(String? colorStr) {
    if (colorStr == null) return const LinearGradient(colors: [Color(0xFFD4A574), Color(0xFFC89860)]);
    
    if (colorStr.contains('#434343')) {
      return const LinearGradient(colors: [Color(0xFF434343), Color(0xFF000000)]);
    } else if (colorStr.contains('#FF9966')) {
       return const LinearGradient(colors: [Color(0xFFFF9966), Color(0xFFFF5E62)]);
    } else if (colorStr.contains('#7F7FD5')) {
       return const LinearGradient(colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)]);
    }
    
    return const LinearGradient(colors: [Color(0xFFD4A574), Color(0xFFC89860)]);
  }

  Widget _buildToolsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '购车工具',
            style: AppTypography.headingM.copyWith(
              color: AppColors.textTitle,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildToolItem(
                    LucideIcons.list,
                    '参数配置',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CarSpecsView(car: widget.car),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildToolItem(
                    LucideIcons.calculator,
                    '金融计算',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FinanceCalculatorView(car: widget.car),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildToolItem(
                    LucideIcons.refreshCw,
                    '置换估值',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TradeInView(),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildToolItem(
                    LucideIcons.bookOpen,
                    '购车指南',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Consultant Card
          BaicBounceButton(
            onPressed: widget.onConsultant,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.bgCanvas,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderLight, width: 1),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=100&auto=format&fit=crop&crop=faces'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '在线咨询',
                            style: AppTypography.headingS.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textTitle,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '专业产品专家为您解答',
                            style: AppTypography.captionSecondary.copyWith(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.bgCanvas,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.textTertiary,
                      size: 16,
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

  Widget _buildToolItem(IconData icon, String label, {VoidCallback? onTap}) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.bgCanvas,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.captionSecondary.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVRSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('在线看车', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Navigate to VR Experience View as fullscreen dialog
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => VRExperienceEnhancedView(
                    carName: widget.car.fullName,
                    modelAssetPath: 'assets/models/BJ40-V1.glb', // 暂时使用在线模型
                  ),
                ),
              );
            },
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildCarImage(widget.car.vrImage!),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'VR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Text(
                        '360° 全景看车',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildStoreSection() {
    // Use store data if available, otherwise use default data
    final storeName = widget.car.store?.name ?? '北京汽车直营店';
    final storeAddress = widget.car.store?.address ?? '北京市朝阳区建国路88号SOHO现代城';
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('直营门店', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
              GestureDetector(
                onTap: () => widget.onAllStores?.call(),
                child: Row(
                  children: const [
                    Text(
                      '全部网点',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 14, color: AppColors.textTertiary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  child: _buildCarImage('/images/store-front.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeName, 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))
                      ),
                      const SizedBox(height: 4),
                      Text(
                        storeAddress, 
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1.2km',
                            style: AppTypography.dataDisplayS.copyWith(
                              color: AppColors.brandDark,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.bgFill,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.navigation, color: AppColors.brandDark, size: 16),
                              ),
                              const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () => widget.onTestDrive(),
                                  style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF1A1A1A),
                                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                child: const Text('预约试驾', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildPreviewInfo() {
    // Placeholder for Preview Info, similar to React's Construction view but richer
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Center(
        child: Text('预售信息加载中...', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
