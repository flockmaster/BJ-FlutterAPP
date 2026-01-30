import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'points_history_viewmodel.dart';
import '../../../core/models/points_models.dart';
import '../../../core/theme/app_typography.dart';

class PointsHistoryView extends StackedView<PointsHistoryViewModel> {
  const PointsHistoryView({super.key});

  @override
  Widget builder(BuildContext context, PointsHistoryViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: Column(
          children: [
            _buildHeader(context, viewModel),
            Expanded(child: _buildContent(viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PointsHistoryViewModel viewModel) {
    final stats = viewModel.stats;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF1F2937), Color(0xFF0F172A)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: viewModel.navigateBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 20),
                    ),
                  ),
                  const Text('我的积分', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                  GestureDetector(
                    onTap: viewModel.showHelp,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.helpCircle, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  Text('当前可用积分', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6))),
                  const SizedBox(height: 8),
                  Text(
                    stats?.availablePoints.toString() ?? '0',
                    style: AppTypography.dataDisplay(fontSize: 56, color: Colors.white, letterSpacing: -2),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: viewModel.navigateToStore,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.shoppingBag, size: 16, color: Color(0xFF111827)),
                                SizedBox(width: 6),
                                Text('积分商城', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: viewModel.navigateToTasks,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.trophy, size: 16, color: Colors.white),
                                SizedBox(width: 6),
                                Text('做任务赚分', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildContent(PointsHistoryViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildTabs(viewModel),
          Expanded(child: _buildTransactionList(viewModel)),
        ],
      ),
    );
  }

  Widget _buildTabs(PointsHistoryViewModel viewModel) {
    final tabs = [
      {'id': 'all', 'label': '全部'},
      {'id': 'earn', 'label': '获取'},
      {'id': 'spend', 'label': '消耗'},
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isActive = viewModel.activeTab == tab['id'];
          return Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setActiveTab(tab['id']!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isActive ? const Color(0xFF111827) : Colors.transparent, width: 2)),
                ),
                child: Text(
                  tab['label']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionList(PointsHistoryViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF111827)));
    }
    final transactions = viewModel.filteredTransactions;
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.inbox, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('暂无记录', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length + 1,
      itemBuilder: (context, index) {
        if (index == transactions.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              '— 到底了 —',
              textAlign: TextAlign.center,
              style: AppTypography.dataDisplayS.copyWith(color: const Color(0xFFD1D5DB), letterSpacing: 4),
            ),
          );
        }
        final transaction = transactions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: transaction.type == PointsTransactionType.earn ? const Color(0xFFFFF7ED) : const Color(0xFFF9FAFB),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(transaction.category),
                  size: 18,
                  color: transaction.type == PointsTransactionType.earn ? const Color(0xFFFF6B00) : const Color(0xFF111827),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(transaction.time, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                transaction.amount > 0 ? '+${transaction.amount}' : '${transaction.amount}',
                style: AppTypography.dataDisplayS.copyWith(
                  color: transaction.type == PointsTransactionType.earn ? const Color(0xFFFF6B00) : const Color(0xFF111827),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(PointsCategory category) {
    switch (category) {
      case PointsCategory.checkin:
        return LucideIcons.calendar;
      case PointsCategory.shop:
        return LucideIcons.shoppingBag;
      case PointsCategory.task:
        return LucideIcons.trophy;
      case PointsCategory.invite:
        return LucideIcons.gift;
      case PointsCategory.service:
        return LucideIcons.car;
      case PointsCategory.community:
        return LucideIcons.messageCircle;
      case PointsCategory.activity:
        return LucideIcons.calendar;
      default:
        return LucideIcons.trendingUp;
    }
  }

  @override
  PointsHistoryViewModel viewModelBuilder(BuildContext context) => PointsHistoryViewModel();

  @override
  void onViewModelReady(PointsHistoryViewModel viewModel) => viewModel.init();
}
