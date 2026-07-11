import '../entities/payment_session.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentSession {
  final PaymentRepository repository;

  CreatePaymentSession(this.repository);

  Future<PaymentSession> call({
    required String cartId,
    required String addressId,
    required String paymentMethod,
  }) {
    return repository.createPaymentSession(
      cartId: cartId,
      addressId: addressId,
      paymentMethod: paymentMethod,
    );
  }
}
