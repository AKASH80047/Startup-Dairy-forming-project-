enum PaymentMethod {
  cod,
  online,
  upi,
  qrManual,
  cash,
}

enum PaymentProvider {
  razorpay,
  cashfree,
  phonepe,
  manual,
  none,
}

enum PaymentStatus {
  created,
  pending,
  processing,
  authorized,
  paid,
  failed,
  cancelled,
  expired,
  refundPending,
  refunded,
  partiallyRefunded,
}
