import 'package:flutter/material.dart';
import 'package:do_an_cuoi_mon/view/Admin/AdminAccScreen.dart';
import 'package:do_an_cuoi_mon/view/Admin/Dashboard.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminScreenContent(), // Trang chủ
    const AdminAccScreen(), // Trang tài khoản
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: const Text('Xin chào, Admin'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/admin_avatar.png'),
            ),
          )
        ],
      ),
      body: _pages[_selectedIndex], // Hiển thị trang tương ứng
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Xử lý sự kiện chuyển trang
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}

class AdminScreenContent extends StatelessWidget {
  const AdminScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_AdminFeature> features = [
      _AdminFeature("Shipper", Icons.motorcycle, '/shipper'),
      _AdminFeature("Customer", Icons.person, '/customer'),
      _AdminFeature("Vehicle", Icons.local_shipping, '/vehicle'),
      _AdminFeature("Assignment", Icons.assignment, '/assignment'),
      _AdminFeature("Dashboard", Icons.dashboard, '/dashboard'),
      _AdminFeature("Thống kê", Icons.bar_chart, '/stats'),
    ];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: const [
              Icon(Icons.notifications_active, color: Colors.orange, size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Chào mừng bạn đến với trang quản trị!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Chức năng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: features.map((f) => _buildFeatureCard(context, f)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, _AdminFeature f) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, f.route),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(f.icon, size: 30, color: Colors.orange),
              const SizedBox(height: 10),
              Text(f.label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminFeature {
  final String label;
  final IconData icon;
  final String route;
  _AdminFeature(this.label, this.icon, this.route);
}