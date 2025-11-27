class Product {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

// Sample product data
const List<Product> sampleProducts = [
  Product(
    id: '1',
    title: 'Placeholder Product 1',
    price: '£10.00',
    imageUrl: 'assets/product_images/product1.png',
    description: 'This is a detailed description for Product 1. A wonderful item perfect for everyday use.',
  ),
  Product(
    id: '2',
    title: 'Placeholder Product 2',
    price: '£15.00',
    imageUrl: 'assets/product_images/product2.png',
    description: 'This is a detailed description for Product 2. High quality and great value for money.',
  ),
  Product(
    id: '3',
    title: 'Placeholder Product 3',
    price: '£20.00',
    imageUrl: 'assets/product_images/product3.png',
    description: 'This is a detailed description for Product 3. Premium quality with exceptional features.',
  ),
  Product(
    id: '4',
    title: 'Placeholder Product 4',
    price: '£25.00',
    imageUrl: 'assets/product_images/product4.png',
    description: 'This is a detailed description for Product 4. Our top-of-the-line offering with the best features.',
  ),
];
