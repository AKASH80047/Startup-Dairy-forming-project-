import 'package:equatable/equatable.dart';

class DailyMilkCustomerEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String village;
  final String address;
  final double morningQty;
  final double eveningQty;
  final double pricePerLitre;
  final DateTime startDate;
  final String status; // 'Active' or 'Paused'
  final String animalType; // 'Cow' or 'Buffalo'
  final String paymentCycle; // 'Monthly' or 'Weekly'
  final String notes;

  const DailyMilkCustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.village,
    required this.address,
    required this.morningQty,
    required this.eveningQty,
    required this.pricePerLitre,
    required this.startDate,
    required this.status,
    required this.animalType,
    required this.paymentCycle,
    this.notes = '',
  });

  DailyMilkCustomerEntity copyWith({
    String? status,
    double? morningQty,
    double? eveningQty,
    double? pricePerLitre,
    String? notes,
  }) {
    return DailyMilkCustomerEntity(
      id: id,
      name: name,
      phone: phone,
      village: village,
      address: address,
      morningQty: morningQty ?? this.morningQty,
      eveningQty: eveningQty ?? this.eveningQty,
      pricePerLitre: pricePerLitre ?? this.pricePerLitre,
      startDate: startDate,
      status: status ?? this.status,
      animalType: animalType,
      paymentCycle: paymentCycle,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'village': village,
      'address': address,
      'morningQty': morningQty,
      'eveningQty': eveningQty,
      'pricePerLitre': pricePerLitre,
      'startDate': startDate.toIso8601String(),
      'status': status,
      'animalType': animalType,
      'paymentCycle': paymentCycle,
      'notes': notes,
    };
  }

  factory DailyMilkCustomerEntity.fromJson(Map<String, dynamic> json) {
    return DailyMilkCustomerEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      village: json['village'] as String,
      address: json['address'] as String,
      morningQty: (json['morningQty'] as num).toDouble(),
      eveningQty: (json['eveningQty'] as num).toDouble(),
      pricePerLitre: (json['pricePerLitre'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      status: json['status'] as String,
      animalType: json['animalType'] as String,
      paymentCycle: json['paymentCycle'] as String,
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        village,
        address,
        morningQty,
        eveningQty,
        pricePerLitre,
        startDate,
        status,
        animalType,
        paymentCycle,
        notes,
      ];
}
