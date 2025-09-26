import 'package:giving_bridge/utils/date_parser.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  bool get isDonor => role == 'DONOR';
  bool get isReceiver => role == 'RECEIVER';
  bool get isAdmin => role == 'ADMIN';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: (json['role'] as String? ?? '').toUpperCase(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

class UserStats {
  final int totalDonations;
  final int totalRequests;

  UserStats({required this.totalDonations, required this.totalRequests});

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalDonations: json['totalDonations'] ?? 0,
      totalRequests: json['totalRequests'] ?? 0,
    );
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String role;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
