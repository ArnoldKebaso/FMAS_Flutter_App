// lib/models/user.dart

class User {
  final int? id;
  final String username;
  final String email;
  final String phone;
  final String location;
  final String role;
  final String? profilePhoto; // optional

  // Note: you probably won't store password in the model after registration.
  User({
    this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.location,
    this.role = 'viewer',
    this.profilePhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      role: json['role'] as String? ?? 'viewer',
      profilePhoto: json['profilePhoto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'user_id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'location': location,
      'role': role,
      // profilePhoto typically not sent on register
    };
  }
}
