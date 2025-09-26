import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _webBaseUrl = 'http://localhost:8000/api';

  String? _token;

  String get baseUrl {
    // Use different base URLs for web and mobile
    if (kIsWeb) {
      return _webBaseUrl; // Web
    } else {
      // For mobile platforms, we'll use localhost
      // In production, this should be updated to your server's IP/domain
      return 'http://localhost:8000/api';
    }
  }

  // Initialize service and load stored token
  Future<void> initialize() async {
    _token = await _getStoredToken();
  }

  // Get stored token from SharedPreferences
  Future<String?> _getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  // Store token in SharedPreferences
  Future<void> _storeToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      _token = token;
    } catch (e) {
      // No logger available, so just print error
      print('Error storing token: $e');
    }
  }

  // Remove token from SharedPreferences
  Future<void> _removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _token = null;
    } catch (e) {
      // No logger available, so just print error
      print('Error removing token: $e');
    }
  }

  // Get headers for requests
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Handle API response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // The backend API is inconsistent. Some responses are wrapped in a 'data' object,
        // while others (like login/register) return the payload at the root level.
        // This logic handles both cases.
        final dynamic payload = data.containsKey('data') ? data['data'] : data;

        if (fromJson != null && payload != null) {
          return ApiResponse.success(fromJson(payload as Map<String, dynamic>));
        }

        // This path is taken by login, register, etc., which expect the full map.
        return ApiResponse.success(payload as T);
      } else {
        // The backend sends the error message in either a 'message' or 'error' key.
        final message =
            data['error'] ?? data['message'] ?? 'Unknown error occurred';
        return ApiResponse.error(message, response.statusCode);
      }
    } catch (e) {
      return ApiResponse.error(
          'Failed to parse response: ${e.toString()}', response.statusCode);
    }
  }

  // Handle list response
  ApiResponse<List<T>> _handleListResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
    String listKey,
  ) {
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final listData = (data['data'] ?? data) as Map<String, dynamic>;
        final list = listData[listKey] as List?;
        if (list != null) {
          final items = list.map((item) => fromJson(item)).toList();
          return ApiResponse.success(items);
        } else {
          return ApiResponse.error(
              'List key "$listKey" not found in response', response.statusCode);
        }
      } else {
        final message =
            data['error'] ?? data['message'] ?? 'Unknown error occurred';
        return ApiResponse.error(message, response.statusCode);
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse list response: ${e.toString()}',
          response.statusCode);
    }
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _getHeaders());

      if (T == Map<String, dynamic>) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ApiResponse.success(data as T);
      }
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // GET request for lists
  Future<ApiResponse<List<T>>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    String listKey, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _getHeaders());

      return _handleListResponse(response, fromJson, listKey);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint,
    Map<String, dynamic> body, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: json.encode(body),
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint,
    Map<String, dynamic> body, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.put(
        uri,
        headers: _getHeaders(),
        body: json.encode(body),
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // DELETE request
  Future<ApiResponse<void>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.delete(uri, headers: _getHeaders());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(null);
      } else {
        try {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final message =
              data['error'] ?? data['message'] ?? 'Unknown error occurred';
          return ApiResponse.error(message, response.statusCode);
        } catch (e) {
          return ApiResponse.error(
              'Failed to parse error response', response.statusCode);
        }
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    File file, {
    Map<String, String>? additionalFields,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final request = http.MultipartRequest('POST', uri);

      // Add headers
      final headers = _getHeaders();
      headers.remove('Content-Type'); // Let multipart set this
      request.headers.addAll(headers);

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          file.path,
          filename: file.path.split('/').last,
        ),
      );

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Upload error: $e');
    }
  }

  // Authentication methods
  Future<void> setToken(String token) async {
    await _storeToken(token);
  }

  Future<void> clearToken() async {
    await _removeToken();
  }

  String? get token => _token;
  bool get hasToken => _token != null;
}

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse._({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse._(success: true, data: data);
  }

  factory ApiResponse.error(String error, [int? statusCode]) {
    return ApiResponse._(success: false, error: error, statusCode: statusCode);
  }

  bool get isSuccess => success;
  bool get isError => !success;
}
