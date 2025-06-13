import 'dart:convert';

import 'package:do_an_cuoi_mon/consts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapService {
  Map<String, String> descriptionToPlaceIdMap = {};

  Future<List<String>> getSuggestions(String input) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$GOOGLE_MAPS_API_KEY&language=vi',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final predictions = data['predictions'] as List;

      descriptionToPlaceIdMap.clear(); // xoá dữ liệu cũ

      return predictions.map<String>((item) {
        final description = item['description'] as String;
        final placeId = item['place_id'] as String;
        descriptionToPlaceIdMap[description] = placeId; // lưu map
        return description; // return cho TypeAhead
      }).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<LatLng?> getCoordinatesFromPlaceId(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_MAPS_API_KEY';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final location = data['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    }

    return null;
  }

  Future<String> getAddressFromLatLng(LatLng? location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location!.latitude,
      location.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      var streetAddress = place.street!;
      print('Địa chỉ: $streetAddress');
      return streetAddress;
    }
    return "";
  }

  Future<String> getFullAddressFromLatLng(LatLng? location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location!.latitude,
      location.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      String street = place.street ?? '';
      String details = [
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(' ');

      return '$street, $details';
    }
    return "";
  }

  //Lấy khoảng cách giữa điểm giao và điểm lấy hàng
  Future<Map<String, dynamic>?> getDistanceAndTimeInKmAndMinutes({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json'
      '?origins=$originLat,$originLng'
      '&destinations=$destLat,$destLng'
      '&mode=driving'
      '&departure_time=now'
      '&key=$GOOGLE_MAPS_API_KEY',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final element = data['rows'][0]['elements'][0];

        if (element['status'] == 'OK') {
          final distanceMeters = element['distance']['value'];
          final durationSeconds =
              element['duration_in_traffic']?['value'] ??
              element['duration']['value'];

          final distanceKm = distanceMeters / 1000.0;
          final durationMinutes = (durationSeconds / 60).round();

          return {'distanceKm': distanceKm, 'durationMinutes': durationMinutes};
        }
      }
    } catch (e) {
      print('Lỗi khi gọi Google API: $e');
    }

    return null;
  }
}
