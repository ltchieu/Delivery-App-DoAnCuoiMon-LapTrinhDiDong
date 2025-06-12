import 'dart:convert';
import 'package:do_an_cuoi_mon/model/assign_order_result_dto.dart';
import 'package:do_an_cuoi_mon/model/category_dto.dart';
import 'package:do_an_cuoi_mon/model/orde_response_dto.dart';
import 'package:do_an_cuoi_mon/model/order_create_dto.dart';
import 'package:do_an_cuoi_mon/model/service_dto.dart';
import 'package:do_an_cuoi_mon/model/size_dto.dart';
import 'package:do_an_cuoi_mon/model/vehicles_dto.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl =
      'http://10.0.2.2:5141/api/Orders'; // Thay bằng URL thực tế

  // Tạo đơn hàng
  static Future<OrderResponseDto> createOrder(OrderCreateDto orderDto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/saveOrder'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(orderDto.toJson()),
    );

    if (response.statusCode == 201) {
      return OrderResponseDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to create order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Lấy thông tin đơn hàng theo ID user
  static Future<List<OrderResponseDto>> getOrder(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => OrderResponseDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Lấy thông tin đơn hàng theo ID user
  static Future<List<OrderResponseDto>> getOrderByShipperId(
    String userId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/shipper/$userId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => OrderResponseDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Lấy tất cả các dịch vụ
  static Future<List<ServiceDto>> getServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/services'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => ServiceDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load services: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Lấy tất cả các size
  static Future<List<SizeDto>> getSizes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/sizes'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => SizeDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load sizes: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Lấy tất cả các loại hàng
  static Future<List<CategoryDto>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => CategoryDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load categories: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Lấy tất cả các loại xe
  static Future<List<VehiclesDto>> getVehicles() async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => VehiclesDto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load vehicles: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //Đổi trạng thái đơn hàng
  static Future<bool> updateOrderStatus(String orderId, String status) async {
    final url = Uri.parse('$baseUrl/$orderId/status');

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode(status);

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Cập nhật thành công!');
      return true;
    } else {
      print('Lỗi: ${response.statusCode}, ${response.body}');
      return false;
    }
  }

  // Lấy thông tin đơn hàng theo ID user
  static Future<OrderResponseDto> getOrderByOrderId(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$orderId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OrderResponseDto.fromJson(json);
    } else {
      throw Exception(
        'Failed to load order: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
