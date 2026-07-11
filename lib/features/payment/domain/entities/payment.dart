import 'package:equatable/equatable.dart';
import 'payment_enums.dart';

class Payment extends Equatable {
  final String id;
  final String userId;
  final String orderId;
  final String? monthlyBillId;
  final String? bulkOrderId;
  final PaymentMethod method;
  final PaymentProvider provider;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? gatewayOrderId;
  final String? gatewayPaymentId;
  final String? gatewaySignature;
  final String? utr;
  final String? screenshotUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? verifiedAt;
  final String? verifiedBy;

  const Payment({
    required this.id,
    required this.userId,
    required this.orderId,
    this.monthlyBillId,
    this.bulkOrderId,
    required this.method,
    required this.provider,
    required this.amount,
    required this.currency,
    required this.status,
    this.gatewayOrderId,
    this.gatewayPaymentId,
    this.gatewaySignature,
    this.utr,
    this.screenshotUrl,
    required this.createdAt,
    required this.updatedAt,
    this.verifiedAt,
    this.verifiedBy,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        orderId,
        monthlyBillId,
        bulkOrderId,
        method,
        provider,
        amount,
        currency,
        status,
        gatewayOrderId,
        gatewayPaymentId,
        gatewaySignature,
        utr,
        screenshotUrl,
        createdAt,
        updatedAt,
        verifiedAt,
        verifiedBy,
      ];
}
