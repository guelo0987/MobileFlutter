class Product {
  final String id;
  final String productName;
  final double productPrice;
  final int quantity;
  final String description;
  final String category;
  final String subCategory;
  final List<String> images;
  final bool popular;
  final bool recommend;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.images,
    required this.popular,
    required this.recommend,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      popular: json['popular'] ?? false,
      recommend: json['recommend'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'productName': productName,
        'productPrice': productPrice,
        'quantity': quantity,
        'description': description,
        'category': category,
        'subCategory': subCategory,
        'images': images,
        'popular': popular,
        'recommend': recommend,
      };
}
