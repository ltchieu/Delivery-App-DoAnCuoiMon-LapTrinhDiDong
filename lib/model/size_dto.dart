class SizeDto {
  String? sizeId;
  String? description;
  double? weight;

  SizeDto({this.sizeId, this.description, this.weight});

  Map<String, dynamic> toJson() {
    return {'sizeId': sizeId, 'description': description, 'weight': weight};
  }

  // Chuyển từ JSON sang DTO
  factory SizeDto.fromJson(Map<String, dynamic> json) {
    return SizeDto(
      sizeId: json['sizeId'] as String?,
      description: json['description'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }
}
