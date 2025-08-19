import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReview {
  final String reviewId;
  final String userId;
  final String productId;
  final String storeId;
  final int stars;
  final String message;
  final DateTime date;
  final Map<String, dynamic>? autresInfos;

  ProductReview({
    required this.reviewId,
    required this.userId,
    required this.productId,
    required this.storeId,
    required this.stars,
    required this.message,
    required this.date,
    this.autresInfos,
  });

  ProductReview copyWith({
    String? reviewId,
    String? userId,
    String? productId,
    String? storeId,
    int? stars,
    String? message,
    DateTime? date,
    Map<String, dynamic>? autresInfos,
  }) {
    return ProductReview(
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
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
      'productId': productId,
      'storeId': storeId,
      'stars': stars,
      'message': message,
      'date': Timestamp.fromDate(date),
      'autresInfos': autresInfos,
    };
  }

  factory ProductReview.fromMap(Map<String, dynamic> map) {
    return ProductReview(
      reviewId: map['reviewId'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      storeId: map['storeId'] ?? '',
      stars: map['stars']?.toInt() ?? 0,
      message: map['message'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      autresInfos: map['autresInfos'],
    );
  }

  factory ProductReview.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductReview.fromMap({
      ...data,
      'reviewId': doc.id,
    });
  }
}
