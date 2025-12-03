import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/sale_page.dart';
import 'package:union_shop/views/search_page.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/widgets/responsive_header.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductSize? _selectedSize;
  int _selectedQuantity = 1;
  final List<int> _quantities = List<int>.generate(10, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    // Set default selected size
    if (widget.product.availableSizes.isNotEmpty) {
      _selectedSize = widget.product.availableSizes[0];
    }
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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

  void navigateToCart(BuildContext context) {
    // Dismiss any visible snackbars before navigating
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    // Use root navigator to ensure navigation even when SnackBar overlays
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
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
              onSale: (c) => Navigator.push(c, MaterialPageRoute(builder: (_) => const SalePage())),
              onOpenDrawer: (c) => scaffoldKey.currentState?.openEndDrawer(),
            ),

            // Product details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image gallery
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        // Main image (single image per product)
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  widget.product.imageUrl,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: 300,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Image unavailable',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (widget.product.onSale)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFb00020),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'SALE',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Product name
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Product price
                  if (widget.product.onSale && widget.product.salePrice != null) ...[
                    Row(
                      children: [
                        Text(
                          widget.product.salePrice!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4d2963),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.product.price,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      widget.product.price,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4d2963),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Size selector
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.product.availableSizes.map((size) {
                      final isSelected = size == _selectedSize;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = size),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4d2963) : Colors.white,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4d2963) : Colors.grey[400]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              size.label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Quantity selector
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 140,
                    child: DropdownButtonFormField<int>(
                      initialValue: _selectedQuantity,
                      items: _quantities
                          .map((q) => DropdownMenuItem<int>(
                                value: q,
                                child: Text(q.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setState(() => _selectedQuantity = val);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Add to Cart
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4d2963),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        // Ensure size selected when sizes exist
                        if (widget.product.availableSizes.isNotEmpty && _selectedSize == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a size')),
                          );
                          return;
                        }
                        final cart = CartProvider.of(context);
                        cart.addItem(
                          widget.product,
                          size: _selectedSize,
                          quantity: _selectedQuantity,
                        );

                        final snack = SnackBar(
                          duration: const Duration(seconds: 3),
                          content: Text('Added $_selectedQuantity × ${widget.product.title} to cart'),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            onPressed: () {
                              // Navigate to cart. Do not explicitly hide the SnackBar here;
                              // it will dismiss after its duration regardless.
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(builder: (_) => const CartPage()),
                              );
                            },
                          ),
                        );

                        // Show the SnackBar and also schedule a guaranteed close after its duration
                        final controller = ScaffoldMessenger.of(context).showSnackBar(snack);
                        Future.delayed(snack.duration + const Duration(milliseconds: 100), () {
                          try {
                            controller.close();
                          } catch (_) {
                            // ignore any errors if already closed
                          }
                        });
                      },
                      child: const Text('ADD TO CART'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Product description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
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
