import 'package:do_an_cuoi_mon/view/Notification.dart';
import 'package:do_an_cuoi_mon/view/PackageTrackingScreen.dart';
import 'package:do_an_cuoi_mon/view/WelcomeScreen.dart';
import 'package:do_an_cuoi_mon/view/LoginScreen.dart';
import 'package:do_an_cuoi_mon/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: SplashScreen(),
      routes: {
        '/Welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        'Notification': (context) => NotificationScreen(),
        'DiaChiGiaoHang': (context) => PackageTrackingScreen(),
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
      // Token tồn tại, chuyển đến HomePage
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Không có token, chuyển đến LoginScreen
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
