import '../../domain/entities/payment_session.dart';

class PaymentSessionModel extends PaymentSession {
  const PaymentSessionModel({
    required super.orderId,
    required super.paymentAttemptId,
    required super.gatewayOrderId,
    required super.amount,
    required super.currency,
  });

  factory PaymentSessionModel.fromJson(Map<String, dynamic> json) {
    return PaymentSessionModel(
      orderId: json['orderId'] as String,
      paymentAttemptId: json['paymentAttemptId'] as String,
      gatewayOrderId: json['gatewayOrderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'paymentAttemptId': paymentAttemptId,
      'gatewayOrderId': gatewayOrderId,
      'amount': amount,
      'currency': currency,
    };
  }
}
