// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceDto _$ServiceDtoFromJson(Map<String, dynamic> json) => ServiceDto(
  serviceId: json['serviceId'] as String?,
  name: json['name'] as String?,
  price: (json['price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ServiceDtoToJson(ServiceDto instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'name': instance.name,
      'price': instance.price,
    };
