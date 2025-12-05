import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/models/product.dart';

double parsePrice(String price) {
  // Remove currency symbols and commas, then parse
  final cleaned = price.replaceAll(RegExp(r'[^0-9\.]'), '');
  return double.tryParse(cleaned) ?? 0.0;
}

class CartItem {
  final Product product;
  final ProductSize? size;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.quantity,
  });

  double get unitPrice => parsePrice(product.onSale && product.salePrice != null ? product.salePrice! : product.price);
  double get subTotal => unitPrice * quantity;

  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'size': size?.name,
        'quantity': quantity,
      };
}

class CartModel extends ChangeNotifier {
  static const _storageKey = 'cart_items';
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw);
    if (decoded is! List) return;

    _items.clear();
    for (final entry in decoded) {
      if (entry is! Map<String, dynamic>) continue;
      final item = _fromJson(entry);
      if (item != null) {
        _items.add(item);
      }
    }
    notifyListeners();
  }

  void addItem(Product product, {ProductSize? size, int quantity = 1}) {
    // Merge with existing identical item (same product + size)
    final index = _items.indexWhere((i) => i.product.id == product.id && i.size == size);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, size: size, quantity: quantity));
    }
    _persist();
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    _persist();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _persist();
    notifyListeners();
  }

  double get total => _items.fold(0.0, (sum, item) => sum + item.subTotal);
  double get totalPrice => total; // Alias for total
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  CartItem? _fromJson(Map<String, dynamic> data) {
    final productId = data['productId'] as String?;
    if (productId == null) return null;
    Product? product;
    for (final p in sampleProducts) {
      if (p.id == productId) {
        product = p;
        break;
      }
    }
    product ??= sampleProducts.isNotEmpty ? sampleProducts.first : null;
    if (product == null) return null;

    final sizeRaw = data['size'] as String?;
    final size = sizeRaw == null
        ? null
        : ProductSize.values.cast<ProductSize?>().firstWhere(
              (s) => s?.name == sizeRaw,
              orElse: () => null,
            );

    final rawQuantity = data['quantity'] is int ? data['quantity'] as int : int.tryParse('${data['quantity']}') ?? 1;
    final quantity = rawQuantity.clamp(1, 9999).toInt();
    return CartItem(product: product, size: size, quantity: quantity);
  }

  void _persist() {
    SharedPreferences.getInstance().then((prefs) {
      final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
      prefs.setString(_storageKey, encoded);
    });
  }
}

class CartProvider extends InheritedNotifier<CartModel> {
  const CartProvider({super.key, required CartModel cart, required Widget child})
      : super(notifier: cart, child: child);

  static CartModel of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'No CartProvider found in context');
    return provider!.notifier!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<CartModel> oldWidget) => true;
}
