import 'package:giving_bridge/models/donation.dart';
import 'package:giving_bridge/models/user.dart';
import 'package:giving_bridge/utils/date_parser.dart';

class DonationRequest {
  final int id;
  final int donationId;
  final int receiverId;
  final String? message;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Donation? donation;
  final User? receiver;

  DonationRequest({
    required this.id,
    required this.donationId,
    required this.receiverId,
    this.message,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.donation,
    this.receiver,
  });

  factory DonationRequest.fromJson(Map<String, dynamic> json) {
    return DonationRequest(
      id: json['id'],
      donationId: json['donation_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      status: json['status'],
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      donation:
          json['donation'] != null ? Donation.fromJson(json['donation']) : null,
      receiver:
          json['receiver'] != null ? User.fromJson(json['receiver']) : null,
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isCompleted => status == 'COMPLETED';

  get statusColor => null;

  get statusDisplayName => null;
}

class CreateRequestRequest {
  final int donationId;
  final String? message;

  CreateRequestRequest({required this.donationId, this.message});

  Map<String, dynamic> toJson() {
    return {
      'donation_id': donationId,
      'message': message,
    };
  }
}

class UpdateRequestStatusRequest {
  final String status;
  final String? adminNotes;

  UpdateRequestStatusRequest({required this.status, this.adminNotes});

  Map<String, dynamic> toJson() =>
      {'status': status, 'admin_notes': adminNotes};
}
