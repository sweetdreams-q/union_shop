import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRoute, GoRouter;
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:union_shop/views/home_page.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/gallery_page.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/search_page.dart';
import 'package:union_shop/views/sale_page.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/print_shack_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UnionShopApp());
}

// GoRouter configuration
final GoRouter _router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutUsPage(),
    ),
    GoRoute(
      path: '/gallery',
      name: 'gallery',
      builder: (context, state) => const GalleryPage(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/sale',
      name: 'sale',
      builder: (context, state) => const SalePage(),
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/print-shack',
      name: 'print-shack',
      builder: (context, state) => const PrintShackPage(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product',
      builder: (context, state) {
        final productId = state.pathParameters['id'] ?? '1';
        final product = sampleProducts.firstWhere(
          (p) => p.id == productId,
          orElse: () => sampleProducts.first,
        );
        return ProductPage(product: product);
      },
    ),
  ],
);

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CartProvider(
      cart: CartModel(),
      child: MaterialApp.router(
        title: 'Union Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
        ),
        routerConfig: _router,
      ),
    );
  }
}
