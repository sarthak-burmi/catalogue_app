class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final String brand;
  final String category;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.brand,
    required this.category,
    required this.thumbnail,
  });

  double get discountedPrice => price * (1 - discountPercentage / 100);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Default to 0 if id is null
      title:
          json['title'] ?? 'Unknown', // Default to 'Unknown' if title is null
      description: json['description'] ?? '', // Default to empty string if null
      price: (json['price'] ?? 0).toDouble(), // Default to 0 if price is null
      discountPercentage:
          (json['discountPercentage'] ?? 0).toDouble(), // Default to 0 if null
      brand: json['brand'] ?? 'Unknown', // Default to 'Unknown' if null
      category: json['category'] ?? 'Unknown', // Default to 'Unknown' if null
      thumbnail: json['thumbnail'] ?? '', // Default to empty string if null
    );
  }
}
