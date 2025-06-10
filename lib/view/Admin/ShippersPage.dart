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
  final apiUrl =
      'http://localhost:5141/api/users/shipperslist'; // 🔁 Sửa IP theo máy bạn
  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchShippers();
  }

  Future<void> fetchShippers() async {
    final uri = Uri.parse('$apiUrl?page=$currentPage&pageSize=$pageSize');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        shippers = data['data'];
        totalPages = data['totalPages'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi khi tải danh sách shipper!'),
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
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final s = filtered[index];
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
                          fetchShippers();
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
                          fetchShippers();
                        })
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showShipperDialog({required shipper}) {}

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
