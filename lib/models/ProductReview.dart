class ProductReview {
  final String id;
  final String buyerId;
  final String email;
  final String fullName;
  final String productId;
  final int
      rating; // Nota: hay un error tipográfico en el esquema original (reting -> rating)
  final String review;

  ProductReview({
    required this.id,
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.productId,
    required this.rating,
    required this.review,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['_id'] ?? '',
      buyerId: json['buyerId'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      productId: json['productId'] ?? '',
      rating:
          json['reting'] ?? 0, // Usamos 'reting' porque así está en el backend
      review: json['review'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'buyerId': buyerId,
        'email': email,
        'fullName': fullName,
        'productId': productId,
        'reting':
            rating, // Mantenemos 'reting' para ser consistentes con el backend
        'review': review,
      };
}
