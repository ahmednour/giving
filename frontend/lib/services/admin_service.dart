import 'package:flutter/material.dart';
import 'package:giving_bridge/models/request.dart';
import 'package:giving_bridge/models/user.dart';
import 'package:giving_bridge/services/api_service.dart';

class AdminService with ChangeNotifier {
  final ApiService _apiService;

  AdminService(this._apiService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<User> _users = [];
  List<User> get users => _users;

  List<DonationRequest> _pendingRequests = [];
  List<DonationRequest> get pendingRequests => _pendingRequests;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> getUsers({int page = 1}) async {
    _setLoading(true);
    final response = await _apiService.get<Map<String, dynamic>>(
      '/admin/users?page=$page',
    );

    if (response.isSuccess && response.data != null) {
      final List<dynamic> userList = response.data!['users'];
      _users = userList.map((json) => User.fromJson(json)).toList();
      _currentPage = response.data!['currentPage'];
      _totalPages = response.data!['totalPages'];
    }
    _setLoading(false);
  }

  Future<void> getPendingRequests() async {
    _setLoading(true);
    final response = await _apiService.getList<DonationRequest>(
      '/admin/requests?status=PENDING',
      DonationRequest.fromJson,
      'requests',
    );

    if (response.isSuccess) {
      _pendingRequests = response.data ?? [];
    }
    _setLoading(false);
  }
}
