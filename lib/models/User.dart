class User {
  final String id;
  final String name;
  final String email;
  final String? token;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}