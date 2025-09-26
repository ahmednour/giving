import 'package:giving_bridge/utils/date_parser.dart';
import 'package:giving_bridge/models/user.dart';

enum DonationCategory { food, clothing, books, electronics, furniture, other }

class Donation {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final DonationCategory category;
  final int donorId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? donor;

  Donation({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.donorId,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.donor,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      category: DonationCategory.values.firstWhere(
        (e) => e.toString() == 'DonationCategory.${json['category']}',
        orElse: () => DonationCategory.other,
      ),
      donorId: json['donor_id'],
      status: json['status'],
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      donor: json['donor'] != null ? User.fromJson(json['donor']) : null,
    );
  }

  bool get isAvailable => status == 'AVAILABLE';
}

class CreateDonationRequest {
  final String title;
  final String description;
  final String category;

  CreateDonationRequest({
    required this.title,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'category': category,
      };
}

class UpdateDonationRequest {
  final String? title;
  final String? description;
  final String? category;
  final String? status;

  UpdateDonationRequest({
    this.title,
    this.description,
    this.category,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category;
    if (status != null) data['status'] = status;
    return data;
  }
}
