import 'package:do_an_cuoi_mon/view/Notification.dart';
import 'package:do_an_cuoi_mon/view/PackageTrackingScreen.dart';
import 'package:do_an_cuoi_mon/view/home_page.dart';
import 'package:do_an_cuoi_mon/view/order_details.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Ứng dụng giao hàng',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        'CTDonHang': (context) => OrderDetails(),
        'Notification': (context) => NotificationScreen(),
        'DiaChiGiaoHang': (context) => PackageTrackingScreen(),
      },
    );
  }
}
