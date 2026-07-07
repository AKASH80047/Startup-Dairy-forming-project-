import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/bulk_order_entity.dart';
import 'bulk_order_state.dart';

class BulkOrderCubit extends Cubit<BulkOrderState> {
  final StorageService _storageService;

  BulkOrderCubit(this._storageService) : super(BulkOrderInitial());

  /// Calculates the discount percentage based on the subtotal.
  static double calculateDiscountPercentage(double subtotal) {
    if (subtotal >= 50000.0) return 0.15; // 15% discount for premium event orders
    if (subtotal >= 25000.0) return 0.10; // 10% discount
    if (subtotal >= 10000.0) return 0.08; // 8% discount
    if (subtotal >= 5000.0) return 0.05;  // 5% discount
    if (subtotal >= 2000.0) return 0.02;  // 2% discount
    return 0.0;
  }

  /// Calculates the discount amount.
  static double calculateDiscount(double subtotal) {
    final double percentage = calculateDiscountPercentage(subtotal);
    return subtotal * percentage;
  }

  /// Calculates the minimum required advance payment (20% of the total).
  static double calculateMinAdvance(double total) {
    return total * 0.20;
  }

  /// Submits the bulk event booking and saves it to local history logs.
  Future<void> placeBulkOrder(BulkOrderEntity order) async {
    emit(BulkOrderLoading());
    try {
      // Validate advance payment is at least 20%
      final double minAdvance = calculateMinAdvance(order.grandTotal);
      if (order.advancePaid < minAdvance - 0.01) {
        emit(const BulkOrderError('Advance payment must be at least 20% of the total amount.'));
        return;
      }

      // Simulate API submit delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Save order to history logs
      await _storageService.saveBulkOrderToHistory(order);

      emit(BulkOrderSuccess(order));
    } catch (e) {
      emit(BulkOrderError(e.toString()));
    }
  }

  /// Resets the BLoC back to initial state.
  void resetBulkOrder() {
    emit(BulkOrderInitial());
  }
}
