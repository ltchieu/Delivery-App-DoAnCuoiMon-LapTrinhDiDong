import 'package:do_an_cuoi_mon/model/orde_response_dto.dart';
import 'package:do_an_cuoi_mon/service/order_service.dart';
import 'package:do_an_cuoi_mon/view/CustomBottomNavBar.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedStatus = 'All';
  List<OrderResponseDto> orders = [];
  bool isLoading = true;

  // Add list of available statuses
  final List<String> statuses = [
    'All',
    'Đang chờ',
    'Đang giao',
    'Đã hoàn tất',
    'Đã huỷ',
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Phương thức tải dữ liệu từ API
  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<String> orderIds = ['O9af396c4', 'Oc6a1b22a'];
      List<OrderResponseDto> fetchedOrders = [];
      for (var orderId in orderIds) {
        final order = await OrderService.getOrder(orderId);
        fetchedOrders.add(order);
      }
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching orders: $e')));
    }
  }

  // Lọc đơn hàng dựa trên selectedStatus
  List<OrderResponseDto> getFilteredOrders() {
    if (selectedStatus == 'All') {
      return orders;
    }
    return orders.where((order) {
      return order.orderStatus == selectedStatus;
    }).toList();
  }

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
          // Filter Section with Horizontal Tabs
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
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                      children: _buildOrderSections(getFilteredOrders()),
                    ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  // Tạo các section dựa trên ngày tạo đơn hàng
  List<Widget> _buildOrderSections(List<OrderResponseDto> filteredOrders) {
    Map<String, List<Widget>> sections = {};

    for (var order in filteredOrders) {
      String date =
          order.createdAt?.toLocal().toString().split(' ')[0] ?? 'Unknown';
      String month = date.split('-')[1];
      String sectionTitle =
          month == DateTime.now().toLocal().toString().split('-')[1]
              ? 'Today'
              : month;

      if (!sections.containsKey(sectionTitle)) {
        sections[sectionTitle] = [];
      }
      sections[sectionTitle]!.add(
        _buildOrderItem(
          order.vehicleType ?? 'Unknown',
          order.sourceLocation?.latitude.toString() ??
              '' + ', ' + (order.sourceLocation?.longitude.toString() ?? ''),
          order.destinationLocation?.latitude.toString() ??
              '' +
                  ', ' +
                  (order.destinationLocation?.longitude.toString() ?? ''),
          order.createdAt?.toLocal().toString() ?? 'Unknown',
          order.orderStatus ?? 'Unknown',
        ),
      );
    }

    return sections.entries.map((entry) {
      return _buildOrderSection(entry.key, entry.value);
    }).toList();
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
