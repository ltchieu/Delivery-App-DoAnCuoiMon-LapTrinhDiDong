import 'package:json_annotation/json_annotation.dart';
part 'location_dto.g.dart';

@JsonSerializable()
class LocationDto {
  double? latitude;
  double? longitude;

  LocationDto({this.latitude, this.longitude});

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}
