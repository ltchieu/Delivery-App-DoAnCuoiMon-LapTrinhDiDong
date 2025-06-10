import 'package:json_annotation/json_annotation.dart';

part 'payment_dto.g.dart';

@JsonSerializable()
class PaymentDto {
  @JsonKey(name: 'PaymentMethod')
  final String? paymentMethod;

  @JsonKey(name: 'PaymentStatus')
  final String? paymentStatus;

  @JsonKey(name: 'Amount')
  final double? amount;

  PaymentDto({this.paymentMethod, this.paymentStatus, this.amount});

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDtoToJson(this);
}
