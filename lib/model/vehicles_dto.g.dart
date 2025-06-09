// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicles_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclesDto _$VehiclesDtoFromJson(Map<String, dynamic> json) => VehiclesDto(
  vehicleId: json['vehicleId'] as String,
  vehicleType: json['vehicleType'] as String,
  capacity: (json['capacity'] as num).toInt(),
  price: (json['price'] as num).toInt(),
);

Map<String, dynamic> _$VehiclesDtoToJson(VehiclesDto instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'vehicleType': instance.vehicleType,
      'capacity': instance.capacity,
      'price': instance.price,
    };
