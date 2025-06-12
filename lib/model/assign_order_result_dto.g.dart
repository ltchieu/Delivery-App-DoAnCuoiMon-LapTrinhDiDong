// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_order_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignOrderResultDto _$AssignOrderResultDtoFromJson(
  Map<String, dynamic> json,
) => AssignOrderResultDto(
  success: json['success'] as bool,
  message: json['message'] as String,
  orderId: json['orderId'] as String,
  deliveryPersonId: json['deliveryPersonId'] as String?,
  distance: (json['distance'] as num).toDouble(),
);

Map<String, dynamic> _$AssignOrderResultDtoToJson(
  AssignOrderResultDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'orderId': instance.orderId,
  'deliveryPersonId': instance.deliveryPersonId,
  'distance': instance.distance,
};
