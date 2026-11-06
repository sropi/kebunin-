import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main_nav/main_nav_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/product_detail/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/order_success/order_success_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../models/product.dart';
import '../models/order.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainNav = '/main-nav';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String search = '/search';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case mainNav:
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
            builder: (_) => MainNavScreen(initialIndex: initialIndex));
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case categories:
        final catId = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => CategoriesScreen(initialCategoryId: catId));
      case search:
        final initialQuery = settings.arguments as String? ?? '';
        return MaterialPageRoute(
            builder: (_) => SearchScreen(initialQuery: initialQuery));
      case productDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product));
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case orderSuccess:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(order: order));
      case orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case orderDetail:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
            builder: (_) => OrderDetailScreen(order: order));
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rute tidak ditemukan: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

