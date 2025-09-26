import 'package:flutter/foundation.dart';
import 'package:giving_bridge/services/api_service.dart';
import 'package:giving_bridge/models/request.dart';

class RequestService with ChangeNotifier {
  final ApiService _apiService;

  List<DonationRequest> _requests = [];
  List<DonationRequest> _myRequests = [];
  List<DonationRequest> _requestsForMyDonations = [];
  bool _isLoading = false;
  String? _error;

  RequestService(this._apiService);

  // Getters
  List<DonationRequest> get requests => _requests;
  List<DonationRequest> get myRequests => _myRequests;
  List<DonationRequest> get requestsForMyDonations => _requestsForMyDonations;
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

  // Get all requests (filtered by user role)
  Future<void> getRequests({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) queryParams['status'] = status;

      final response = await _apiService.getList<DonationRequest>(
        '/requests',
        DonationRequest.fromJson,
        'requests',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        _requests = response.data ?? [];
      } else {
        _setError(response.error ?? 'Failed to load requests');
      }
    } catch (e) {
      _setError('Failed to load requests: $e');
    }

    _setLoading(false);
  }

  // Get request by ID
  Future<DonationRequest?> getRequestById(int id) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/requests/$id',
      );

      if (response.isSuccess && response.data != null) {
        return DonationRequest.fromJson(response.data!['request']);
      } else {
        _setError(response.error ?? 'Failed to load request');
        return null;
      }
    } catch (e) {
      _setError('Failed to load request: $e');
      return null;
    }
  }

  // Create new request
  Future<bool> createRequest(CreateRequestRequest request) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/requests',
        request.toJson(),
      );

      if (response.isSuccess) {
        // Refresh requests list
        await getMyRequests();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Failed to create request');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Failed to create request: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update request status
  Future<bool> updateRequestStatus(
    int id,
    UpdateRequestStatusRequest request,
  ) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        '/requests/$id/status',
        request.toJson(),
      );

      if (response.isSuccess) {
        // Refresh relevant lists
        await getRequestsForMyDonations();
        await getRequests();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Failed to update request status');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Failed to update request status: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete request
  Future<bool> deleteRequest(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.delete('/requests/$id');

      if (response.isSuccess) {
        // Remove from local lists
        _requests.removeWhere((r) => r.id == id);
        _myRequests.removeWhere((r) => r.id == id);
        _requestsForMyDonations.removeWhere((r) => r.id == id);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Failed to delete request');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Failed to delete request: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get current user's requests (receiver)
  Future<void> getMyRequests({int page = 1, int limit = 20}) async {
    _setLoading(true);
    _setError(null);

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.getList<DonationRequest>(
        '/requests/my/requests',
        DonationRequest.fromJson,
        'requests',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        _myRequests = response.data ?? [];
      } else {
        _setError(response.error ?? 'Failed to load your requests');
      }
    } catch (e) {
      _setError('Failed to load your requests: $e');
    }

    _setLoading(false);
  }

  // Get requests for current user's donations (donor)
  Future<void> getRequestsForMyDonations({int page = 1, int limit = 20}) async {
    _setLoading(true);
    _setError(null);

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.getList<DonationRequest>(
        '/requests/my/donations',
        DonationRequest.fromJson,
        'requests',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        _requestsForMyDonations = response.data ?? [];
      } else {
        _setError(
          response.error ?? 'Failed to load requests for your donations',
        );
      }
    } catch (e) {
      _setError('Failed to load requests for your donations: $e');
    }

    _setLoading(false);
  }

  // Get pending requests (admin)
  Future<List<DonationRequest>> getPendingRequests({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.getList<DonationRequest>(
        '/admin/requests/pending',
        DonationRequest.fromJson,
        'requests',
        queryParams: queryParams,
      );

      if (response.isSuccess) {
        return response.data ?? [];
      } else {
        _setError(response.error ?? 'Failed to load pending requests');
        return [];
      }
    } catch (e) {
      _setError('Failed to load pending requests: $e');
      return [];
    }
  }

  // Get request statistics
  Future<Map<String, dynamic>?> getRequestStats() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/requests/stats',
      );

      if (response.isSuccess && response.data != null) {
        return response.data!['stats'];
      } else {
        _setError(response.error ?? 'Failed to load request statistics');
        return null;
      }
    } catch (e) {
      _setError('Failed to load request statistics: $e');
      return null;
    }
  }

  // Approve request (donor/admin)
  Future<bool> approveRequest(int id, {String? notes}) async {
    return await updateRequestStatus(
      id,
      UpdateRequestStatusRequest(status: 'approved', adminNotes: notes),
    );
  }

  // Reject request (donor/admin)
  Future<bool> rejectRequest(int id, {String? notes}) async {
    return await updateRequestStatus(
      id,
      UpdateRequestStatusRequest(status: 'rejected', adminNotes: notes),
    );
  }

  // Complete request (donor/admin)
  Future<bool> completeRequest(int id, {String? notes}) async {
    return await updateRequestStatus(
      id,
      UpdateRequestStatusRequest(status: 'completed', adminNotes: notes),
    );
  }

  // Refresh all data
  Future<void> refresh() async {
    await getRequests();
  }

  // Get requests by status
  List<DonationRequest> getRequestsByStatus(String status) =>
      _requests.where((r) => r.status == status).toList();

  // Get pending requests from my requests
  List<DonationRequest> get pendingRequests =>
      _myRequests.where((r) => r.isPending).toList();

  // Get approved requests from my requests
  List<DonationRequest> get approvedRequests =>
      _myRequests.where((r) => r.isApproved).toList();

  // Get completed requests from my requests
  List<DonationRequest> get completedRequests =>
      _myRequests.where((r) => r.isCompleted).toList();

  // Get pending requests for my donations
  List<DonationRequest> get pendingRequestsForMyDonations =>
      _requestsForMyDonations.where((r) => r.isPending).toList();

  // Check if user has already requested a specific donation
  bool hasUserRequestedDonation(int donationId) {
    return _myRequests.any(
      (r) => r.donationId == donationId && (r.isPending || r.isApproved),
    );
  }
}
