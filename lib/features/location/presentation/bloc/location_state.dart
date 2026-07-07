import 'package:equatable/equatable.dart';
import '../../domain/entities/user_address.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationServicesDisabled extends LocationState {}

class LocationPermissionDenied extends LocationState {}

class LocationPermissionPermanentlyDenied extends LocationState {}

class LocationSuccess extends LocationState {
  final double latitude;
  final double longitude;
  final double distanceKm;
  final UserAddress? address;

  const LocationSuccess({
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, distanceKm, address];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
