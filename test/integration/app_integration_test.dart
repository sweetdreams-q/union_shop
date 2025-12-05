import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  group('End-to-End Shopping Flow Integration Tests', () {
    testWidgets(
        'complete shopping journey: browse -> view -> add -> cart -> checkout',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Step 1: Start on home page
      expect(find.text('Home'), findsOneWidget);

      // Step 2: Browse products on home page
      expect(find.text('VIEW PRODUCT'), findsWidgets);

      // Step 3: Navigate to product detail page
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Step 4: Select size
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // Step 5: Set quantity to 2
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      // Step 6: Add to cart
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Step 7: Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Step 8: Verify item in cart
      expect(find.textContaining('Total'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('multi-product shopping flow', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Add first product
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Go back to home
      await tester.tap(find.text('Home').first);
      await tester.pumpAndSettle();

      // Add second product
      await tester.tap(find.text('VIEW PRODUCT').at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Should have 2 items
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
    });

    testWidgets('search and purchase flow', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Step 1: Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Step 2: Search for product
      await tester.enterText(find.byType(TextField), 'hoodie');
      await tester.pumpAndSettle();

      // Step 3: Click on search result
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Step 4: Add to cart (use available size if present)
      final sizeFinder = find.text('XL');
      if (sizeFinder.evaluate().isNotEmpty) {
        await tester.tap(sizeFinder);
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Step 5: Verify in cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();
      expect(find.textContaining('Total'), findsOneWidget);
    });

    testWidgets('navigation flow between all pages', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Home -> Collections
      await tester.tap(find.text('Collections'));
      await tester.pumpAndSettle();
      expect(find.text('VIEW PRODUCT'), findsNWidgets(4));

      // Collections -> About
      await tester.tap(find.text('About Us'));
      await tester.pumpAndSettle();
      expect(find.textContaining('About'), findsWidgets);

      // About -> Sale
      await tester.tap(find.text('Sale'));
      await tester.pumpAndSettle();
      expect(find.textContaining('SALE'), findsWidgets);

      // Sale -> Search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

      // Search -> Cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();
      expect(find.textContaining('empty'), findsOneWidget);

      // Cart -> Home
      await tester.tap(find.text('Home').first);
      await tester.pumpAndSettle();
      expect(find.text('Collections'), findsOneWidget);
    });

    testWidgets('cart management flow', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Add first item
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('S'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Add same product different size
      await tester.tap(find.text('L'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Should have 2 cart items (different sizes)
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));

      // Remove first item
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      // Should have 1 item left
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      // Remove last item
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Cart should be empty
      expect(find.textContaining('empty'), findsOneWidget);
    });

    testWidgets('sale item purchase flow', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to sale page
      await tester.tap(find.text('Sale'));
      await tester.pumpAndSettle();

      // Select a sale product
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Verify sale badge
      expect(find.text('SALE'), findsOneWidget);

      // Add to cart
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Check cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Verify sale price is applied
      expect(find.textContaining('£'), findsWidgets);
    });

    testWidgets('responsive layout: desktop to mobile navigation',
        (tester) async {
      // Test desktop layout
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Desktop should show text nav buttons
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Collections'), findsOneWidget);

      // Switch to mobile layout
      tester.view.physicalSize = const Size(400, 800);
      await tester.pumpAndSettle();

      // Mobile should show menu icon
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Drawer should contain navigation
      expect(find.text('Home'), findsWidgets);

      // Reset screen size
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('print shack customization flow', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to home first
      await tester.tap(find.text('Home').first);
      await tester.pumpAndSettle();

      // Find and tap Print Shack (might be in drawer on mobile)
      final printShackFinder = find.text('Print Shack');
      if (printShackFinder.evaluate().isEmpty) {
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.text('Print Shack').first);
      await tester.pumpAndSettle();

      // Select quantity
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      // Enter custom text (line 1)
      final textFormFields = find.byType(TextFormField);
      if (textFormFields.evaluate().isNotEmpty) {
        await tester.enterText(textFormFields.first, 'Custom Name');
        await tester.pumpAndSettle();
      }

      // Add to cart
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Verify in cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();
      expect(find.textContaining('Total'), findsOneWidget);
    });
  });

  group('Edge Cases and Error Handling Integration Tests', () {
    testWidgets('empty search results handling', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nonexistentproduct999');
      await tester.pumpAndSettle();

      expect(
          find.textContaining('No products match your search'), findsOneWidget);
    });

    testWidgets('continue shopping from empty cart', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Cart should show empty state
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Navigate back home via header
      await tester.tap(find.text('Home').first);
      await tester.pumpAndSettle();
      expect(find.text('Collections'), findsOneWidget);
    });

    testWidgets('back navigation from product page', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Go back using header navigation
      await tester.tap(find.text('Home').first);
      await tester.pumpAndSettle();

      // Should be on home page
      expect(find.text('Collections'), findsOneWidget);
    });
  });

  group('Performance and State Management Integration Tests', () {
    testWidgets('cart state persists across navigation', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Navigate away
      await tester.tap(find.text('About Us'));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Cart should still have item
      expect(find.textContaining('Total'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('multiple rapid adds to cart', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // Add multiple times quickly
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('ADD TO CART'));
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Should merge into single cart item with quantity 3
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });
  });
}
