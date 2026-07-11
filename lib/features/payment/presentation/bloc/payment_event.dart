import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentRequested extends PaymentEvent {
  final String cartId;
  final String addressId;
  final String paymentMethod;

  const CreatePaymentRequested({
    required this.cartId,
    required this.addressId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [cartId, addressId, paymentMethod];
}

class PaymentCheckoutStarted extends PaymentEvent {}

class PaymentClientSuccessReceived extends PaymentEvent {
  final String paymentAttemptId;
  final String gatewayPaymentId;
  final String? signature;

  const PaymentClientSuccessReceived({
    required this.paymentAttemptId,
    required this.gatewayPaymentId,
    this.signature,
  });

  @override
  List<Object?> get props => [paymentAttemptId, gatewayPaymentId, signature];
}

class PaymentClientFailureReceived extends PaymentEvent {
  final String message;

  const PaymentClientFailureReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class VerifyPaymentRequested extends PaymentEvent {
  final String paymentAttemptId;
  final String gatewayPaymentId;
  final String? signature;

  const VerifyPaymentRequested({
    required this.paymentAttemptId,
    required this.gatewayPaymentId,
    this.signature,
  });

  @override
  List<Object?> get props => [paymentAttemptId, gatewayPaymentId, signature];
}

class RefreshPaymentStatusRequested extends PaymentEvent {
  final String paymentId;

  const RefreshPaymentStatusRequested(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}
