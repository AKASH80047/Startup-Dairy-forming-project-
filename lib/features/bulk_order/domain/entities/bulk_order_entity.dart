import 'package:equatable/equatable.dart';
import '../../../location/domain/entities/user_address.dart';
import '../../../location/data/models/user_address_model.dart';
import 'bulk_order_item.dart';

class BulkOrderEntity extends Equatable {
  final String id;
  final String customerName;
  final String customerPhone;
  final String eventType;
  final DateTime eventDate;
  final int expectedGuests;
  final UserAddress address;
  final List<BulkOrderItem> items;
  final double subtotal;
  final double discountAmount;
  final double deliveryCharge;
  final double advancePaid;
  final double pendingBalance;
  final double grandTotal;
  final String notes;
  final String paymentMethod; // 'cod' or 'upi'
  final String status; // 'Awaiting Advance', 'Confirmed', 'Out for Delivery', 'Delivered', 'Cancelled'
  final DateTime createdAt;

  const BulkOrderEntity({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.eventType,
    required this.eventDate,
    required this.expectedGuests,
    required this.address,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.deliveryCharge,
    required this.advancePaid,
    required this.pendingBalance,
    required this.grandTotal,
    required this.notes,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'eventType': eventType,
      'eventDate': eventDate.toIso8601String(),
      'expectedGuests': expectedGuests,
      'address': UserAddressModel.fromEntity(address).toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'deliveryCharge': deliveryCharge,
      'advancePaid': advancePaid,
      'pendingBalance': pendingBalance,
      'grandTotal': grandTotal,
      'notes': notes,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BulkOrderEntity.fromJson(Map<String, dynamic> json) {
    return BulkOrderEntity(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      eventType: json['eventType'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      expectedGuests: json['expectedGuests'] as int,
      address: UserAddressModel.fromJson(json['address'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((item) => BulkOrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      deliveryCharge: (json['deliveryCharge'] as num).toDouble(),
      advancePaid: (json['advancePaid'] as num).toDouble(),
      pendingBalance: (json['pendingBalance'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      notes: json['notes'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerName,
        customerPhone,
        eventType,
        eventDate,
        expectedGuests,
        address,
        items,
        subtotal,
        discountAmount,
        deliveryCharge,
        advancePaid,
        pendingBalance,
        grandTotal,
        notes,
        paymentMethod,
        status,
        createdAt,
      ];
}
