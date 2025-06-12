import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShippersPage extends StatefulWidget {
  const ShippersPage({super.key});

  @override
  State<ShippersPage> createState() => _ShippersPageState();
}

class _ShippersPageState extends State<ShippersPage> {
  List shippers = [];
  String searchKeyword = '';

  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchShippers();
  }

  Future<void> fetchShippers() async {
    final uri = Uri.parse(
      'http://localhost:5141/api/users/shipperslist',
    ); // API trả về toàn bộ danh sách
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          shippers = data; // Lưu toàn bộ danh sách shipper
          totalPages =
              (shippers.length / pageSize).ceil(); // Tính tổng số trang
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi khi tải danh sách shipper!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể kết nối đến API!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToDetails(Map<String, dynamic> shipper) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShipperDetailsPage(shipper: shipper),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách shipper dựa trên `isDeleted` và `searchKeyword`
    final filtered =
        shippers.where((s) {
          final name = s['userName']?.toLowerCase() ?? '';
          final isDeleted = s['isDeleted'] ?? false;
          return !isDeleted && name.contains(searchKeyword.toLowerCase());
        }).toList();

    // Lấy dữ liệu của trang hiện tại
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    final currentPageData = filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Shipper'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm shipper',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => searchKeyword = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentPageData.length,
              itemBuilder: (context, index) {
                final s = currentPageData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      s['userName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('SĐT: ${s['phoneNumber'] ?? 'Không có'}'),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.orange),
                      onSelected: (value) {
                        if (value == 'Xem') {
                          _navigateToDetails(s);
                        } else if (value == 'Sửa') {
                          _showShipperDialog(shipper: s);
                        } else if (value == 'Xóa') {
                          _confirmDelete(s['userId']);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'Xem',
                              child: Text('Xem'),
                            ),
                            const PopupMenuItem(
                              value: 'Sửa',
                              child: Text('Sửa'),
                            ),
                            const PopupMenuItem(
                              value: 'Xóa',
                              child: Text('Xóa'),
                            ),
                          ],
                    ),
                    onTap: () => _navigateToDetails(s),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed:
                    currentPage > 1
                        ? () => setState(() {
                          currentPage--;
                        })
                        : null,
              ),
              Text('Trang $currentPage / $totalPages'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed:
                    currentPage < totalPages
                        ? () => setState(() {
                          currentPage++;
                        })
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showShipperDialog({required Map<String, dynamic> shipper}) {
    final userNameController = TextEditingController(text: shipper['userName']);
    final phoneNumberController = TextEditingController(
      text: shipper['phoneNumber'],
    );
    final emailController = TextEditingController(
      text: shipper['email'],
    ); // Thêm email

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa thông tin Shipper'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(labelText: 'Tên Shipper'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng hộp thoại
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedShipper = {
                  'userId': shipper['userId'],
                  'userName': userNameController.text,
                  'phoneNumber': phoneNumberController.text,
                  'email': emailController.text, // Cập nhật email
                  'role': shipper['role'], // Giữ nguyên vai trò
                };

                await _updateShipper(updatedShipper);
                Navigator.pop(context); // Đóng hộp thoại sau khi cập nhật
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateShipper(Map<String, dynamic> updatedShipper) async {
    final uri = Uri.parse(
      'http://localhost:5141/api/users/updateShipper/${updatedShipper['userId']}',
    );
    print(
      jsonEncode({
        "userId": updatedShipper['userId'],
        "userName": updatedShipper['userName'],
        "email": updatedShipper['email'], // Gửi email
        "phoneNumber": updatedShipper['phoneNumber'],

        "role": updatedShipper['role'], // Giữ nguyên vai trò
      }),
    );
    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": updatedShipper['userId'],
          "userName": updatedShipper['userName'],
          "email": updatedShipper['email'], // Gửi email
          "phoneNumber": updatedShipper['phoneNumber'],

          "role": updatedShipper['role'], // Giữ nguyên vai trò
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Cập nhật danh sách shipper trong ứng dụng
          final index = shippers.indexWhere(
            (s) => s['userId'] == updatedShipper['userId'],
          );
          if (index != -1) {
            shippers[index] = updatedShipper;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể kết nối đến API!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(String userId) async {
    final uri = Uri.parse(
      'http://localhost:5141/api/users/deleteShipper/$userId',
    ); // Đổi IP theo máy bạn
    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        setState(() {
          shippers.removeWhere((shipper) => shipper['userId'] == userId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa shipper thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi khi xóa shipper!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể kết nối đến API!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ShipperDetailsPage extends StatelessWidget {
  final Map<String, dynamic> shipper;

  const ShipperDetailsPage({super.key, required this.shipper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết: ${shipper['userName']}'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ), // Avatar mặc định
            ),
            const SizedBox(height: 16),
            Text(
              shipper['userName'] ?? 'Không có tên',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              shipper['email'] ?? 'Không có email',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.orange),
                title: const Text('Số điện thoại'),
                subtitle: Text(shipper['phoneNumber'] ?? 'Không có'),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.orange),
                title: const Text('Loại xe'),
                subtitle: Text(shipper['vehicleType'] ?? 'Không có'),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(
                  Icons.confirmation_number,
                  color: Colors.orange,
                ),
                title: const Text('Biển số xe'),
                subtitle: Text(shipper['vehiclePlate'] ?? 'Không có'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
