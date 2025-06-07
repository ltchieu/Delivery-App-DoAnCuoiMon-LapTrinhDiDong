class ServiceDto {
  String? serviceId;
  String? name;
  double? price;

  ServiceDto({this.serviceId, this.name, this.price});

  Map<String, dynamic> toJson() {
    return {'serviceId': serviceId, 'name': name, 'price': price};
  }

  factory ServiceDto.fromJson(Map<String, dynamic> json) {
    return ServiceDto(
      serviceId: json['serviceId'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
