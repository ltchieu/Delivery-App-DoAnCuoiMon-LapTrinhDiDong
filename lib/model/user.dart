class User {
  final String userId;
  final String userName;
  final String email;
  final String? phoneNumber; // Có thể null
  final String role;

  User({
    required this.userId,
    required this.userName,
    required this.email,
    this.phoneNumber,
    required this.role,
  });

  // Phương thức để ánh xạ từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'], // Có thể null
      role: json['role'] ?? '',
    );
  }

  // Phương thức để chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }
}