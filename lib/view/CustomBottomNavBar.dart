import 'package:do_an_cuoi_mon/view/Account.dart';
import 'package:do_an_cuoi_mon/view/MessagesScreen.dart';
import 'package:do_an_cuoi_mon/view/OrdersScreen.dart';
import 'package:do_an_cuoi_mon/view/home_page.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String userId;
  final int currentIndex;
  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Account',
        ),
      ],
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersScreen(userId: userId),
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesScreen(userId: userId),
              ),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AccountScreen(userId: userId),
              ),
            );
            break;
        }
      },
    );
  }
}
