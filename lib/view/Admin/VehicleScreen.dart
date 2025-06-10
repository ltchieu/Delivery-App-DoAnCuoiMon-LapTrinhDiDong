import 'package:flutter/material.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}
class _VehicleScreenState extends State<VehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý xe'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Text(
          'Danh sách xe sẽ được hiển thị ở đây.',
          style: TextStyle(fontSize: 20, color: Colors.blue[700]),
        ),
      ),
    );
  }
}