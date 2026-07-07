import 'package:equatable/equatable.dart';
import '../../domain/entities/bulk_order_entity.dart';

abstract class BulkOrderState extends Equatable {
  const BulkOrderState();

  @override
  List<Object?> get props => [];
}

class BulkOrderInitial extends BulkOrderState {}

class BulkOrderLoading extends BulkOrderState {}

class BulkOrderSuccess extends BulkOrderState {
  final BulkOrderEntity order;
  const BulkOrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class BulkOrderError extends BulkOrderState {
  final String message;
  const BulkOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
