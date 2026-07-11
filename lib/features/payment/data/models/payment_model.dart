import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_enums.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.userId,
    required super.orderId,
    super.monthlyBillId,
    super.bulkOrderId,
    required super.method,
    required super.provider,
    required super.amount,
    required super.currency,
    required super.status,
    super.gatewayOrderId,
    super.gatewayPaymentId,
    super.gatewaySignature,
    super.utr,
    super.screenshotUrl,
    required super.createdAt,
    required super.updatedAt,
    super.verifiedAt,
    super.verifiedBy,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      orderId: json['orderId'] as String,
      monthlyBillId: json['monthlyBillId'] as String?,
      bulkOrderId: json['bulkOrderId'] as String?,
      method: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cod,
      ),
      provider: PaymentProvider.values.firstWhere(
        (e) => e.name == json['paymentProvider'],
        orElse: () => PaymentProvider.none,
      ),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      status: PaymentStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['status'] as String).toLowerCase(),
        orElse: () => PaymentStatus.created,
      ),
      gatewayOrderId: json['gatewayOrderId'] as String?,
      gatewayPaymentId: json['gatewayPaymentId'] as String?,
      gatewaySignature: json['gatewaySignature'] as String?,
      utr: json['utr'] as String?,
      screenshotUrl: json['screenshotUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      verifiedAt: json['verifiedAt'] != null ? DateTime.parse(json['verifiedAt'] as String) : null,
      verifiedBy: json['verifiedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderId': orderId,
      'monthlyBillId': monthlyBillId,
      'bulkOrderId': bulkOrderId,
      'paymentMethod': method.name,
      'paymentProvider': provider.name,
      'amount': amount,
      'currency': currency,
      'status': status.name.toUpperCase(),
      'gatewayOrderId': gatewayOrderId,
      'gatewayPaymentId': gatewayPaymentId,
      'gatewaySignature': gatewaySignature,
      'utr': utr,
      'screenshotUrl': screenshotUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'verifiedBy': verifiedBy,
    };
  }
}
