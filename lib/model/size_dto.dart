import 'package:json_annotation/json_annotation.dart';

part 'size_dto.g.dart';

@JsonSerializable()
class SizeDto {
  final String? sizeId;
  final String? description;
  final double? weight;

  SizeDto({this.sizeId, this.description, this.weight});

  factory SizeDto.fromJson(Map<String, dynamic> json) =>
      _$SizeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SizeDtoToJson(this);
}
