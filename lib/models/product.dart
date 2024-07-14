class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final int stockQuantity;
  final String? youtubeVideoId;
  // New property for YouTube video ID

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.stockQuantity,
    this.youtubeVideoId,
  });

  // Convert Product object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'stockQuantity': stockQuantity,
      'youtubeVideoId': youtubeVideoId,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      rating: json['rating'],
      stockQuantity: json['stockQuantity'],
      youtubeVideoId: json['youtubeVideoId'],
    );
  }
}