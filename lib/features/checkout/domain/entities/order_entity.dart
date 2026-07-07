import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../location/domain/entities/user_address.dart';
import '../../../location/data/models/user_address_model.dart';

class OrderEntity extends Equatable {
  final String id;
  final String customerName;
  final String customerPhone;
  final UserAddress address;
  final String deliverySlot; // "morning" or "evening"
  final String paymentMethod; // "cod" or "credit"
  final List<CartItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double grandTotal;
  final DateTime createdAt;
  final String status; // "Pending", "Confirmed", "Preparing", "Out for Delivery", "Delivered", "Cancelled"

  const OrderEntity({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.deliverySlot,
    required this.paymentMethod,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.grandTotal,
    required this.createdAt,
    this.status = 'Pending',
  });

  OrderEntity copyWith({
    String? status,
  }) {
    return OrderEntity(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
      address: address,
      deliverySlot: deliverySlot,
      paymentMethod: paymentMethod,
      items: items,
      subtotal: subtotal,
      deliveryCharge: deliveryCharge,
      grandTotal: grandTotal,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'address': UserAddressModel.fromEntity(address).toJson(),
      'deliverySlot': deliverySlot,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'grandTotal': grandTotal,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      address: UserAddressModel.fromJson(json['address'] as Map<String, dynamic>),
      deliverySlot: json['deliverySlot'] as String,
      paymentMethod: json['paymentMethod'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryCharge: (json['deliveryCharge'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'Pending',
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerName,
        customerPhone,
        address,
        deliverySlot,
        paymentMethod,
        items,
        subtotal,
        deliveryCharge,
        grandTotal,
        createdAt,
        status,
      ];
}
