// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orde_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponseDto _$OrderResponseDtoFromJson(Map<String, dynamic> json) =>
    OrderResponseDto(
      orderID: json['orderID'] as String?,
      sourceLocation:
          json['sourceLocation'] == null
              ? null
              : LocationDto.fromJson(
                json['sourceLocation'] as Map<String, dynamic>,
              ),
      destinationLocation:
          json['destinationLocation'] == null
              ? null
              : LocationDto.fromJson(
                json['destinationLocation'] as Map<String, dynamic>,
              ),
      vehicleType: json['vehicleType'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      orderStatus: json['orderStatus'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      customerId: json['customerId'] as String?,
      tenNguoiNhan: json['tenNguoiNhan'] as String?,
      deliveryPersonId: json['deliveryPersonId'] as String?,
    );

Map<String, dynamic> _$OrderResponseDtoToJson(OrderResponseDto instance) =>
    <String, dynamic>{
      'orderID': instance.orderID,
      'sourceLocation': instance.sourceLocation?.toJson(),
      'destinationLocation': instance.destinationLocation?.toJson(),
      'vehicleType': instance.vehicleType,
      'totalAmount': instance.totalAmount,
      'orderStatus': instance.orderStatus,
      'paymentStatus': instance.paymentStatus,
      'createdAt': instance.createdAt?.toIso8601String(),
      'customerId': instance.customerId,
      'tenNguoiNhan': instance.tenNguoiNhan,
      'deliveryPersonId': instance.deliveryPersonId,
    };
