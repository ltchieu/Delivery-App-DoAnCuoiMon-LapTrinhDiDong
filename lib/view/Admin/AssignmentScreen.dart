import 'package:flutter/material.dart';
class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý giao hàng'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Text(
          'Danh sách giao hàng sẽ được hiển thị ở đây.',
          style: TextStyle(fontSize: 20, color: Colors.blue[700]),
        ),
      ),
    );
  }
}