import 'package:equatable/equatable.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_session.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentCreating extends PaymentState {}

class PaymentCheckoutReady extends PaymentState {
  final PaymentSession session;

  const PaymentCheckoutReady(this.session);

  @override
  List<Object?> get props => [session];
}

class PaymentProcessing extends PaymentState {}

class PaymentVerificationPending extends PaymentState {
  final String paymentAttemptId;
  final String gatewayPaymentId;

  const PaymentVerificationPending({
    required this.paymentAttemptId,
    required this.gatewayPaymentId,
  });

  @override
  List<Object?> get props => [paymentAttemptId, gatewayPaymentId];
}

class PaymentSuccess extends PaymentState {
  final Payment payment;

  const PaymentSuccess(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentFailure extends PaymentState {
  final String errorMessage;

  const PaymentFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PaymentCancelled extends PaymentState {}
