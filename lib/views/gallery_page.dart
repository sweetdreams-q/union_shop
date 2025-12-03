import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/search_page.dart';
import 'package:union_shop/views/sale_page.dart';
import 'package:union_shop/widgets/responsive_header.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

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

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  void navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      endDrawer: ResponsiveHeader.buildDrawer(
        context,
        onHome: (c) => navigateToHome(c),
        onAbout: (c) => navigateToAboutUs(c),
        onSearch: (c) => navigateToSearch(c),
        onProfile: (c) => placeholderCallbackForButtons(),
        onCart: (c) => navigateToCart(c),
        onSale: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const SalePage())),
        onGallery: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const GalleryPage())),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Responsive header
            ResponsiveHeader(
              onHome: (c) => navigateToHome(c),
              onAbout: (c) => navigateToAboutUs(c),
              onSearch: (c) => navigateToSearch(c),
              onProfile: (c) => placeholderCallbackForButtons(),
              onCart: (c) => navigateToCart(c),
              onSale: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const SalePage())),
              onGallery: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const GalleryPage())),
              onOpenDrawer: (c) => scaffoldKey.currentState?.openEndDrawer(),
            ),

            // Products Gallery Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'ALL PRODUCTS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Browse our complete collection',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
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
                      children: sampleProducts.map((product) => GalleryProductCard(
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

class GalleryProductCard extends StatelessWidget {
  final Product product;

  const GalleryProductCard({
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
            child: Stack(
              children: [
                Positioned.fill(
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
                if (product.onSale)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFb00020),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'SALE',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
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
