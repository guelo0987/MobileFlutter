class User {
  final String id;
  final String name;
  final String email;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'createdAt': createdAt,
      };
}
