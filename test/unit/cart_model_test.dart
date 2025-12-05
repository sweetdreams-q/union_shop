import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('CartModel Unit Tests', () {
    late CartModel cart;

    setUp(() {
      cart = CartModel();
    });

    test('should start with empty cart', () {
      expect(cart.items, isEmpty);
      expect(cart.totalPrice, equals(0.0));
      expect(cart.itemCount, equals(0));
    });

    test('should add item to cart', () {
      final product = sampleProducts[0];
      cart.addItem(product, size: ProductSize.m, quantity: 1);

      expect(cart.items.length, equals(1));
      expect(cart.items[0].product.id, equals(product.id));
      expect(cart.items[0].size, equals(ProductSize.m));
      expect(cart.items[0].quantity, equals(1));
    });

    test('should merge identical items (same product and size)', () {
      final product = sampleProducts[0];
      cart.addItem(product, size: ProductSize.m, quantity: 1);
      cart.addItem(product, size: ProductSize.m, quantity: 2);

      expect(cart.items.length, equals(1));
      expect(cart.items[0].quantity, equals(3));
    });

    test('should not merge items with different sizes', () {
      final product = sampleProducts[0];
      cart.addItem(product, size: ProductSize.m, quantity: 1);
      cart.addItem(product, size: ProductSize.l, quantity: 1);

      expect(cart.items.length, equals(2));
      expect(cart.items[0].size, equals(ProductSize.m));
      expect(cart.items[1].size, equals(ProductSize.l));
    });

    test('should calculate total price correctly', () {
      cart.addItem(sampleProducts[0], quantity: 2); // £8.00 each (on sale)
      cart.addItem(sampleProducts[1], quantity: 1); // £15.00

      expect(cart.totalPrice, equals(31.0)); // (8*2) + 15
    });

    test('should calculate total price with sale items', () {
      final saleProduct = sampleProducts.firstWhere((p) => p.onSale);
      cart.addItem(saleProduct, quantity: 1);

      final expectedPrice = parsePrice(saleProduct.salePrice!);
      expect(cart.totalPrice, equals(expectedPrice));
    });

    test('should remove item at index', () {
      cart.addItem(sampleProducts[0], quantity: 1);
      cart.addItem(sampleProducts[1], quantity: 1);

      expect(cart.items.length, equals(2));

      cart.removeAt(0);
      expect(cart.items.length, equals(1));
      expect(cart.items[0].product.id, equals(sampleProducts[1].id));
    });

    test('should not crash when removing invalid index', () {
      cart.addItem(sampleProducts[0], quantity: 1);

      cart.removeAt(-1);
      expect(cart.items.length, equals(1));

      cart.removeAt(10);
      expect(cart.items.length, equals(1));
    });

    test('should clear all items', () {
      cart.addItem(sampleProducts[0], quantity: 1);
      cart.addItem(sampleProducts[1], quantity: 1);
      cart.addItem(sampleProducts[2], quantity: 1);

      expect(cart.items.length, equals(3));

      cart.clear();
      expect(cart.items, isEmpty);
      expect(cart.totalPrice, equals(0.0));
    });

    test('should calculate item count correctly', () {
      cart.addItem(sampleProducts[0], quantity: 2);
      cart.addItem(sampleProducts[1], quantity: 3);

      expect(cart.itemCount, equals(5));
    });

    test('should notify listeners when items change', () {
      var notified = false;
      cart.addListener(() => notified = true);

      cart.addItem(sampleProducts[0], quantity: 1);
      expect(notified, isTrue);

      notified = false;
      cart.removeAt(0);
      expect(notified, isTrue);

      notified = false;
      cart.addItem(sampleProducts[1], quantity: 1);
      cart.clear();
      expect(notified, isTrue);
    });
  });

  group('parsePrice Unit Tests', () {
    test('should parse simple price', () {
      expect(parsePrice('£10.00'), equals(10.0));
      expect(parsePrice('£25.50'), equals(25.5));
    });

    test('should parse price without currency symbol', () {
      expect(parsePrice('10.00'), equals(10.0));
      expect(parsePrice('25.50'), equals(25.5));
    });

    test('should parse price with commas', () {
      expect(parsePrice('£1,000.00'), equals(1000.0));
      expect(parsePrice('£1,234.56'), equals(1234.56));
    });

    test('should return 0 for invalid prices', () {
      expect(parsePrice('invalid'), equals(0.0));
      expect(parsePrice(''), equals(0.0));
      expect(parsePrice('abc'), equals(0.0));
    });
  });

  group('CartItem Unit Tests', () {
    test('should calculate unit price correctly', () {
      final product = sampleProducts[0]; // This product is on sale
      final item = CartItem(
        product: product,
        size: ProductSize.m,
        quantity: 1,
      );

      // Should use sale price when product is on sale
      expect(item.unitPrice, equals(parsePrice(product.salePrice!)));
    });

    test('should use sale price when on sale', () {
      final saleProduct = sampleProducts.firstWhere((p) => p.onSale);
      final item = CartItem(
        product: saleProduct,
        size: ProductSize.m,
        quantity: 1,
      );

      expect(item.unitPrice, equals(parsePrice(saleProduct.salePrice!)));
    });

    test('should calculate subtotal correctly', () {
      final product = sampleProducts[0]; // This product is on sale
      final item = CartItem(
        product: product,
        size: ProductSize.m,
        quantity: 3,
      );

      // Should use sale price when product is on sale
      final expectedSubtotal = parsePrice(product.salePrice!) * 3;
      expect(item.subTotal, equals(expectedSubtotal));
    });
  });
}
