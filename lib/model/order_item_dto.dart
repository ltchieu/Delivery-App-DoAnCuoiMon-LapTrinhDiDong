import 'package:json_annotation/json_annotation.dart';

part 'order_item_dto.g.dart';

@JsonSerializable()
class OrderItemDto {
  @JsonKey(name: 'SizeId')
  final String? sizeId;

  @JsonKey(name: 'CategoryId')
  final String? categoryId;

  OrderItemDto({this.sizeId, this.categoryId});

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);
}
