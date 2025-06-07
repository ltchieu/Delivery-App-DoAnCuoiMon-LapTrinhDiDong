class LocationDto {
  double? latitude;
  double? longitude;

  LocationDto({this.latitude, this.longitude});

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
