class CategoryDto {
  String? categoryId;
  String? categoryName;

  CategoryDto({this.categoryId, this.categoryName});

  Map<String, dynamic> toJson() {
    return {'categoryId': categoryId, 'categoryName': categoryName};
  }

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
    );
  }
}
