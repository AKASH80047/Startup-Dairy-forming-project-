import 'package:equatable/equatable.dart';

class PaymentSession extends Equatable {
  final String orderId;
  final String paymentAttemptId;
  final String gatewayOrderId;
  final double amount;
  final String currency;

  const PaymentSession({
    required this.orderId,
    required this.paymentAttemptId,
    required this.gatewayOrderId,
    required this.amount,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        orderId,
        paymentAttemptId,
        gatewayOrderId,
        amount,
        currency,
      ];
}
