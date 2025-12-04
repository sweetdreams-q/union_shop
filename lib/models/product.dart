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
    description: 'The Essentials T-shirt is your go-to staple for everyday comfort and style. Made from premium 100% cotton, this classic crew neck tee features a relaxed fit that drapes perfectly on any body type. The soft, breathable fabric ensures all-day comfort whether you\'re attending lectures, studying in the library, or relaxing on campus. Available in multiple sizes, this versatile piece showcases the university emblem with pride. Machine washable and designed to maintain its shape and color after countless wears, it\'s the perfect foundation for any casual outfit.',
    onSale: true,
  ),
  Product(
    id: '2',
    title: 'Essentials croptop',
    price: '£15.00',
    imageUrl: 'assets/product_images/product2.png',
    description: 'Make a statement with the Essentials Crop Top, designed for the modern, confident student. This stylish piece features a flattering cropped silhouette that pairs perfectly with high-waisted jeans, skirts, or athletic wear. Crafted from a soft cotton-blend fabric with just the right amount of stretch, it offers both comfort and a sleek fit. The ribbed texture adds visual interest while the university branding sits proudly across the chest. Ideal for gym sessions, casual outings, or layering under jackets, this versatile crop top is a must-have addition to your wardrobe. Easy to care for and designed to keep its shape wear after wear.',
  ),
  Product(
    id: '3',
        title: 'Essentials hoodie',
        price: '£20.00',
        salePrice: '£16.00',
    imageUrl: 'assets/product_images/product3.png',
    description: 'Stay warm and represent your university with the Essentials Hoodie, the ultimate combination of comfort and collegiate pride. This premium pullover hoodie features a cozy fleece-lined interior that keeps you warm during chilly campus walks and autumn evenings. The adjustable drawstring hood and ribbed cuffs provide a customizable, secure fit, while the spacious kangaroo pocket keeps your hands warm and stores your essentials. Made from a durable cotton-polyester blend, this hoodie resists pilling and maintains its soft texture through countless washes. The classic fit works for everyone, and the bold university branding makes it clear where your loyalty lies. Perfect for layering or wearing on its own.',
    onSale: true,
  ),
  Product(
    id: '4',
    title: 'Essentials jacket',
    price: '£25.00',
    imageUrl: 'assets/product_images/product4.png',
    description: 'Elevate your outerwear game with the Essentials Jacket, designed to protect you from the elements while showcasing your university spirit. This premium lightweight jacket features water-resistant fabric that keeps you dry during unexpected rain showers, while the breathable material prevents overheating. The full-zip front with storm flap provides maximum weather protection, and the adjustable hem allows you to customize the fit. Multiple zippered pockets keep your phone, wallet, and keys secure, while the stand-up collar shields your neck from wind and cold. Finished with embroidered university branding and reflective details for visibility, this jacket is perfect for commuting, outdoor events, or everyday campus life. Packs easily into its own pocket for convenient storage.',
  ),
];
