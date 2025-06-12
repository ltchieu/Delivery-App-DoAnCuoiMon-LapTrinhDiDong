// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDto _$PaymentDtoFromJson(Map<String, dynamic> json) => PaymentDto(
  paymentMethod: json['PaymentMethod'] as String?,
  paymentStatus: json['PaymentStatus'] as String?,
  amount: (json['Amount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PaymentDtoToJson(PaymentDto instance) =>
    <String, dynamic>{
      'PaymentMethod': instance.paymentMethod,
      'PaymentStatus': instance.paymentStatus,
      'Amount': instance.amount,
    };
