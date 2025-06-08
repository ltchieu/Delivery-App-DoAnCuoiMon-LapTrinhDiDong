// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeDto _$SizeDtoFromJson(Map<String, dynamic> json) => SizeDto(
  sizeId: json['sizeId'] as String?,
  description: json['description'] as String?,
  weight: (json['weight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SizeDtoToJson(SizeDto instance) => <String, dynamic>{
  'sizeId': instance.sizeId,
  'description': instance.description,
  'weight': instance.weight,
};
