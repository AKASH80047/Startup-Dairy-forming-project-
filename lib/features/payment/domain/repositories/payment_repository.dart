import '../entities/payment.dart';
import '../entities/payment_session.dart';

abstract class PaymentRepository {
  Future<PaymentSession> createPaymentSession({
    required String cartId,
    required String addressId,
    required String paymentMethod,
  });

  Future<Payment> verifyPayment({
    required String paymentAttemptId,
    required String gatewayPaymentId,
    String? signature,
  });

  Future<Payment> getPaymentStatus(String paymentId);
}
