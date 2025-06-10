import 'package:json_annotation/json_annotation.dart';
part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  String? categoryId;
  String? categoryName;

  CategoryDto({this.categoryId, this.categoryName});

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}
