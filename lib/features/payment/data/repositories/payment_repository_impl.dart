import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_session.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaymentSession> createPaymentSession({
    required String cartId,
    required String addressId,
    required String paymentMethod,
  }) {
    return remoteDataSource.createPaymentSession(
      cartId: cartId,
      addressId: addressId,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<Payment> verifyPayment({
    required String paymentAttemptId,
    required String gatewayPaymentId,
    String? signature,
  }) {
    return remoteDataSource.verifyPayment(
      paymentAttemptId: paymentAttemptId,
      gatewayPaymentId: gatewayPaymentId,
      signature: signature,
    );
  }

  @override
  Future<Payment> getPaymentStatus(String paymentId) {
    return remoteDataSource.getPaymentStatus(paymentId);
  }
}
