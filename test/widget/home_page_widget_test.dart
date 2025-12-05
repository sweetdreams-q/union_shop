import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/product.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    // Use narrow layout so header collapses to icons (avoids overflow from wide nav row).
    binding.window.physicalSizeTestValue = const Size(400, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
  });

  tearDown(() {
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  group('Home Page Widget Tests', () {
    testWidgets('should display logo and navigation', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check for logo and mobile nav icons
      expect(find.byType(Image), findsWidgets);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

      // Drawer holds the nav labels on small screens
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Collections'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Sale'), findsOneWidget);
    });

    testWidgets('should display carousel with images', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check for carousel
      expect(find.byType(PageView), findsOneWidget);

      // Wait for images to load
      await tester.pump();
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Scroll down to product grid on small screens
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -800));
      await tester.pumpAndSettle();

      // Check for product titles (cards are tappable instead of a dedicated button)
      for (var product in sampleProducts) {
        expect(find.text(product.title), findsWidgets);
      }
    });

    testWidgets('should navigate to product page when product card tapped',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Bring first product into view
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -800));
      await tester.pumpAndSettle();

      // Tap on first product card (by its title)
      await tester.tap(find.text(sampleProducts.first.title).first);
      await tester.pumpAndSettle();

      // Should be on product page
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Select Size'), findsOneWidget);
    });

    testWidgets('should navigate to gallery page', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Open drawer then tap Collections
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Collections').first);
      await tester.pumpAndSettle();

      // Should be on gallery page - all products visible by title
      for (var product in sampleProducts) {
        expect(find.text(product.title), findsWidgets);
      }
    });

    testWidgets('should navigate to about page', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Open drawer then tap About Us
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About').first);
      await tester.pumpAndSettle();

      // Should be on about page
      expect(find.textContaining('About'), findsWidgets);
    });

    testWidgets('should navigate to sale page', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Open drawer then tap Sale
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sale').first);
      await tester.pumpAndSettle();

      // Should be on sale page
      expect(find.textContaining('SALE'), findsWidgets);
    });

    testWidgets('should navigate to search page', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search).first);
      await tester.pumpAndSettle();

      // Should be on search page with search field
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Scroll to bottom to see footer
      await tester.drag(
          find.byType(SingleChildScrollView).first, const Offset(0, -1200));
      await tester.pumpAndSettle();

      // Check for footer content (use a stable label)
      expect(find.text('OPENING HOURS'), findsOneWidget);
    });

    testWidgets('should open mobile drawer on small screens', (tester) async {
      // Set small screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Tap menu icon
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Drawer should be open
      expect(find.byType(Drawer), findsOneWidget);

      // Reset screen size
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
