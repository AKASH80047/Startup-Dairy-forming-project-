import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/payment_enums.dart';
import '../../domain/usecases/create_payment.dart';
import '../../domain/usecases/get_payment_status.dart';
import '../../domain/usecases/verify_payment.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentSession createPaymentSession;
  final VerifyPayment verifyPayment;
  final GetPaymentStatus getPaymentStatus;

  PaymentBloc({
    required this.createPaymentSession,
    required this.verifyPayment,
    required this.getPaymentStatus,
  }) : super(PaymentInitial()) {
    on<CreatePaymentRequested>(_onCreatePaymentRequested);
    on<PaymentCheckoutStarted>(_onPaymentCheckoutStarted);
    on<PaymentClientSuccessReceived>(_onPaymentClientSuccessReceived);
    on<PaymentClientFailureReceived>(_onPaymentClientFailureReceived);
    on<VerifyPaymentRequested>(_onVerifyPaymentRequested);
    on<RefreshPaymentStatusRequested>(_onRefreshPaymentStatusRequested);
  }

  Future<void> _onCreatePaymentRequested(
    CreatePaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentCreating());
    try {
      final session = await createPaymentSession(
        cartId: event.cartId,
        addressId: event.addressId,
        paymentMethod: event.paymentMethod,
      );
      emit(PaymentCheckoutReady(session));
    } catch (e) {
      emit(PaymentFailure('Failed to initiate transaction session: ${e.toString()}'));
    }
  }

  void _onPaymentCheckoutStarted(
    PaymentCheckoutStarted event,
    Emitter<PaymentState> emit,
  ) {
    emit(PaymentProcessing());
  }

  Future<void> _onPaymentClientSuccessReceived(
    PaymentClientSuccessReceived event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());
    add(VerifyPaymentRequested(
      paymentAttemptId: event.paymentAttemptId,
      gatewayPaymentId: event.gatewayPaymentId,
      signature: event.signature,
    ));
  }

  void _onPaymentClientFailureReceived(
    PaymentClientFailureReceived event,
    Emitter<PaymentState> emit,
  ) {
    emit(PaymentFailure(event.message));
  }

  Future<void> _onVerifyPaymentRequested(
    VerifyPaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());
    try {
      final payment = await verifyPayment(
        paymentAttemptId: event.paymentAttemptId,
        gatewayPaymentId: event.gatewayPaymentId,
        signature: event.signature,
      );
      
      if (payment.status == PaymentStatus.paid) {
        emit(PaymentSuccess(payment));
      } else if (payment.status == PaymentStatus.pending || payment.status == PaymentStatus.processing) {
        emit(PaymentVerificationPending(
          paymentAttemptId: event.paymentAttemptId,
          gatewayPaymentId: event.gatewayPaymentId,
        ));
      } else {
        emit(PaymentFailure('Transaction verification rejected: ${payment.status.name.toUpperCase()}'));
      }
    } catch (e) {
      emit(PaymentFailure('Verification error: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshPaymentStatusRequested(
    RefreshPaymentStatusRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());
    try {
      final payment = await getPaymentStatus(event.paymentId);
      if (payment.status == PaymentStatus.paid) {
        emit(PaymentSuccess(payment));
      } else if (payment.status == PaymentStatus.pending || payment.status == PaymentStatus.processing) {
        emit(PaymentVerificationPending(
          paymentAttemptId: payment.id,
          gatewayPaymentId: payment.gatewayPaymentId ?? '',
        ));
      } else {
        emit(PaymentFailure('Payment rejected by issuer: ${payment.status.name.toUpperCase()}'));
      }
    } catch (e) {
      emit(PaymentFailure('Failed to fetch transaction status: ${e.toString()}'));
    }
  }
}
