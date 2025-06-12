import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  List vehicles = [];
  String searchKeyword = '';

  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    final uri = Uri.parse('http://localhost:5141/api/vehicles'); // API lấy danh sách xe
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          vehicles = data; // Lưu toàn bộ danh sách xe
          totalPages = (vehicles.length / pageSize).ceil(); // Tính tổng số trang
        });
      } else {
        _showMessage('Lỗi khi tải danh sách xe!', Colors.red);
      }
    } catch (e) {
      _showMessage('Không thể kết nối đến API!', Colors.red);
    }
  }

  void _navigateToDetails(Map<String, dynamic> vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailsPage(vehicle: vehicle),
      ),
    );
  }

  void _showVehicleDialog({Map<String, dynamic>? vehicle}) {
    final isEditing = vehicle != null;

    final vehicleTypeController = TextEditingController(text: vehicle?['vehicleType']);
    final licensePlateController = TextEditingController(text: vehicle?['licensePlate']);
    final capacityController = TextEditingController(text: vehicle?['capacity']?.toString());
    final priceController = TextEditingController(text: vehicle?['price']?.toString());

    String selectedVehicleType = vehicle?['vehicleType'] ?? 'Xe bán tải'; // Giá trị mặc định

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa thông tin xe' : 'Thêm xe mới'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Giới hạn chiều rộng
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Loại xe', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: selectedVehicleType,
                    isExpanded: true,
                    items: ['Xe bán tải', 'Xe máy', 'Xe tải']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVehicleType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: licensePlateController,
                    decoration: const InputDecoration(labelText: 'Biển số xe'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: capacityController,
                    decoration: const InputDecoration(labelText: 'Sức chứa'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Giá'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newVehicle = {
                  'vehicleType': selectedVehicleType,
                  'licensePlate': licensePlateController.text,
                  'capacity': int.tryParse(capacityController.text) ?? 0,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                };

                if (isEditing) {
                  newVehicle['vehicleId'] = vehicle!['vehicleId'];
                  await _updateVehicle(newVehicle);
                } else {
                  await _addVehicle(newVehicle);
                }

                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addVehicle(Map<String, dynamic> vehicle) async {
    final uri = Uri.parse('http://localhost:5141/api/vehicles'); // API thêm xe
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle),
      );

      if (response.statusCode == 201) {
        _showMessage('Thêm xe thành công!', Colors.green);
        fetchVehicles();
      } else {
        _showMessage('Lỗi khi thêm xe!', Colors.red);
      }
    } catch (e) {
      _showMessage('Không thể kết nối đến API!', Colors.red);
    }
  }

  Future<void> _updateVehicle(Map<String, dynamic> updatedVehicle) async {
    final uri = Uri.parse('http://localhost:5141/api/vehicles/${updatedVehicle['vehicleId']}'); // API cập nhật xe
    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedVehicle),
      );

      if (response.statusCode == 204) {
        setState(() {
          final index = vehicles.indexWhere((v) => v['vehicleId'] == updatedVehicle['vehicleId']);
          if (index != -1) {
            vehicles[index] = updatedVehicle;
          }
        });
        _showMessage('Cập nhật xe thành công!', Colors.green);
      } else {
        _showMessage('Lỗi khi cập nhật xe!', Colors.red);
      }
    } catch (e) {
      _showMessage('Không thể kết nối đến API!', Colors.red);
    }
  }

  void _confirmDelete(String vehicleId) async {
    final uri = Uri.parse('http://localhost:5141/api/vehicles/$vehicleId'); // API xóa xe
    try {
      final response = await http.delete(uri);
      if (response.statusCode == 204) {
        setState(() {
          vehicles.removeWhere((vehicle) => vehicle['vehicleId'] == vehicleId);
        });
        _showMessage('Xóa xe thành công!', Colors.green);
      } else {
        _showMessage('Lỗi khi xóa xe!', Colors.red);
      }
    } catch (e) {
      _showMessage('Không thể kết nối đến API!', Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = vehicles.where((v) {
      final name = v['vehicleType']?.toLowerCase() ?? '';
      return name.contains(searchKeyword.toLowerCase());
    }).toList();

    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    final currentPageData = filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý xe'),
        backgroundColor: Colors.orange[800], // Màu cam
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showVehicleDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm xe',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => searchKeyword = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentPageData.length,
              itemBuilder: (context, index) {
                final v = currentPageData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      v['vehicleType'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Biển số: ${v['licensePlate']}'),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.orange), // Màu cam
                      onSelected: (value) {
                        if (value == 'Xem') {
                          _navigateToDetails(v);
                        } else if (value == 'Sửa') {
                          _showVehicleDialog(vehicle: v);
                        } else if (value == 'Xóa') {
                          _confirmDelete(v['vehicleId']);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Xem', child: Text('Xem')),
                        const PopupMenuItem(value: 'Sửa', child: Text('Sửa')),
                        const PopupMenuItem(value: 'Xóa', child: Text('Xóa')),
                      ],
                    ),
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
                onPressed: currentPage > 1
                    ? () => setState(() => currentPage--)
                    : null,
              ),
              Text('Trang $currentPage / $totalPages'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: currentPage < totalPages
                    ? () => setState(() => currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VehicleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleDetailsPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết: ${vehicle['vehicleType']}'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.directions_car, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              vehicle['vehicleType'] ?? 'Không có loại xe',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Biển số: ${vehicle['licensePlate'] ?? 'Không có'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.confirmation_number, color: Colors.blue),
                title: const Text('Sức chứa'),
                subtitle: Text('${vehicle['capacity'] ?? 'Không có'}'),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.blue),
                title: const Text('Giá'),
                subtitle: Text('${vehicle['price'] ?? 'Không có'} VNĐ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
