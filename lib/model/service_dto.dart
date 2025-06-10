import 'package:json_annotation/json_annotation.dart';

part 'service_dto.g.dart';

@JsonSerializable()
class ServiceDto {
  final String? serviceId;
  final String? name;
  final double? price;

  ServiceDto({this.serviceId, this.name, this.price});

  factory ServiceDto.fromJson(Map<String, dynamic> json) =>
      _$ServiceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDtoToJson(this);
}
