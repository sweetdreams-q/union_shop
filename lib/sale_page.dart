import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/widgets/responsive_header.dart';
import 'package:union_shop/about_us_page.dart';
import 'package:union_shop/search_page.dart';
import 'package:union_shop/cart_page.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  @override
  Widget build(BuildContext context) {
    final saleProducts = sampleProducts.where((p) => p.onSale).toList();

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: ResponsiveHeader.buildDrawer(
        context,
        onHome: (c) => Navigator.pushNamedAndRemoveUntil(c, '/', (route) => false),
        onAbout: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const AboutUsPage())),
        onSearch: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const SearchPage())),
        onProfile: (c) => {},
        onCart: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const CartPage())),
        onSale: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const SalePage())),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFf6e8fb),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: const Column(
                children: [
                  Text(
                    'FLASH SALE',
                    style: TextStyle(
                      color: Color(0xFF4d2963),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Limited time discounts on selected essentials — grab them while stocks last!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: saleProducts.map((p) => _SaleProductTile(product: p)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleProductTile extends StatelessWidget {
  final Product product;
  const _SaleProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(
          product.imageUrl,
          width: 64,
          height: 64,
          fit: BoxFit.contain,
        ),
        title: Text(product.title),
        subtitle: Row(
          children: [
            if (product.onSale && product.salePrice != null) ...[
              Text(
                product.salePrice!,
                style: const TextStyle(
                  color: Color(0xFFb00020),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                product.price,
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ] else ...[
              Text(product.price),
            ]
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
          child: const Text('View'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductPage(product: product)),
            );
          },
        ),
      ),
    );
  }
}
