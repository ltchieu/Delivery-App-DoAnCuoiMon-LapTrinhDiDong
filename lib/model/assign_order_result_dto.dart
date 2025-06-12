import 'package:json_annotation/json_annotation.dart';
part 'assign_order_result_dto.g.dart';

@JsonSerializable()
class AssignOrderResultDto {
  final bool success;
  final String message;
  final String orderId;
  final String? deliveryPersonId;
  final double distance;

  AssignOrderResultDto({
    required this.success,
    required this.message,

    required this.orderId,
    this.deliveryPersonId,
    required this.distance,
  });

  factory AssignOrderResultDto.fromJson(Map<String, dynamic> json) =>
      _$AssignOrderResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AssignOrderResultDtoToJson(this);
}
