import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:giving_bridge/services/api_service.dart';
import 'package:giving_bridge/models/donation.dart';

class DonationService with ChangeNotifier {
  final ApiService _apiService;

  List<Donation> _donations = [];
  List<Donation> _myDonations = [];
  bool _isLoading = false;
  String? _error;

  DonationService(this._apiService);

  // Getters
  List<Donation> get donations => _donations;
  List<Donation> get myDonations => _myDonations;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  // Get all donations
  Future<void> getDonations({
    int page = 1,
    int limit = 20,
    String? status,
    String? category,
    String? search,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;

      final response = await _apiService.getList<Donation>(
        '/donations',
        Donation.fromJson,
        'donations',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        _donations = response.data ?? [];
      } else {
        _setError(response.error ?? 'Failed to load donations');
      }
    } catch (e) {
      _setError('Failed to load donations: $e');
    }

    _setLoading(false);
  }

  // Get donation by ID
  Future<Donation?> getDonationById(int id) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/donations/$id',
      );

      if (response.isSuccess && response.data != null) {
        return Donation.fromJson(response.data!['donation']);
      } else {
        _setError(response.error ?? 'Failed to load donation');
        return null;
      }
    } catch (e) {
      _setError('Failed to load donation: $e');
      return null;
    }
  }

  // Create new donation
  Future<bool> createDonation(CreateDonationRequest request,
      {File? image}) async {
    _setLoading(true);
    _setError(null);

    try {
      Map<String, String> data = {
        'title': request.title,
        'description': request.description,
        'category': request.category,
      };

      // If image is provided, upload it first
      if (image != null) {
        final uploadResponse =
            await _apiService.uploadFile<Map<String, dynamic>>(
          '/donations',
          image,
          additionalFields: data,
        );

        if (uploadResponse.isSuccess) {
          // Refresh donations list
          await getMyDonations();
          _setLoading(false);
          return true;
        } else {
          _setError(uploadResponse.error ?? 'Failed to upload donation');
          _setLoading(false);
          return false;
        }
      } else {
        // No image, use regular POST
        final response = await _apiService.post<Map<String, dynamic>>(
          '/donations',
          request.toJson(),
        );

        if (response.isSuccess) {
          // Refresh donations list
          await getMyDonations();
          _setLoading(false);
          return true;
        } else {
          _setError(response.error ?? 'Failed to create donation');
          _setLoading(false);
          return false;
        }
      }
    } catch (e) {
      _setError('Failed to create donation: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update donation
  Future<bool> updateDonation(int id, UpdateDonationRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        '/donations/$id',
        request.toJson(),
      );

      if (response.isSuccess) {
        // Refresh donations list
        await getDonations();
        await getMyDonations();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Failed to update donation');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Failed to update donation: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete donation
  Future<bool> deleteDonation(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.delete('/donations/$id');

      if (response.isSuccess) {
        // Remove from local lists
        _donations.removeWhere((d) => d.id == id);
        _myDonations.removeWhere((d) => d.id == id);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Failed to delete donation');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Failed to delete donation: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get current user's donations
  Future<void> getMyDonations({int page = 1, int limit = 20}) async {
    _setLoading(true);
    _setError(null);

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.getList<Donation>(
        '/donations/my/donations',
        Donation.fromJson,
        'donations',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        _myDonations = response.data ?? [];
      } else {
        _setError(response.error ?? 'Failed to load your donations');
      }
    } catch (e) {
      _setError('Failed to load your donations: $e');
    }

    _setLoading(false);
  }

  // Get donations with pending requests
  Future<List<Donation>> getDonationsWithRequests() async {
    try {
      final response = await _apiService.getList<Donation>(
        '/donations/with-requests',
        Donation.fromJson,
        'donations',
      );

      if (response.isSuccess) {
        return response.data ?? [];
      } else {
        _setError(response.error ?? 'Failed to load donations with requests');
        return [];
      }
    } catch (e) {
      _setError('Failed to load donations with requests: $e');
      return [];
    }
  }

  // Get donation statistics
  Future<Map<String, dynamic>?> getDonationStats() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/donations/stats',
      );

      if (response.isSuccess && response.data != null) {
        return response.data!['stats'];
      } else {
        _setError(response.error ?? 'Failed to load donation statistics');
        return null;
      }
    } catch (e) {
      _setError('Failed to load donation statistics: $e');
      return null;
    }
  }

  // Search donations
  Future<List<Donation>> searchDonations(String query) async {
    try {
      final queryParams = <String, String>{'search': query, 'limit': '50'};

      final response = await _apiService.getList<Donation>(
        '/donations',
        Donation.fromJson,
        'donations',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        return response.data ?? [];
      } else {
        _setError(response.error ?? 'Failed to search donations');
        return [];
      }
    } catch (e) {
      _setError('Failed to search donations: $e');
      return [];
    }
  }

  // Filter donations by category
  Future<void> filterByCategory(String category) async {
    await getDonations(category: category);
  }

  // Filter donations by status
  Future<void> filterByStatus(String status) async {
    await getDonations(status: status);
  }

  // Refresh all data
  Future<void> refresh() async {
    await getDonations();
  }

  // Get available donations only
  List<Donation> get availableDonations =>
      _donations.where((d) => d.isAvailable).toList();

  // Get donations by category
  List<Donation> getDonationsByCategory(String category) =>
      _donations.where((d) => d.category == category).toList();

  // Get featured donations (latest available donations)
  List<Donation> get featuredDonations => availableDonations.take(6).toList();
}
