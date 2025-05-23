import 'package:do_an_cuoi_mon/view/CustomBottomNavBar.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(child: Text('No messages available.')),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}
