import 'package:equatable/equatable.dart';

class UserAddress extends Equatable {
  final double latitude;
  final double longitude;
  final String addressLine;
  final String? landmark;
  final String village;
  final String pincode;

  const UserAddress({
    required this.latitude,
    required this.longitude,
    required this.addressLine,
    this.landmark,
    required this.village,
    required this.pincode,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        addressLine,
        landmark,
        village,
        pincode,
      ];
}
