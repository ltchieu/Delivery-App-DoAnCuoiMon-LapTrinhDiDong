import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/user.dart'; 
class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List customers = [];
  String searchKeyword = '';
  final apiUrl =
      'http://localhost:5141/api/users/customerslist'; // ← đổi IP máy bạn
  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    final uri = Uri.parse(apiUrl); // API trả về toàn bộ danh sách khách hàng
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          customers =
              (data as List)
                  .map((json) => User.fromJson(json))
                  .toList(); // Ánh xạ dữ liệu từ JSON sang model User
          totalPages =
              (customers.length / pageSize).ceil(); // Tính tổng số trang
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi lấy dữ liệu khách hàng!'),
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

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách khách hàng dựa trên từ khóa tìm kiếm
    final filtered = customers.where((c) {
      final name = c.userName.toLowerCase();
      return name.contains(searchKeyword.toLowerCase());
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
        title: const Text('Danh sách khách hàng'),
        backgroundColor: Colors.orange[800],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm khách hàng',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (val) => setState(() => searchKeyword = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentPageData.length,
              itemBuilder: (context, index) {
                final c = currentPageData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[800],
                      child: Text(
                        c.userName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      c.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${c.email} - ${c.phoneNumber ?? 'Không có số điện thoại'}'),
                    
                    onTap: () {
                      // Hành động khi nhấn vào khách hàng
                    },
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
                    ? () => setState(() {
                          currentPage--;
                        })
                    : null,
              ),
              Text('Trang $currentPage / $totalPages'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: currentPage < totalPages
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
}
