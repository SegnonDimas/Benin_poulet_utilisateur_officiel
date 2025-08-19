import 'package:cloud_firestore/cloud_firestore.dart';

class StoreReview {
  final String reviewId;
  final String userId;
  final String storeId;
  final int stars;
  final String message;
  final DateTime date;
  final Map<String, dynamic>? autresInfos;

  StoreReview({
    required this.reviewId,
    required this.userId,
    required this.storeId,
    required this.stars,
    required this.message,
    required this.date,
    this.autresInfos,
  });

  StoreReview copyWith({
    String? reviewId,
    String? userId,
    String? storeId,
    int? stars,
    String? message,
    DateTime? date,
    Map<String, dynamic>? autresInfos,
  }) {
    return StoreReview(
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      storeId: storeId ?? this.storeId,
      stars: stars ?? this.stars,
      message: message ?? this.message,
      date: date ?? this.date,
      autresInfos: autresInfos ?? this.autresInfos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'storeId': storeId,
      'stars': stars,
      'message': message,
      'date': Timestamp.fromDate(date),
      'autresInfos': autresInfos,
    };
  }

  factory StoreReview.fromMap(Map<String, dynamic> map) {
    return StoreReview(
      reviewId: map['reviewId'] ?? '',
      userId: map['userId'] ?? '',
      storeId: map['storeId'] ?? '',
      stars: map['stars']?.toInt() ?? 0,
      message: map['message'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      autresInfos: map['autresInfos'],
    );
  }

  factory StoreReview.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoreReview.fromMap({
      ...data,
      'reviewId': doc.id,
    });
  }
}
