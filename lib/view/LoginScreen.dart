import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Thời gian timeout mặc định cho request HTTP
  static const Duration _timeoutDuration = Duration(seconds: 10); // 10 giây

  Future<void> _loginUser() async {
    // Kiểm tra rỗng ngay từ đầu để tránh gửi request không cần thiết
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin Email và Mật khẩu.'),
          backgroundColor: Colors.red, // Màu đỏ cho lỗi
        ),
      );
      return; // Dừng hàm nếu thông tin không đầy đủ
    }

    // Hiển thị loading indicator
    showDialog(
      context: context,
      barrierDismissible:
          false, // Không cho phép đóng dialog bằng cách chạm ra ngoài
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final url = Uri.parse('http://10.0.2.2:5141/api/auth/login');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "email": emailController.text,
              "password": passwordController.text,
            }),
          )
          .timeout(_timeoutDuration); // Áp dụng timeout ở đây

      // Đóng loading indicator trước khi hiển thị SnackBar
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['token'];
        final user = data['user'];
        final role = user['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setString('userName', user['userName']);
        await prefs.setString('userId', user['userId']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công'),
            backgroundColor: Colors.green,
          ),
        );

        // Điều hướng theo role
        if (role == 'Shipper') {
          // Đảm bảo '/shipper' đã được định nghĩa trong MaterialApp.routes
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/shipper',
            (route) => false,
          );
        } else if (role == 'Admin') {
          // Đảm bảo '/admin' đã được định nghĩa trong MaterialApp.routes
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/admin',
            (route) => false,
          );
        } else {
          // Mặc định cho Customer hoặc các role khác, điều hướng về Home
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } else {
        // Xử lý các mã trạng thái HTTP khác 200
        String errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = 'Đăng nhập thất bại: ${errorData['message']}';
          } else if (errorData is String) {
            errorMessage = 'Đăng nhập thất bại: $errorData';
          } else {
            errorMessage = 'Đăng nhập thất bại: Mã lỗi ${response.statusCode}';
          }
        } catch (_) {
          // Fallback nếu response.body không phải JSON hợp lệ
          errorMessage = 'Đăng nhập thất bại: Mã lỗi ${response.statusCode}';
          if (response.body.isNotEmpty) {
            errorMessage += '\nNội dung phản hồi: ${response.body}';
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on TimeoutException catch (e) {
      // Xử lý lỗi timeout
      Navigator.pop(context); // Đóng loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi kết nối: Thời gian chờ quá lâu. Vui lòng thử lại sau.',
          ),
          backgroundColor: Colors.red,
          duration: _timeoutDuration, // Hiển thị SnackBar lâu hơn một chút
        ),
      );
    } on SocketException catch (e) {
      // Xử lý lỗi mất kết nối mạng hoặc không thể kết nối tới server
      Navigator.pop(context); // Đóng loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể kết nối tới server. Vui lòng kiểm tra kết nối mạng hoặc địa chỉ API.',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } on FormatException catch (e) {
      // Xử lý lỗi định dạng JSON không hợp lệ
      Navigator.pop(context); // Đóng loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi dữ liệu: Phản hồi từ server không hợp lệ. Vui lòng liên hệ hỗ trợ.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Xử lý các lỗi chung khác
      Navigator.pop(context); // Đóng loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi không mong muốn: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ của TextEditingController khi widget bị hủy
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Quay lại'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Đăng Nhập',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Vui lòng đăng nhập vào tài khoản của bạn',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 60),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress, // Gợi ý bàn phím email
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                // Gọi _loginUser() trực tiếp, hàm này đã xử lý kiểm tra rỗng
                _loginUser();
              },
              child: const Text(
                'Đăng Nhập',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
