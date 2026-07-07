import '../../domain/entities/user_address.dart';

class UserAddressModel extends UserAddress {
  const UserAddressModel({
    required super.latitude,
    required super.longitude,
    required super.addressLine,
    super.landmark,
    required super.village,
    required super.pincode,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      addressLine: json['addressLine'] as String,
      landmark: json['landmark'] as String?,
      village: json['village'] as String,
      pincode: json['pincode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'addressLine': addressLine,
      'landmark': landmark,
      'village': village,
      'pincode': pincode,
    };
  }

  factory UserAddressModel.fromEntity(UserAddress entity) {
    return UserAddressModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      addressLine: entity.addressLine,
      landmark: entity.landmark,
      village: entity.village,
      pincode: entity.pincode,
    );
  }
}
