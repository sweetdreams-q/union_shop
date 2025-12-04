import 'package:flutter/material.dart';

typedef VoidCallbackWithContext = void Function(BuildContext context);

class ResponsiveHeader extends StatelessWidget {
  final VoidCallbackWithContext onHome;
  final VoidCallbackWithContext onAbout;
  final VoidCallbackWithContext onSearch;
  final VoidCallbackWithContext onProfile;
  final VoidCallbackWithContext onCart;
  final VoidCallbackWithContext onSale;
  final VoidCallbackWithContext? onGallery;
  final bool showBanner;
  final VoidCallbackWithContext? onOpenDrawer;

  const ResponsiveHeader({
    super.key,
    required this.onHome,
    required this.onAbout,
    required this.onSearch,
    required this.onProfile,
    required this.onCart,
    required this.onSale,
    this.onGallery,
    this.showBanner = true,
    this.onOpenDrawer,
  });

  static Widget buildDrawer(BuildContext context,
      {required VoidCallbackWithContext onHome,
      required VoidCallbackWithContext onAbout,
      required VoidCallbackWithContext onSearch,
      required VoidCallbackWithContext onProfile,
      required VoidCallbackWithContext onCart,
      required VoidCallbackWithContext onSale,
      VoidCallbackWithContext? onGallery}) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF4d2963)),
              child: Center(
                child: Text(
                  'Union Shop',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => onHome(context),
            ),
            if (onGallery != null)
              ListTile(
                leading: const Icon(Icons.grid_view),
                title: const Text('Gallery'),
                onTap: () => onGallery(context),
              ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => onAbout(context),
            ),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: const Text('Sale'),
              onTap: () => onSale(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () => onProfile(context),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () => onSearch(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Cart'),
              onTap: () => onCart(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Treat screens narrower than 600px as mobile for collapsing the header
    final isNarrow = MediaQuery.of(context).size.width < 600;

    Widget logo = GestureDetector(
      onTap: () => onHome(context),
      child: Image.network(
        'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
        height: 18,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            width: 18,
            height: 18,
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          );
        },
      ),
    );

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBanner)
              GestureDetector(
                onTap: () => onSale(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: const Color(0xFF4d2963),
                  child: const Text(
                    'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  logo,
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: isNarrow
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.search, size: 18, color: Colors.grey),
                                padding: const EdgeInsets.all(8),
                                onPressed: () => onSearch(context),
                              ),
                              IconButton(
                                icon: const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                padding: const EdgeInsets.all(8),
                                onPressed: () => onProfile(context),
                              ),
                              IconButton(
                                icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.grey),
                                padding: const EdgeInsets.all(8),
                                onPressed: () => onCart(context),
                              ),
                              IconButton(
                                icon: const Icon(Icons.menu, size: 18, color: Colors.grey),
                                padding: const EdgeInsets.all(8),
                                onPressed: () {
                                  if (onOpenDrawer != null) {
                                    onOpenDrawer!(context);
                                  } else {
                                    Scaffold.of(context).openEndDrawer();
                                  }
                                },
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () => onHome(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                child: const Text(
                                  'Home',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: () => onAbout(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                child: const Text(
                                  'About Us',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: () => onSale(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                child: const Text(
                                  'Sale',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.search, size: 18, color: Colors.grey),
                                padding: const EdgeInsets.all(8),
                                onPressed: () => onSearch(context),
                              ),
                              IconButton(
                                icon: const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                padding: const EdgeInsets.all(8),
                                onPressed: () => onProfile(context),
                              ),
                              IconButton(
                                icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.grey),
                                padding: const EdgeInsets.all(8),
                                onPressed: () => onCart(context),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
