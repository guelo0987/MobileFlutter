class Banner {
  final String id;
  final String image;

  Banner({
    required this.id,
    required this.image,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    // Con las imágenes base64 no necesitamos hacer cambios,
    // simplemente aceptamos la URL tal como viene
    return Banner(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'image': image,
      };
}
