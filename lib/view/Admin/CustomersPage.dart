import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List customers = [];
  String searchKeyword = '';
  final apiUrl = 'http://localhost:5141/api/users/customerslist'; // ← đổi IP máy bạn
  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    final uri = Uri.parse('$apiUrl?page=$currentPage&pageSize=$pageSize');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        customers = data['data'];
        totalPages = data['totalPages'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi lấy dữ liệu khách hàng!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = customers.where((c) {
      final name = c['name']?.toLowerCase() ?? '';
      return name.contains(searchKeyword.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách khách hàng'),
        backgroundColor: Colors.orange[800], // Đặt màu nền AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm khách hàng',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => searchKeyword = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final c = filtered[index];
                return ListTile(
                  title: Text(c['name']),
                  subtitle: Text('${c['email']} - ${c['phone']}'),
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
                          fetchCustomers();
                        })
                    : null,
              ),
              Text('Trang $currentPage / $totalPages'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: currentPage < totalPages
                    ? () => setState(() {
                          currentPage++;
                          fetchCustomers();
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