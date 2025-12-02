enum ProductSize {
  xs('XS'),
  s('S'),
  m('M'),
  l('L'),
  xl('XL');

  final String label;
  const ProductSize(this.label);
}

class Product {
  final String id;
  final String title;
  final String price;
  final String? salePrice;
  final String imageUrl;
  final String description;
  final List<ProductSize> availableSizes;
  final bool onSale;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.salePrice,
    required this.imageUrl,
    required this.description,
    this.availableSizes = const [
      ProductSize.xs,
      ProductSize.s,
      ProductSize.m,
      ProductSize.l,
      ProductSize.xl,
    ],
    this.onSale = false,
  });
}

// Sample product data
const List<Product> sampleProducts = [
  Product(
    id: '1',
    title: 'Essentials tshirt',
    price: '£10.00',
    salePrice: '£8.00',
    imageUrl: 'assets/product_images/product1.png',
    description: 'This is a detailed description for Product 1. A wonderful item perfect for everyday use.',
    onSale: true,
  ),
  Product(
    id: '2',
    title: 'Essentials croptop',
    price: '£15.00',
    imageUrl: 'assets/product_images/product2.png',
    description: 'This is a detailed description for Product 2. High quality and great value for money.',
  ),
  Product(
    id: '3',
        title: 'Essentials hoodie',
        price: '£20.00',
        salePrice: '£16.00',
    imageUrl: 'assets/product_images/product3.png',
    description: 'This is a detailed description for Product 3. Premium quality with exceptional features.',
    onSale: true,
  ),
  Product(
    id: '4',
    title: 'Essentials jacket',
    price: '£25.00',
    imageUrl: 'assets/product_images/product4.png',
    description: 'This is a detailed description for Product 4. Our top-of-the-line offering with the best features.',
  ),
];
