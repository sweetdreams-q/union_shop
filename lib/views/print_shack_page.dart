import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/widgets/responsive_header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/search_page.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/sale_page.dart';
import 'package:union_shop/views/gallery_page.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTextType = 'One Line of Text';
  late TextEditingController _line1Controller;
  late TextEditingController _line2Controller;
  int _quantity = 1;
  final int _maxCharacters = 10;

  @override
  void initState() {
    super.initState();
    _line1Controller = TextEditingController();
    _line2Controller = TextEditingController();
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    super.dispose();
  }

  double get _price {
    if (_selectedTextType == 'One Line of Text') {
      return 3.00;
    } else {
      return 5.00;
    }
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutUsPage()),
    );
  }

  void navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );
  }

  void navigateToCart(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void navigateToSale(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SalePage()),
    );
  }

  void navigateToGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GalleryPage()),
    );
  }

  void placeholderCallbackForButtons() {}

  void _addToCart(BuildContext context) {
    if (_line1Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text for Line 1')),
      );
      return;
    }

    if (_selectedTextType == 'Two Lines of Text' && _line2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text for Line 2')),
      );
      return;
    }

    // Create a custom product for Print Shack
    final personalizationText = _selectedTextType == 'Two Lines of Text'
        ? '${_line1Controller.text} / ${_line2Controller.text}'
        : _line1Controller.text;

    final printShackProduct = Product(
      id: 'print_shack_${DateTime.now().millisecondsSinceEpoch}',
      title: 'The Print Shack - Personalised Hoodie ($personalizationText)',
      price: '£${_price.toStringAsFixed(2)}',
      imageUrl: 'assets/product_images/print_shack.png',
      description: 'Custom personalized hoodie with text: $personalizationText',
      availableSizes: const [], // No size selection for print shack
    );

    final cart = CartProvider.of(context);
    cart.addItem(printShackProduct, quantity: _quantity);

    final snack = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('Added $_quantity × Personalised Hoodie to cart - £${(_price * _quantity).toStringAsFixed(2)}'),
      action: SnackBarAction(
        label: 'VIEW CART',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => const CartPage()),
          );
        },
      ),
    );

    final controller = ScaffoldMessenger.of(context).showSnackBar(snack);
    Future.delayed(snack.duration + const Duration(milliseconds: 100), () {
      try {
        controller.close();
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

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
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 32.0,
                vertical: 24.0,
              ),
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductImage(),
        const SizedBox(height: 24),
        _buildFormSection(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildProductImage(),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 1,
          child: _buildFormSection(),
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/product_images/print_shack.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Image not found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'Personalisation',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4d2963),
          ),
        ),
        const SizedBox(height: 16),

        // Price with tax
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF4d2963).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price (inc. tax):',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '£${_price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4d2963),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Text type dropdown
        const Text(
          'Text Input Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedTextType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(
              value: 'One Line of Text',
              child: Text('One Line of Text'),
            ),
            DropdownMenuItem(
              value: 'Two Lines of Text',
              child: Text('Two Lines of Text'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedTextType = value!;
            });
          },
        ),
        const SizedBox(height: 24),

        // Personalisation Line 1
        const Text(
          'Personalisation Line 1',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _line1Controller,
          maxLength: _maxCharacters,
          decoration: InputDecoration(
            hintText: 'Enter your text (max 10 characters)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            counterText: '${_line1Controller.text.length}/$_maxCharacters',
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 24),

        // Personalisation Line 2 (if selected)
        if (_selectedTextType == 'Two Lines of Text') ...[
          const Text(
            'Personalisation Line 2',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _line2Controller,
            maxLength: _maxCharacters,
            decoration: InputDecoration(
              hintText: 'Enter your text (max 10 characters)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              counterText: '${_line2Controller.text.length}/$_maxCharacters',
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
        ],

        // Quantity selector
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _quantity > 1
                    ? () {
                        setState(() {
                          _quantity--;
                        });
                      }
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  _quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Add to Cart Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _addToCart(context),
            child: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Info notes
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            border: Border.all(color: Colors.amber[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '£3 for one line of text! £5 for two!',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4d2963),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'One line of text is 10 characters.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Important notice
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.red[50],
            border: Border.all(color: Colors.red[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Please ensure all spellings are correct before submitting your purchase as we will print your item with the exact wording you provide. We will not be responsible for any incorrect spellings printed onto your garment. Personalised items do not qualify for refunds.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[900],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
