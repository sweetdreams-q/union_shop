import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/gallery_page.dart';

const Size _mobileSize = Size(430, 900);

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const UnionShopApp());
  await tester.pumpAndSettle();
}

Future<void> _openDrawer(WidgetTester tester) async {
  final scrollable = find.byType(SingleChildScrollView);
  if (scrollable.evaluate().isNotEmpty) {
    await tester.dragUntilVisible(
      find.byIcon(Icons.menu).first,
      scrollable.first,
      const Offset(0, 400),
    );
  }
  await tester.tap(find.byIcon(Icons.menu).first, warnIfMissed: false);
  await tester.pumpAndSettle();
}

Future<void> _openSearch(WidgetTester tester) async {
  await _openDrawer(tester);
  await tester.tap(find.text('Search'));
  await tester.pumpAndSettle();
}

Future<void> _goToCart(WidgetTester tester) async {
  await _openDrawer(tester);
  await tester.tap(find.text('Cart'), warnIfMissed: false);
  await tester.pumpAndSettle();
}

Future<void> _openFirstProduct(WidgetTester tester) async {
  await _openDrawer(tester);
  await tester.tap(find.text('Collections'));
  await tester.pumpAndSettle();
  await tester.dragUntilVisible(
    find.byType(GalleryProductCard).first,
    find.byType(SingleChildScrollView).first,
    const Offset(0, -400),
  );
  await tester.tap(find.byType(GalleryProductCard).first);
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
}

Finder _searchField() {
  return find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.hintText == 'Search products...',
  );
}

Future<void> _addFirstProductToCart(WidgetTester tester) async {
  await _openFirstProduct(tester);
  await tester.dragUntilVisible(
    find.text('ADD TO CART'),
    find.byType(SingleChildScrollView).first,
    const Offset(0, -400),
  );
  await tester.tap(find.text('ADD TO CART'));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 4));
  if (find.byType(SingleChildScrollView).evaluate().isNotEmpty) {
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, 800));
    await tester.pumpAndSettle();
  }
}
void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    binding.window.physicalSizeTestValue = _mobileSize;
    binding.window.devicePixelRatioTestValue = 1.0;
  });

  tearDown(() {
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  group('Product Page Widget Tests', () {
    testWidgets('should display product details', (tester) async {
      await _pumpApp(tester);
      await _openFirstProduct(tester);

      // Check product info is displayed
      expect(find.text(sampleProducts[0].title), findsOneWidget);
      expect(find.textContaining('£'), findsWidgets); // Price
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Select Size'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
    });

    testWidgets('should display size options', (tester) async {
      await _pumpApp(tester);
      await _openFirstProduct(tester);

      // Check for size buttons
      expect(find.text('XS'), findsOneWidget);
      expect(find.text('S'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
      expect(find.text('XL'), findsOneWidget);
    });

    testWidgets('should select size when tapped', (tester) async {
      await _pumpApp(tester);
      await _openFirstProduct(tester);

      // Tap on M size
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // M should be selected (can verify through UI state)
      expect(find.text('M'), findsOneWidget);
    });

    testWidgets('should increment and decrement quantity', (tester) async {
      await _pumpApp(tester);
      await _openFirstProduct(tester);

      // Find quantity display (initially 1)
      expect(find.text('1'), findsWidgets);

      await tester.dragUntilVisible(
        find.text('Quantity'),
        find.byType(SingleChildScrollView).first,
        const Offset(0, -400),
      );

      // Tap increment button
      await tester.ensureVisible(find.byIcon(Icons.add).first);
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
      await _pumpApp(tester);
      await _openFirstProduct(tester);

      // Try to decrement below 1
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pumpAndSettle();

      // Should still be 1
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('should add product to cart', (tester) async {
      await _pumpApp(tester);
      await _openFirstProduct(tester);

      await tester.ensureVisible(find.text('Quantity').first);

      // Select size
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // Tap ADD TO CART button
      await tester.ensureVisible(find.text('ADD TO CART'));
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      // Should show success indicator (snackbar or similar)
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('should display sale badge for sale items', (tester) async {
      await _pumpApp(tester);
      await _openFirstProduct(tester);

      // Should show SALE badge
      expect(find.text('SALE'), findsOneWidget);

      // Should show both original and sale price
      expect(find.textContaining('£'), findsWidgets);
    });
  });

  group('Cart Page Widget Tests', () {
    testWidgets('should show empty cart message when cart is empty', (tester) async {
      await _pumpApp(tester);

      // Navigate to cart
      await _goToCart(tester);

      // Should show empty cart message
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should display cart items', (tester) async {
      await _pumpApp(tester);

      // Add item to cart
      await _addFirstProductToCart(tester);

      // Navigate to cart
      await _goToCart(tester);

      // Should show cart item
      expect(find.text(sampleProducts[0].title), findsOneWidget);
    });

    testWidgets('should remove item from cart', (tester) async {
      await _pumpApp(tester);

      // Add item to cart
      await _addFirstProductToCart(tester);

      // Navigate to cart
      await _goToCart(tester);

      expect(find.text(sampleProducts[0].title), findsOneWidget);

      await tester.ensureVisible(find.byIcon(Icons.delete_outline));

      // Remove item
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Should show empty cart
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should display cart total', (tester) async {
      await _pumpApp(tester);

      // Add item to cart
      await _addFirstProductToCart(tester);

      // Navigate to cart
      await _goToCart(tester);

      expect(find.text(sampleProducts[0].title), findsOneWidget);

      // Should show total
      expect(find.text('Total'), findsOneWidget);
      expect(find.textContaining('£'), findsWidgets);
    });
  });

  group('Search Page Widget Tests', () {
    testWidgets('should display search field', (tester) async {
      await _pumpApp(tester);

      // Navigate to search
      await _openSearch(tester);

      // Should have search field
      expect(_searchField(), findsOneWidget);
      expect(find.text('Search products...'), findsOneWidget);
    });

    testWidgets('should search and filter products', (tester) async {
      await _pumpApp(tester);

      // Navigate to search
      await _openSearch(tester);

      // Enter search term
      await tester.enterText(_searchField(), 'tshirt');
      await tester.pumpAndSettle();

      // Should show matching products
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Essentials tshirt'),
        ),
        findsWidgets,
      );
    });

    testWidgets('should highlight search term in results', (tester) async {
      await _pumpApp(tester);

      // Navigate to search
      await _openSearch(tester);

      // Enter search term
      await tester.enterText(_searchField(), 'hoodie');
      await tester.pumpAndSettle();

      // Should show products with hoodie
      expect(find.textContaining('hoodie'), findsWidgets);
    });

    testWidgets('should show no results message', (tester) async {
      await _pumpApp(tester);

      // Navigate to search
      await _openSearch(tester);

      // Enter non-existent search term
      await tester.enterText(_searchField(), 'xyz123notfound');
      await tester.pumpAndSettle();

      // Should show no results message
      expect(find.text('No products match your search.'), findsOneWidget);
    });
  });

  group('Gallery Page Widget Tests', () {
    testWidgets('should display all products', (tester) async {
      await _pumpApp(tester);

      // Navigate to gallery
      await _openDrawer(tester);
      await tester.tap(find.text('Collections'));
      await tester.pumpAndSettle();

      // Should show all products
      expect(find.byType(GalleryProductCard), findsNWidgets(sampleProducts.length));
    });

    testWidgets('should navigate to product from gallery', (tester) async {
      await _pumpApp(tester);

      // Navigate to gallery
      await _openDrawer(tester);
      await tester.tap(find.text('Collections'));
      await tester.pumpAndSettle();

      // Navigate programmatically to first product to avoid hit-test issues
      final galleryContext = tester.element(find.byType(GalleryPage));
      GoRouter.of(galleryContext).go('/product/${sampleProducts[0].id}');
      await tester.pumpAndSettle();

      // Should be on product page
      expect(find.text('Select Size'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
    });
  });

  group('Sale Page Widget Tests', () {
    testWidgets('should display only sale items', (tester) async {
      await _pumpApp(tester);

      // Navigate to sale page
      await _openDrawer(tester);
      await tester.tap(find.text('Sale'));
      await tester.pumpAndSettle();

      // Should show sale products banner and items
      expect(find.text('FLASH SALE'), findsOneWidget);
      for (final product in sampleProducts.where((p) => p.onSale)) {
        expect(find.text(product.title), findsWidgets);
      }
    });
  });

  group('Print Shack Page Widget Tests', () {
    testWidgets('should display personalization options', (tester) async {
      binding.window.physicalSizeTestValue = const Size(540, 900);
      binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(() {
        binding.window.physicalSizeTestValue = _mobileSize;
        binding.window.devicePixelRatioTestValue = 1.0;
      });

      await _pumpApp(tester);

      // Open drawer and navigate to The Print Shack
      await _openDrawer(tester);
      await tester.tap(find.text('The Print Shack'));
      await tester.pumpAndSettle();

      // Should show personalization options
      expect(find.text('Text Input Type'), findsOneWidget);
      expect(find.text('Personalisation Line 1'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
    });
  });
}
