import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user_address.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final StorageService _storageService;

  // Base coordinates of Pandey Dairy Farm (Gopalpura, Jaipur)
  static const double farmLatitude = 26.8530;
  static const double farmLongitude = 75.7681;

  LocationCubit(this._storageService) : super(LocationInitial()) {
    _loadCachedAddress();
  }

  void _loadCachedAddress() {
    final cached = _storageService.getCachedAddress();
    if (cached != null) {
      final double distance = DistanceCalculator.calculateDistance(
        startLatitude: farmLatitude,
        startLongitude: farmLongitude,
        endLatitude: cached.latitude,
        endLongitude: cached.longitude,
      );

      emit(LocationSuccess(
        latitude: cached.latitude,
        longitude: cached.longitude,
        distanceKm: distance,
        address: cached,
      ));
    }
  }

  /// Attempts to fetch the user's current GPS location and geocode it.
  Future<void> fetchCurrentLocation() async {
    emit(LocationLoading());

    try {
      // 1. Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationServicesDisabled());
        return;
      }

      // 2. Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationPermissionDenied());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(LocationPermissionPermanentlyDenied());
        return;
      }

      // 3. Retrieve coordinates
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await updateLocationCoordinates(position.latitude, position.longitude);
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  /// Updates selected coordinates manually (e.g. from dragging marker pin on map)
  /// and recalculates distance and geocoded address.
  Future<void> updateLocationCoordinates(double lat, double lon) async {
    emit(LocationLoading());

    try {
      // Calculate distance from farm base
      final double distance = DistanceCalculator.calculateDistance(
        startLatitude: farmLatitude,
        startLongitude: farmLongitude,
        endLatitude: lat,
        endLongitude: lon,
      );

      // Perform reverse geocoding with a safe fallback
      UserAddress? address;
      try {
        final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks.first;
          
          final String addressLine = [
            place.street,
            place.subLocality,
            place.locality,
          ].where((s) => s != null && s.isNotEmpty).join(', ');

          address = UserAddress(
            latitude: lat,
            longitude: lon,
            addressLine: addressLine.isNotEmpty ? addressLine : 'Dropped Pin Location',
            landmark: place.name,
            village: place.subAdministrativeArea ?? place.locality ?? 'Unknown Locality',
            pincode: place.postalCode ?? '000000',
          );
        }
      } catch (_) {
        // Fallback address representation if reverse geocoding is unavailable offline
        address = UserAddress(
          latitude: lat,
          longitude: lon,
          addressLine: 'Coordinates: ${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}',
          village: 'Jaipur Region',
          pincode: '302015',
        );
      }

      emit(LocationSuccess(
        latitude: lat,
        longitude: lon,
        distanceKm: distance,
        address: address,
      ));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void setManualAddress(UserAddress address) {
    final double distance = DistanceCalculator.calculateDistance(
      startLatitude: farmLatitude,
      startLongitude: farmLongitude,
      endLatitude: address.latitude,
      endLongitude: address.longitude,
    );
    emit(LocationSuccess(
      latitude: address.latitude,
      longitude: address.longitude,
      distanceKm: distance,
      address: address,
    ));
    _storageService.cacheAddress(address);
  }
}
