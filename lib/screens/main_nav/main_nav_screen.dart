import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../services/cart_service.dart';
import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(isRootTab: true),
    OrdersScreen(isRootTab: true),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final cartCount = cartService.itemCount;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: KebuninColors.white,
          border: Border(
            top: BorderSide(color: KebuninColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: switchTab,
          backgroundColor: KebuninColors.white,
          indicatorColor: KebuninColors.forestGreen.withOpacity(0.12),
          elevation: 0,
          height: 68,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined, color: KebuninColors.mutedGrey),
              selectedIcon:
                  Icon(Icons.home_rounded, color: KebuninColors.forestGreen),
              label: 'Beranda',
            ),
            const NavigationDestination(
              icon: Icon(Icons.grid_view_outlined, color: KebuninColors.mutedGrey),
              selectedIcon: Icon(Icons.grid_view_rounded,
                  color: KebuninColors.forestGreen),
              label: 'Kategori',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                backgroundColor: KebuninColors.carrotOrange,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Icon(Icons.shopping_bag_outlined,
                    color: KebuninColors.mutedGrey),
              ),
              selectedIcon: Badge(
                isLabelVisible: cartCount > 0,
                backgroundColor: KebuninColors.carrotOrange,
                label: Text(
                  '$cartCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Icon(Icons.shopping_bag_rounded,
                    color: KebuninColors.forestGreen),
              ),
              label: 'Keranjang',
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined,
                  color: KebuninColors.mutedGrey),
              selectedIcon: Icon(Icons.receipt_long_rounded,
                  color: KebuninColors.forestGreen),
              label: 'Pesanan',
            ),
            const NavigationDestination(
              icon:
                  Icon(Icons.person_outline_rounded, color: KebuninColors.mutedGrey),
              selectedIcon: Icon(Icons.person_rounded,
                  color: KebuninColors.forestGreen),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

