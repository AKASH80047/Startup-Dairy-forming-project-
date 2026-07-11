import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class VerifyPayment {
  final PaymentRepository repository;

  VerifyPayment(this.repository);

  Future<Payment> call({
    required String paymentAttemptId,
    required String gatewayPaymentId,
    String? signature,
  }) {
    return repository.verifyPayment(
      paymentAttemptId: paymentAttemptId,
      gatewayPaymentId: gatewayPaymentId,
      signature: signature,
    );
  }
}
