import 'package:do_an_cuoi_mon/view/Admin/AssignmentScreen.dart';
import 'package:do_an_cuoi_mon/view/Admin/VehicleScreen.dart';
import 'package:do_an_cuoi_mon/view/Notification.dart';
import 'package:do_an_cuoi_mon/view/PackageTrackingScreen.dart';
import 'package:do_an_cuoi_mon/view/order_details.dart';
import 'package:do_an_cuoi_mon/view/WelcomeScreen.dart';
import 'package:do_an_cuoi_mon/view/LoginScreen.dart';
import 'package:do_an_cuoi_mon/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:do_an_cuoi_mon/view/Admin/adminexport.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Ứng dụng giao hàng',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/Welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        'Notification': (context) => NotificationScreen(),
        'DiaChiGiaoHang': (context) => PackageTrackingScreen(),
        '/admin': (context) => const AdminScreen(),
        '/shipper': (context) => const ShippersPage(),
        '/customer': (context) => const CustomersPage(),
        '/vehicle': (context) => const VehicleScreen(),
        '/assignment': (context) => const AssignmentScreen(),
        '/stat': (context) => const Static(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        // Gửi token đến API để kiểm tra
        final response = await http.post(
          Uri.parse(
            'http://localhost:5141/api/auth/verify',
          ), // API kiểm tra token
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final role = data['role']; // Lấy thông tin role từ phản hồi API

          if (role == 'Admin') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (role == 'Shipper') {
            Navigator.pushReplacementNamed(context, '/shipper');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          // Token không hợp lệ hoặc hết hạn
          Navigator.pushReplacementNamed(context, '/Welcome');
        }
      } catch (e) {
        // Lỗi kết nối hoặc API
        Navigator.pushReplacementNamed(context, '/Welcome');
      }
    } else {
      // Không có token
      Navigator.pushReplacementNamed(context, '/Welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị ảnh đại diện
            Image.asset(
              'lib/images/logo_giaohang.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
