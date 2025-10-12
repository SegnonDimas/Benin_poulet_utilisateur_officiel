import 'package:benin_poulet/models/order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle de commande
class OrderModel {
  final String orderId;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String sellerId;
  final String sellerName;
  final String storeId; // ID de la boutique
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final DeliveryInfo deliveryInfo;
  final PaymentInfo paymentInfo;
  final OrderStatus currentStatus;
  final List<StatusHistory> statusHistory;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final String? rejectionReason;

  OrderModel({
    required this.orderId,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.sellerId,
    required this.sellerName,
    required this.storeId,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.deliveryInfo,
    required this.paymentInfo,
    required this.currentStatus,
    required this.statusHistory,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.rejectionReason,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      orderId: doc.id,
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      clientPhone: data['clientPhone'] ?? '',
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      storeId: data['storeId'] ??
          data['sellerId'] ??
          '', // Utiliser sellerId comme fallback
      items: (data['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromMap(e))
              .toList() ??
          [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      deliveryInfo: DeliveryInfo.fromMap(data['deliveryInfo'] ?? {}),
      paymentInfo: PaymentInfo.fromMap(data['paymentInfo'] ?? {}),
      currentStatus: OrderStatusExtension.fromString(
        data['currentStatus'] ?? 'pendingValidation',
      ),
      statusHistory: (data['statusHistory'] as List<dynamic>?)
              ?.map((e) => StatusHistory.fromMap(e))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: data['notes'],
      rejectionReason: data['rejectionReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'storeId': storeId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'deliveryInfo': deliveryInfo.toMap(),
      'paymentInfo': paymentInfo.toMap(),
      'currentStatus': currentStatus.value,
      'statusHistory': statusHistory.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'notes': notes,
      'rejectionReason': rejectionReason,
    };
  }

  OrderModel copyWith({
    String? orderId,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? sellerId,
    String? sellerName,
    String? storeId,
    List<OrderItem>? items,
    double? totalAmount,
    double? deliveryFee,
    DeliveryInfo? deliveryInfo,
    PaymentInfo? paymentInfo,
    OrderStatus? currentStatus,
    List<StatusHistory>? statusHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    String? rejectionReason,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      storeId: storeId ?? this.storeId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      currentStatus: currentStatus ?? this.currentStatus,
      statusHistory: statusHistory ?? this.statusHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  double get grandTotal => totalAmount + deliveryFee;
}

/// Article de commande
class OrderItem {
  final String productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'],
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }
}

/// Informations de livraison
class DeliveryInfo {
  final String address;
  final String? city;
  final String? receiverNum; // Numéro du destinataire
  final String? country;
  final String? additionalInfo;
  final String deliveryMode; // 'standard', 'express', 'pickup'
  final DateTime? estimatedDeliveryDate;

  DeliveryInfo({
    required this.address,
    this.city,
    this.receiverNum,
    this.country,
    this.additionalInfo,
    required this.deliveryMode,
    this.estimatedDeliveryDate,
  });

  factory DeliveryInfo.fromMap(Map<String, dynamic> map) {
    return DeliveryInfo(
      address: map['address'] ?? '',
      city: map['city'],
      receiverNum: map['receiverNum'],
      country: map['country'] ?? 'Bénin',
      additionalInfo: map['additionalInfo'],
      deliveryMode: map['deliveryMode'] ?? 'standard',
      estimatedDeliveryDate:
          (map['estimatedDeliveryDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'receiverNum': receiverNum,
      'country': country,
      'additionalInfo': additionalInfo,
      'deliveryMode': deliveryMode,
      'estimatedDeliveryDate': estimatedDeliveryDate != null
          ? Timestamp.fromDate(estimatedDeliveryDate!)
          : null,
    };
  }

  String get fullAddress {
    final parts = <String>[address];
    if (city != null) parts.add(city!);
    if (country != null) parts.add(country!);
    return parts.join(', ');
  }
}

/// Informations de paiement
class PaymentInfo {
  final String method; // 'cash', 'mobile_money', 'card', 'bank_transfer'
  final String status; // 'pending', 'paid', 'failed'
  final String? transactionId;
  final DateTime? paidAt;

  PaymentInfo({
    required this.method,
    required this.status,
    this.transactionId,
    this.paidAt,
  });

  factory PaymentInfo.fromMap(Map<String, dynamic> map) {
    return PaymentInfo(
      method: map['method'] ?? 'cash',
      status: map['status'] ?? 'pending',
      transactionId: map['transactionId'],
      paidAt: (map['paidAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'status': status,
      'transactionId': transactionId,
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
    };
  }

  String get methodLabel {
    switch (method) {
      case 'cash':
        return 'Paiement à la livraison';
      case 'mobile_money':
        return 'Mobile Money';
      case 'card':
        return 'Carte bancaire';
      case 'bank_transfer':
        return 'Virement bancaire';
      default:
        return method;
    }
  }
}

/// Historique des statuts
class StatusHistory {
  final OrderStatus status;
  final DateTime timestamp;
  final String? comment;
  final String? updatedBy;

  StatusHistory({
    required this.status,
    required this.timestamp,
    this.comment,
    this.updatedBy,
  });

  factory StatusHistory.fromMap(Map<String, dynamic> map) {
    return StatusHistory(
      status:
          OrderStatusExtension.fromString(map['status'] ?? 'pendingValidation'),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      comment: map['comment'],
      updatedBy: map['updatedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'timestamp': Timestamp.fromDate(timestamp),
      'comment': comment,
      'updatedBy': updatedBy,
    };
  }
}
