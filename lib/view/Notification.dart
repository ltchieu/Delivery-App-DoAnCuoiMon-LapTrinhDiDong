import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDateSection('Today', [
            _buildNotificationItem(
              icon: Icons.check,
              iconColor: Colors.white,
              backgroundColor: const Color(0xFF4ECDC4),
              title: 'Payment Successful!',
              subtitle: 'You have made a shopping payment',
            ),
          ]),
          const SizedBox(height: 24),
          _buildDateSection('Yesterday', [
            _buildNotificationItem(
              icon: Icons.percent,
              iconColor: Colors.white,
              backgroundColor: const Color(0xFFFFC107),
              title: "Today's Special Offers",
              subtitle: 'You get a special promo today!',
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: Icons.add,
              iconColor: Colors.white,
              backgroundColor: const Color(0xFFFF5722),
              title: 'New Services Available!',
              subtitle: 'Now you can track service in nearby shop',
            ),
          ]),
          const SizedBox(height: 24),
          _buildDateSection('December 20, 2024', [
            _buildNotificationItem(
              icon: Icons.credit_card,
              iconColor: Colors.white,
              backgroundColor: const Color(0xFF2196F3),
              title: 'Credit Card Connected!',
              subtitle: 'Credit Card has been linked',
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: Icons.check,
              iconColor: Colors.white,
              backgroundColor: const Color(0xFF4CAF50),
              title: 'Account Setup Successful!',
              subtitle: 'Your account has been created',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date, List<Widget> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...notifications,
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
