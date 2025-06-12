import 'dart:convert';

import 'package:do_an_cuoi_mon/model/location_dto.dart';
import 'package:do_an_cuoi_mon/model/user_dto.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://localhost:5141/api/Users';

  static Future<void> saveOrUpdateUserLocation(
    String userId,
    LocationDto location,
  ) async {
    final url = Uri.parse('$baseUrl/$userId/location');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(location.toJson()),
    );

    if (response.statusCode == 204) {
      print('Location updated successfully.');
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    } else if (response.statusCode == 400) {
      throw Exception('Could not save location.');
    } else {
      throw Exception('Failed with status: ${response.statusCode}');
    }
  }

  static Future<LocationDto> getUserLocation(String userId) async {
    final url = Uri.parse('$baseUrl/$userId/location');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LocationDto.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('User or location not found.');
    } else {
      throw Exception('Failed to load user location: ${response.statusCode}');
    }
  }

  static Future<UserDto> getUserInfor(String userId) async {
    final url = Uri.parse('$baseUrl/$userId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserDto.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('User or location not found.');
    } else {
      throw Exception('Failed to load user location: ${response.statusCode}');
    }
  }
}
