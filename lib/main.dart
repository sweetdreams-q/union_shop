import 'package:flutter/material.dart';
import 'dart:async';

import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/gallery_page.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/search_page.dart';
import 'package:union_shop/views/sale_page.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/widgets/responsive_header.dart';
import 'package:union_shop/views/print_shack_page.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CartProvider(
      cart: CartModel(),
      child: MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/',
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController(initialPage: 1);
  int _currentIndex = 0;
  bool _isPlaying = true;
  Timer? _timer;

  final List<Map<String, String>> slides = [
    {
      'image': 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      'title': 'Welcome to Union Shop',
      'subtitle': "Discover exclusive university merchandise and essentials.",
      'button': 'BROWSE PRODUCTS',
    },
    {
      'image': 'https://picsum.photos/1200/800?image=1067',
      'title': 'About us',
      'subtitle': 'Learn more about our mission to support students and the university community.',
      'button': 'Learn More',
    },
    {
      'image': 'https://picsum.photos/1200/800?image=1015',
      'title': 'Third Slide Title',
      'subtitle': 'Third slide placeholder description.',
      'button': 'ACTION 3',
    },
  ];

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(product: product),
      ),
    );
  }

  void navigateToGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GalleryPage(),
      ),
    );
  }

  void navigateToAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutUsPage(),
      ),
    );
  }

  void navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );
  }

  void navigateToSale(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SalePage()),
    );
  }

  void navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  void navigateToPrintShack(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrintShackPage()),
    );
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_isPlaying) return;
      // Advance one page in the extended page view (we use duplicates at ends)
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: ResponsiveHeader.buildDrawer(
        context,
        onHome: (c) => navigateToHome(c),
        onAbout: (c) => navigateToAboutUs(c),
        onSearch: (c) => navigateToSearch(c),
        onProfile: (c) => placeholderCallbackForButtons(),
        onCart: (c) => navigateToCart(c),
        onSale: (c) => navigateToSale(c),
        onGallery: (c) => navigateToGallery(c),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveHeader(
              onHome: (c) => navigateToHome(c),
              onAbout: (c) => navigateToAboutUs(c),
              onSearch: (c) => navigateToSearch(c),
              onProfile: (c) => placeholderCallbackForButtons(),
              onCart: (c) => navigateToCart(c),
              onSale: (c) => navigateToSale(c),
              onGallery: (c) => navigateToGallery(c),
              onOpenDrawer: (c) => scaffoldKey.currentState?.openEndDrawer(),
            ),

            // Hero Section - Slideshow
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  // Extended PageView: we add a duplicate last slide at index 0 and
                  // a duplicate first slide at the last index so we can jump
                  // without visual flicker when looping.
                  PageView.builder(
                    controller: _pageController,
                    itemCount: slides.length + 2,
                    onPageChanged: (pageIndex) {
                      final int count = slides.length;
                      int realIndex;
                      if (pageIndex == 0) {
                        // jumped to the duplicate of the last slide; schedule jump to real last
                        Future.microtask(() => _pageController.jumpToPage(count));
                        realIndex = count - 1;
                      } else if (pageIndex == count + 1) {
                        // jumped to the duplicate of the first slide; schedule jump to real first
                        Future.microtask(() => _pageController.jumpToPage(1));
                        realIndex = 0;
                      } else {
                        realIndex = pageIndex - 1;
                      }
                      setState(() => _currentIndex = realIndex);
                    },
                    itemBuilder: (context, index) {
                      // map extended index to slide index
                      final int count = slides.length;
                      Map<String, String> slide;
                      if (index == 0) {
                        slide = slides[count - 1];
                      } else if (index == count + 1) {
                        slide = slides[0];
                      } else {
                        slide = slides[index - 1];
                      }

                      return Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(slide['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    },
                  ),

                  // Content overlay for current slide
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          slides[_currentIndex]['title']!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slides[_currentIndex]['subtitle']!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Button: different actions based on slide
                        ElevatedButton(
                          onPressed: _currentIndex == 0
                              ? () => navigateToGallery(context)
                              : _currentIndex == 1
                                  ? () => navigateToAboutUs(context)
                                  : _currentIndex == 2
                                      ? () => navigateToPrintShack(context)
                                      : null,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(const Color(0xFF4d2963)),
                            foregroundColor: WidgetStateProperty.all(Colors.white),
                            shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            )),
                            textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 14, letterSpacing: 1)),
                          ),
                          child: Text(slides[_currentIndex]['button']!),
                        ),
                      ],
                    ),
                  ),

                  // Bottom-center navigation bar
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SliderNavigationBar(
                        length: slides.length,
                        index: _currentIndex,
                        isPlaying: _isPlaying,
                        onPrev: () {
                          final currentPage = (_pageController.page ?? 1).round();
                          final target = currentPage - 1;
                          _pageController.animateToPage(target, duration: const Duration(milliseconds: 2000), curve: Curves.easeInOut);
                        },
                        onNext: () {
                          final currentPage = (_pageController.page ?? 1).round();
                          final target = currentPage + 1;
                          _pageController.animateToPage(target, duration: const Duration(milliseconds: 2000), curve: Curves.easeInOut);
                        },
                        onTogglePlay: () => setState(() => _isPlaying = !_isPlaying),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'PRODUCTS SECTION',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: sampleProducts.map((product) => ProductCard(
                        product: product,
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    );
                  },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                product.title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
                  if (product.onSale && product.salePrice != null) ...[
                    Text(
                      product.salePrice!,
                      style: const TextStyle(fontSize: 13, color: Color(0xFFb00020), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      product.price,
                      style: const TextStyle(fontSize: 13, color: Colors.grey, decoration: TextDecoration.lineThrough),
                    ),
                  ] else ...[
                    Text(
                      product.price,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
              const SizedBox(height: 4),
              Text(
                'Sizes: ${product.availableSizes.map((s) => s.label).join(', ')}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The control that looks like your screenshot
class SliderNavigationBar extends StatelessWidget {
  final int length;
  final int index;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onTogglePlay;
  final bool isPlaying;

  const SliderNavigationBar({
    super.key,
    required this.length,
    required this.index,
    required this.onPrev,
    required this.onNext,
    required this.onTogglePlay,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main gray bar with arrows + dots
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[800],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: onPrev,
                icon: const Icon(Icons.chevron_left, color: Colors.white70),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(length, (i) {
                  final bool selected = i == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? Colors.white : Colors.white54,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 4),
              IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right, color: Colors.white70),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Separate square pause button
        Container(
          width: 40,
          height: 40,
          color: Colors.grey[800],
          child: IconButton(
            iconSize: 20,
            onPressed: onTogglePlay,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
