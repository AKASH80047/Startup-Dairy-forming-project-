import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPaymentStatus {
  final PaymentRepository repository;

  GetPaymentStatus(this.repository);

  Future<Payment> call(String paymentId) {
    return repository.getPaymentStatus(paymentId);
  }
}
