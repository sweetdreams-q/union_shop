import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/about_us_page.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubscribe() {
    if (_emailController.text.isNotEmpty) {
      // Placeholder for subscribe functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Subscribed with ${_emailController.text}'),
          duration: const Duration(seconds: 2),
        ),
      );
      _emailController.clear();
    }
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms and Conditions\n\n'
            'These are placeholder terms and conditions. '
            'Students should replace this with actual terms and conditions content.\n\n'
            '1. General Terms\n'
            '2. Privacy Policy\n'
            '3. Return Policy\n'
            '4. Shipping Information\n',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToAboutUs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutUsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFF2d2d2d),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: isWideScreen
          ? _buildWideLayout()
          : _buildNarrowLayout(),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildOpeningHours()),
        const SizedBox(width: 32),
        Expanded(child: _buildClosureDates()),
        const SizedBox(width: 32),
        Expanded(child: _buildHelpAndInfo()),
        const SizedBox(width: 32),
        Expanded(child: _buildSubscribe()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOpeningHours(),
        const SizedBox(height: 32),
        _buildClosureDates(),
        const SizedBox(height: 32),
        _buildHelpAndInfo(),
        const SizedBox(height: 32),
        _buildSubscribe(),
      ],
    );
  }

  Widget _buildOpeningHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OPENING HOURS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterText('Monday - Friday: 9:00 AM - 6:00 PM'),
        _buildFooterText('Saturday: 10:00 AM - 5:00 PM'),
        _buildFooterText('Sunday: 11:00 AM - 4:00 PM'),
      ],
    );
  }

  Widget _buildClosureDates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CLOSURE DATES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterText('Christmas Day: Closed'),
        _buildFooterText('New Year\'s Day: Closed'),
        _buildFooterText('Easter Sunday: Closed'),
        _buildFooterText('Bank Holidays: Reduced Hours'),
      ],
    );
  }

  Widget _buildHelpAndInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HELP & INFORMATION',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.go('/search'),
          child: _buildFooterText('Search'),
        ),
        _buildFooterText('Contact Us'),
        _buildFooterText('FAQs'),
        _buildFooterText('Shipping Information'),
        GestureDetector(
          onTap: _navigateToAboutUs,
          child: _buildFooterText('About Us'),
        ),
        GestureDetector(
          onTap: _showTermsAndConditions,
          child: _buildFooterText('Terms & Conditions'),
        ),
      ],
    );
  }

  Widget _buildSubscribe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUBSCRIBE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterText('Get updates on new products and special offers'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  filled: true,
                  fillColor: Colors.grey[800],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _handleSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4d2963),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('SUBSCRIBE'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}
