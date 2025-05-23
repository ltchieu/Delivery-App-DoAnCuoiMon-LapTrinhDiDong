import 'package:do_an_cuoi_mon/view/CustomBottomNavBar.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedStatus = 'All'; // Default filter value

  // Add list of available statuses
  final List<String> statuses = [
    'All',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Single Tab

          // New Filter Section with Horizontal Tabs
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        statuses.map((status) {
                          final isSelected = selectedStatus == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedStatus = status;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected ? Colors.orange : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.orange
                                            : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.grey[600],
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: ListView(
              children: [
                _buildOrderSection('Today', [
                  _buildOrderItem(
                    'Interstate Shipping',
                    'Rivera Park Saigon Building A',
                    'Ha Long Crystal Hotel',
                    '16/05/2024 | 10:48',
                    'In Progress',
                  ),
                ]),
                _buildOrderSection('April', [
                  _buildOrderItem(
                    'Express - Economy',
                    'The Coffee House',
                    '345 Ly Thai To Street, Ward 09, District 10',
                    '26/04/2024 | 17:40',
                    'Cancelled',
                  ),
                  _buildOrderItem(
                    'Interstate Shipping',
                    'Da Nang City, Vietnam',
                    'Ca Mau City, Tan Thanh Ward',
                    '26/04/2024 | 08:00',
                    'Completed',
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildOrderSection(String title, List<Widget> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...orders,
      ],
    );
  }

  Widget _buildOrderItem(
    String type,
    String fromAddress,
    String toAddress,
    String dateTime,
    String status,
  ) {
    Color statusColor;
    switch (status) {
      case 'In Progress':
        statusColor = Colors.orange;
        break;
      case 'Completed':
        statusColor = Colors.green;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined),
                const SizedBox(width: 8),
                Text(
                  dateTime,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(type),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.circle_outlined, size: 12),
                const SizedBox(width: 8),
                Expanded(child: Text(fromAddress)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 12),
                const SizedBox(width: 8),
                Expanded(child: Text(toAddress)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
