// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemDto _$OrderItemDtoFromJson(Map<String, dynamic> json) => OrderItemDto(
  sizeId: json['SizeId'] as String?,
  categoryId: json['CategoryId'] as String?,
);

Map<String, dynamic> _$OrderItemDtoToJson(OrderItemDto instance) =>
    <String, dynamic>{
      'SizeId': instance.sizeId,
      'CategoryId': instance.categoryId,
    };
