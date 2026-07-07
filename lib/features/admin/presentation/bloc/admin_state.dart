import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_village_entity.dart';
import '../../domain/entities/daily_milk_customer_entity.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<AdminVillageEntity> villages;
  final List<DailyMilkCustomerEntity> dailyCustomers;

  const AdminLoaded({
    required this.villages,
    required this.dailyCustomers,
  });

  @override
  List<Object?> get props => [villages, dailyCustomers];
}

class AdminSuccess extends AdminState {
  final String message;
  const AdminSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
