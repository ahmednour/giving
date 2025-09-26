import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AuthProvider extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _token;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _user != null;
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider() {
    _loadStoredAuth();
  }

  // Load stored authentication data
  Future<void> _loadStoredAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userData = prefs.getString(_userKey);

      if (token != null && userData != null) {
        _token = token;
        _user = User.fromJson(
          Map<String, dynamic>.from(
            // In a real app, you'd parse the JSON string here
            {},
          ),
        );
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _setStatus(AuthStatus.loading);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful login for demo purposes
      // In a real app, you'd make an HTTP request to your backend
      if (email.isNotEmpty && password.isNotEmpty) {
        _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        _user = User(
          id: '1',
          email: email,
          firstName: 'John',
          lastName: 'Doe',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _saveAuthData();
        _setStatus(AuthStatus.authenticated);
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        _setStatus(AuthStatus.error);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
      _setStatus(AuthStatus.error);
      return false;
    }
  }

  // Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _setStatus(AuthStatus.loading);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful registration for demo purposes
      // In a real app, you'd make an HTTP request to your backend
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _user = User(
        id: '1',
        email: email,
        firstName: firstName,
        lastName: lastName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _saveAuthData();
      _setStatus(AuthStatus.authenticated);
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _setStatus(AuthStatus.error);
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _setStatus(AuthStatus.loading);

    try {
      // Clear stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);

      _token = null;
      _user = null;
      _errorMessage = null;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _errorMessage = 'Logout failed';
      _setStatus(AuthStatus.error);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? avatar,
  }) async {
    if (_user == null) return false;

    _setStatus(AuthStatus.loading);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful update for demo purposes
      _user = User(
        id: _user!.id,
        email: _user!.email,
        firstName: firstName,
        lastName: lastName,
        avatar: avatar ?? _user!.avatar,
        createdAt: _user!.createdAt,
        updatedAt: DateTime.now(),
      );

      await _saveAuthData();
      _setStatus(AuthStatus.authenticated);
      return true;
    } catch (e) {
      _errorMessage = 'Profile update failed. Please try again.';
      _setStatus(AuthStatus.error);
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _setStatus(
        _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      );
    }
  }

  // Private helper methods
  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> _saveAuthData() async {
    if (_token != null && _user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _token!);
      await prefs.setString(_userKey, _user!.toJson().toString());
    }
  }
}
