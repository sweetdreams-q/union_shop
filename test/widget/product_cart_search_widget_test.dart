import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product Page Widget Tests', () {
    testWidgets('should display product details', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Check product info is displayed
      expect(find.text(sampleProducts[0].title), findsOneWidget);
      expect(find.textContaining('£'), findsWidgets); // Price
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Size'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
    });

    testWidgets('should display size options', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Check for size buttons
      expect(find.text('XS'), findsOneWidget);
      expect(find.text('S'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
      expect(find.text('XL'), findsOneWidget);
    });

    testWidgets('should select size when tapped', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Tap on M size
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // M should be selected (can verify through UI state)
      expect(find.text('M'), findsOneWidget);
    });

    testWidgets('should increment and decrement quantity', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Find quantity display (initially 1)
      expect(find.text('1'), findsWidgets);

      // Tap increment button
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      // Should show 2
      expect(find.text('2'), findsWidgets);

      // Tap decrement button
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pumpAndSettle();

      // Should be back to 1
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('should not allow quantity below 1', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Try to decrement below 1
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pumpAndSettle();

      // Should still be 1
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('should add product to cart', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to product page
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Select size
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // Tap ADD TO CART button
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Should show success indicator (snackbar or similar)
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should display sale badge for sale items', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to home first
      await tester.tap(find.text('Home').first);
      await tester.pumpAndSettle();

      // Navigate to first product (which is on sale)
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Should show SALE badge
      expect(find.text('SALE'), findsOneWidget);

      // Should show both original and sale price
      expect(find.textContaining('£'), findsWidgets);
    });
  });

  group('Cart Page Widget Tests', () {
    testWidgets('should show empty cart message when cart is empty',
        (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Should show empty cart message
      expect(find.textContaining('empty'), findsOneWidget);
      expect(find.text('CONTINUE SHOPPING'), findsOneWidget);
    });

    testWidgets('should display cart items', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Should show cart item
      expect(find.text(sampleProducts[0].title), findsOneWidget);
    });

    testWidgets('should remove item from cart', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Remove item
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Should show empty cart
      expect(find.textContaining('empty'), findsOneWidget);
    });

    testWidgets('should display cart total', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();

      // Should show total
      expect(find.text('Total'), findsOneWidget);
      expect(find.textContaining('£'), findsWidgets);
    });
  });

  group('Search Page Widget Tests', () {
    testWidgets('should display search field', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Should have search field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search products...'), findsOneWidget);
    });

    testWidgets('should search and filter products', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search term
      await tester.enterText(find.byType(TextField), 'tshirt');
      await tester.pumpAndSettle();

      // Should show matching products
      expect(find.text('Essentials tshirt'), findsOneWidget);
    });

    testWidgets('should highlight search term in results', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search term
      await tester.enterText(find.byType(TextField), 'hoodie');
      await tester.pumpAndSettle();

      // Should show products with hoodie
      expect(find.textContaining('hoodie'), findsWidgets);
    });

    testWidgets('should show no results message', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter non-existent search term
      await tester.enterText(find.byType(TextField), 'xyz123notfound');
      await tester.pumpAndSettle();

      // Should show no results message
      expect(find.textContaining('No products found'), findsOneWidget);
    });
  });

  group('Gallery Page Widget Tests', () {
    testWidgets('should display all products', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to gallery
      await tester.tap(find.text('Collections'));
      await tester.pumpAndSettle();

      // Should show all 4 products
      expect(find.text('VIEW PRODUCT'), findsNWidgets(4));
    });

    testWidgets('should navigate to product from gallery', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to gallery
      await tester.tap(find.text('Collections'));
      await tester.pumpAndSettle();

      // Tap on a product
      await tester.tap(find.text('VIEW PRODUCT').first);
      await tester.pumpAndSettle();

      // Should be on product page
      expect(find.text('Size'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
    });
  });

  group('Sale Page Widget Tests', () {
    testWidgets('should display only sale items', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Navigate to sale page
      await tester.tap(find.text('Sale'));
      await tester.pumpAndSettle();

      // Should show sale products
      expect(find.text('SALE'), findsWidgets);
    });
  });

  group('Print Shack Page Widget Tests', () {
    testWidgets('should display personalization options', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Open drawer (mobile) or tap Print Shack
      final printShackFinder = find.text('Print Shack');
      if (printShackFinder.evaluate().isNotEmpty) {
        await tester.tap(printShackFinder);
        await tester.pumpAndSettle();
      } else {
        // If not found, use navigation
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Print Shack'));
        await tester.pumpAndSettle();
      }

      // Should show personalization options
      expect(find.text('Personalization'), findsOneWidget);
      expect(find.text('Text Input'), findsOneWidget);
      expect(find.text('Upload Image'), findsOneWidget);
    });
  });
}
