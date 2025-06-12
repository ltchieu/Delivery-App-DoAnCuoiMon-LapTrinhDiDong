// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_create_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderCreateDto _$OrderCreateDtoFromJson(Map<String, dynamic> json) =>
    OrderCreateDto(
      customerId: json['CustomerId'] as String,
      serviceId: json['Serviceid'] as String?,
      deliveryPersonId: json['DeliveryPersonId'] as String?,
      totalAmount: (json['TotalAmount'] as num).toDouble(),
      sourceLocation:
          json['SourceLocation'] == null
              ? null
              : LocationDto.fromJson(
                json['SourceLocation'] as Map<String, dynamic>,
              ),
      destinationLocation:
          json['DestinationLocation'] == null
              ? null
              : LocationDto.fromJson(
                json['DestinationLocation'] as Map<String, dynamic>,
              ),
      estimatedDeliveryTime:
          json['EstimatedDeliveryTime'] == null
              ? null
              : DateTime.parse(json['EstimatedDeliveryTime'] as String),
      actualDeliveryTime:
          json['ActualDeliveryTime'] == null
              ? null
              : DateTime.parse(json['ActualDeliveryTime'] as String),
      pickupTime:
          json['PickupTime'] == null
              ? null
              : DateTime.parse(json['PickupTime'] as String),
      tenNguoiNhan: json['TenNguoiNhan'] as String?,
      sdtNguoiNhan: json['SdtnguoiNhan'] as String?,
      orderItems:
          (json['OrderItems'] as List<dynamic>)
              .map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      payment:
          json['Payment'] == null
              ? null
              : PaymentDto.fromJson(json['Payment'] as Map<String, dynamic>),
      vehicleId: json['VehicleId'] as String?,
    );

Map<String, dynamic> _$OrderCreateDtoToJson(
  OrderCreateDto instance,
) => <String, dynamic>{
  'CustomerId': instance.customerId,
  'Serviceid': instance.serviceId,
  'DeliveryPersonId': instance.deliveryPersonId,
  'TotalAmount': instance.totalAmount,
  'SourceLocation': instance.sourceLocation,
  'DestinationLocation': instance.destinationLocation,
  'EstimatedDeliveryTime': instance.estimatedDeliveryTime?.toIso8601String(),
  'ActualDeliveryTime': instance.actualDeliveryTime?.toIso8601String(),
  'PickupTime': instance.pickupTime?.toIso8601String(),
  'TenNguoiNhan': instance.tenNguoiNhan,
  'SdtnguoiNhan': instance.sdtNguoiNhan,
  'OrderItems': instance.orderItems,
  'Payment': instance.payment,
  'VehicleId': instance.vehicleId,
};
