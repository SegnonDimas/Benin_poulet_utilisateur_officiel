import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String orderId;
  final String customerId;
  final String customerName;
  final String storeId;
  final String sellerId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // 'pending', 'active', 'cancelled', 'completed'
  final String deliveryAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? notes;
  final Map<String, dynamic>? paymentInfo;
  final Map<String, dynamic>? deliveryInfo;

  Order({
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.storeId,
    required this.sellerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.orderDate,
    this.deliveryDate,
    this.notes,
    this.paymentInfo,
    this.deliveryInfo,
  });

  Order copyWith({
    String? orderId,
    String? customerId,
    String? customerName,
    String? storeId,
    String? sellerId,
    List<OrderItem>? items,
    double? totalAmount,
    String? status,
    String? deliveryAddress,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? notes,
    Map<String, dynamic>? paymentInfo,
    Map<String, dynamic>? deliveryInfo,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      storeId: storeId ?? this.storeId,
      sellerId: sellerId ?? this.sellerId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'storeId': storeId,
      'sellerId': sellerId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryDate': deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'notes': notes,
      'paymentInfo': paymentInfo,
      'deliveryInfo': deliveryInfo,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      storeId: map['storeId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      items: List<OrderItem>.from(
        (map['items'] ?? []).map((item) => OrderItem.fromMap(item)),
      ),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      deliveryAddress: map['deliveryAddress'] ?? '',
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      deliveryDate: map['deliveryDate'] != null 
          ? (map['deliveryDate'] as Timestamp).toDate() 
          : null,
      notes: map['notes'],
      paymentInfo: map['paymentInfo'],
      deliveryInfo: map['deliveryInfo'],
    );
  }

  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order.fromMap({...data, 'orderId': doc.id});
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  OrderItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
    );
  }
}
