import 'package:flutter/material.dart';
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
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(Product product, {ProductSize? size, int quantity = 1}) {
    // Merge with existing identical item (same product + size)
    final index = _items.indexWhere((i) => i.product.id == product.id && i.size == size);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, size: size, quantity: quantity));
    }
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get total => _items.fold(0.0, (sum, item) => sum + item.subTotal);
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
