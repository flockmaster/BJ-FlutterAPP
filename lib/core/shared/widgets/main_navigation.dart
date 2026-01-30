import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:car_owner_app/app/app.locator.dart';
import 'package:car_owner_app/ui/views/discovery/discovery_view.dart';
import 'package:car_owner_app/ui/views/store/store_view.dart';
import 'package:car_owner_app/ui/views/car_buying/car_buying_view.dart';
import 'package:car_owner_app/ui/views/service/service_view.dart';
import 'package:car_owner_app/ui/views/profile/profile_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final _navigationService = locator<NavigationService>();

  final List<Widget> _pages = [
    const DiscoveryView(),
    const StoreView(),
    const CarBuyingView(),
    const ServiceView(),
    const ProfileView(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: LucideIcons.compass,
      activeIcon: LucideIcons.compass,
      label: '发现',
    ),
    NavigationItem(
      icon: LucideIcons.shoppingBag,
      activeIcon: LucideIcons.shoppingBag,
      label: '商城',
    ),
    NavigationItem(
      icon: Icons.directions_car_filled,
      activeIcon: Icons.directions_car_filled,
      label: '购车',
    ),
    NavigationItem(
      icon: LucideIcons.wrench,
      activeIcon: LucideIcons.wrench,
      label: '服务',
    ),
    NavigationItem(
      icon: LucideIcons.user,
      activeIcon: LucideIcons.user,
      label: '我的',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: const Color(0xFF999999),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
            elevation: 0,
            enableFeedback: false,
            items: _navigationItems.map((item) {
              return BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(item.icon, size: 24),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(item.activeIcon, size: 24),
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    HapticFeedback.lightImpact();
    if (_selectedIndex == index) return;
    
    setState(() {
      _selectedIndex = index;
    });
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}