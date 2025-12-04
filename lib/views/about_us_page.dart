import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/widgets/responsive_header.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  void navigateToCart(BuildContext context) {
    context.go('/cart');
  }

  void navigateToSearch(BuildContext context) {
    context.go('/search');
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: ResponsiveHeader.buildDrawer(
        context,
        onHome: (c) => navigateToHome(c),
        onAbout: (c) => {},
        onSearch: (c) => navigateToSearch(c),
        onProfile: (c) => placeholderCallbackForButtons(),
        onCart: (c) => navigateToCart(c),
        onSale: (c) => c.go('/sale'),
        onGallery: (c) => c.go('/gallery'),
        onPrintShack: (c) => c.go('/print-shack'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveHeader(
              onHome: (c) => navigateToHome(c),
              onAbout: (c) => {},
              onSearch: (c) => navigateToSearch(c),
              onProfile: (c) => placeholderCallbackForButtons(),
              onCart: (c) => navigateToCart(c),
              onSale: (c) => c.go('/sale'),
              onGallery: (c) => c.go('/gallery'),
              onPrintShack: (c) => c.go('/print-shack'),
              onOpenDrawer: (c) => scaffoldKey.currentState?.openEndDrawer(),
            ),

            // About Us Content
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABOUT US',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Our Story Section
                      Text(
                        'Our Story',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Welcome to the University of Portsmouth Students\' Union Shop. '
                        'We are dedicated to serving the student community with quality products, '
                        'merchandise, and essentials at affordable prices.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Our Mission Section
                      Text(
                        'Our Mission',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'We strive to provide students with:\n\n'
                        '• High-quality university merchandise and branded items\n'
                        '• Affordable everyday essentials and supplies\n'
                        '• Excellent customer service and support\n'
                        '• A convenient shopping experience both online and in-store\n'
                        '• Special deals and discounts exclusive to Portsmouth students',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Why Choose Us Section
                      Text(
                        'Why Choose Us',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'As part of the Students\' Union, every purchase you make helps support '
                        'student activities, clubs, societies, and services on campus. Your support '
                        'directly contributes to making student life better at Portsmouth.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Contact Section
                      Text(
                        'Get In Touch',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Have questions or need assistance? We\'re here to help!\n\n'
                        'Visit us during our opening hours or contact us through our website. '
                        'Our friendly team is always ready to assist you with your shopping needs.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
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
