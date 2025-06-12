import 'package:json_annotation/json_annotation.dart';

part 'vehicles_dto.g.dart';

@JsonSerializable()
class VehiclesDto {
  @JsonKey(name: 'vehicleId')
  final String vehicleId;

  @JsonKey(name: 'vehicleType')
  final String vehicleType;

  @JsonKey(name: 'capacity')
  final int capacity;

  @JsonKey(name: 'price')
  final double price;

  VehiclesDto({
    required this.vehicleId,
    required this.vehicleType,
    required this.capacity,
    required this.price,
  });

  factory VehiclesDto.fromJson(Map<String, dynamic> json) =>
      _$VehiclesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclesDtoToJson(this);
}
