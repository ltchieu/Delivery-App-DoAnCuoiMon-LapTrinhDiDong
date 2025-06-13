//Gán shipper cho đơn hàng
import 'dart:convert';

import 'package:do_an_cuoi_mon/model/assign_order_result_dto.dart';
import 'package:http/http.dart' as http;

class AssignService {
  static Future<AssignOrderResultDto?> assignOrderToNearestShipper(
    String orderId,
  ) async {
    final url = Uri.parse('http://10.0.2.2:5141/api/Assignment/assign-order');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AssignOrderResultDto.fromJson(jsonData);
      } else {
        final jsonData = jsonDecode(response.body);
        print('Assign failed: ${jsonData['message']}');
        return AssignOrderResultDto.fromJson(jsonData);
      }
    } catch (e) {
      print('Error assigning order: $e');
      return null;
    }
  }
}
