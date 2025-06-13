import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAccScreen extends StatefulWidget {
  const AdminAccScreen({super.key});

  @override
  State<AdminAccScreen> createState() => _AdminAccScreenState();
}

class _AdminAccScreenState extends State<AdminAccScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Text(
              'Admin Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'admin_email@domain.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: const Text('Đổi mật khẩu'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Đăng xuất'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () async {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  // Chuyển hướng về màn hình đăng nhập
                  Navigator.pushReplacementNamed(context, '/Welcome');
                } catch (e) {
                  // Hiển thị thông báo lỗi nếu xảy ra lỗi khi đăng xuất
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đăng xuất thất bại!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
