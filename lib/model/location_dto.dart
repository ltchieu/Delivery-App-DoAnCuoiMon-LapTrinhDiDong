import 'package:json_annotation/json_annotation.dart';
part 'location_dto.g.dart';

@JsonSerializable()
class LocationDto {
  final double? latitude;
  final double? longitude;

  LocationDto({this.latitude, this.longitude});

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}

// @JsonSerializable()
// class Region {
//   Region({
//     required this.coords,
//     required this.id,
//     required this.name,
//     required this.zoom,
//   });

//   factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
//   Map<String, dynamic> toJson() => _$RegionToJson(this);

//   final LocationDto coords;
//   final String id;
//   final String name;
//   final double zoom;
// }

// @JsonSerializable()
// class Office {
//   Office({
//     required this.address,
//     required this.id,
//     required this.image,
//     required this.lat,
//     required this.lng,
//     required this.name,
//     required this.phone,
//     required this.region,
//   });

//   factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
//   Map<String, dynamic> toJson() => _$OfficeToJson(this);

//   final String address;
//   final String id;
//   final String image;
//   final double lat;
//   final double lng;
//   final String name;
//   final String phone;
//   final String region;
// }

// @JsonSerializable()
// class Locations {
//   Locations({required this.offices, required this.regions});

//   factory Locations.fromJson(Map<String, dynamic> json) =>
//       _$LocationsFromJson(json);
//   Map<String, dynamic> toJson() => _$LocationsToJson(this);

//   final List<Office> offices;
//   final List<Region> regions;
// }
