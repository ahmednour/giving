import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giving_bridge/services/api_service.dart';
import 'package:giving_bridge/models/user.dart';
import 'package:giving_bridge/models/request.dart';
import 'package:giving_bridge/services/notification_service.dart';

class AuthService with ChangeNotifier {
  final ApiService _apiService;
  NotificationService? _notificationService;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthService(this._apiService) {
    _initialize();
  }

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && _apiService.hasToken;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setNotificationService(NotificationService notificationService) {
    _notificationService = notificationService;
  }

  // Initialize service
  Future<void> _initialize() async {
    await _apiService.initialize();
    if (_apiService.hasToken) {
      await _loadCurrentUser();
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Load current user profile
  Future<void> _loadCurrentUser() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/auth/profile',
      );

      if (response.isSuccess && response.data != null) {
        _currentUser = User.fromJson(response.data!['user']);
        notifyListeners();
      } else {
        // Token might be invalid, clear it
        await logout();
      }
    } catch (e) {
      // Token might be invalid, clear it
      await logout();
    }
  }

  // Register new user
  Future<bool> register(RegisterRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/register',
        request.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final token = response.data!['token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;

        await _apiService.setToken(token);
        _currentUser = User.fromJson(userData);

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Registration failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: $e');
      _setLoading(false);
      return false;
    }
  }

  // Login user
  Future<bool> login(LoginRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/login',
        request.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final token = response.data!['token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;

        await _apiService.setToken(token);
        _currentUser = User.fromJson(userData);

        // Fetch notifications
        await _notificationService?.getMyNotifications();

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      _setLoading(false);
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);

    try {
      // Call logout endpoint (optional)
      await _apiService.post('/auth/logout', {});
    } catch (e) {
      // Ignore logout endpoint errors
    }

    // Clear local data
    await _apiService.clearToken();
    _currentUser = null;

    _setLoading(false);
    notifyListeners();
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/refresh',
        {},
      );

      if (response.isSuccess && response.data != null) {
        final token = response.data!['token'] as String;
        await _apiService.setToken(token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Verify token
  Future<bool> verifyToken() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/auth/verify',
      );

      if (response.isSuccess && response.data != null) {
        _currentUser = User.fromJson(response.data!['user']);
        notifyListeners();
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (phone != null) updateData['phone'] = phone;
      if (address != null) updateData['address'] = address;

      final response = await _apiService.put<Map<String, dynamic>>(
        '/users/profile',
        updateData,
      );

      if (response.isSuccess && response.data != null) {
        _currentUser = User.fromJson(response.data!['user']);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Profile update failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Profile update failed: $e');
      _setLoading(false);
      return false;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        '/users/password',
        {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      if (response.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Password change failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Password change failed: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get user statistics
  Future<UserStats?> getUserStats() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/users/stats',
      );

      if (response.isSuccess && response.data != null) {
        return UserStats.fromJson(response.data!['stats']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Deactivate account
  Future<bool> deactivateAccount() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.delete('/users/account');

      if (response.isSuccess) {
        await logout();
        return true;
      } else {
        _setError(response.error ?? 'Account deactivation failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Account deactivation failed: $e');
      _setLoading(false);
      return false;
    }
  }
}
