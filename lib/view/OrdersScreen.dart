import 'package:do_an_cuoi_mon/model/orde_response_dto.dart';
import 'package:do_an_cuoi_mon/service/map_service.dart';
import 'package:do_an_cuoi_mon/service/order_service.dart';
import 'package:do_an_cuoi_mon/view/CustomBottomNavBar.dart';
import 'package:do_an_cuoi_mon/view/PackageTrackingScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  final String userId;
  const OrdersScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedStatus = 'All';
  List<OrderResponseDto> orders = [];
  bool isLoading = true;
  final _mapService = MapService();
  Map<String, String> fromAddresses = {};
  Map<String, String> toAddresses = {};

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
    _fetchOrders().then((_) {
      _loadOrderAddresses();
    });
  }

  // Phương thức tải dữ liệu từ API
  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OrderResponseDto> fetchedOrders = [];
      fetchedOrders = await OrderService.getOrder(widget.userId);

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

  Future<void> _loadOrderAddresses() async {
    setState(() {
      isLoading = true;
    });
    for (var order in orders) {
      final fromLatLng = LatLng(
        order.sourceLocation!.latitude!,
        order.sourceLocation!.longitude!,
      );

      final toLatLng = LatLng(
        order.destinationLocation!.latitude!,
        order.destinationLocation!.longitude!,
      );

      String fromAddress = await _mapService.getFullAddressFromLatLng(
        fromLatLng,
      );
      String toAddress = await _mapService.getFullAddressFromLatLng(toLatLng);

      fromAddresses[order.orderID!] = fromAddress;
      toAddresses[order.orderID!] = toAddress;
    }

    setState(() {
      isLoading = false;
    });
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Không có đơn hàng nào',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        userId: widget.userId,
      ),
    );
  }

  // Tạo các section dựa trên ngày tạo đơn hàng
  List<Widget> _buildOrderSections(List<OrderResponseDto> filteredOrders) {
    filteredOrders.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime); // sắp xếp giảm dần
    });
    Map<String, List<Widget>> sections = {};
    for (var order in filteredOrders) {
      final DateTime? createdAt = order.createdAt?.toLocal();

      String dateTimeFormatted =
          createdAt != null
              ? DateFormat('yyyy-MM-dd | HH:mm').format(createdAt)
              : 'Unknown';

      String month =
          createdAt != null ? DateFormat('MM').format(createdAt) : 'Unknown';

      String currentMonth = DateFormat('MM').format(DateTime.now());

      String sectionTitle = (month == currentMonth) ? 'Today' : month;

      if (!sections.containsKey(sectionTitle)) {
        sections[sectionTitle] = [];
      }
      sections[sectionTitle]!.add(
        _buildOrderItem(
          order,
          order.vehicleType ?? 'Unknown',
          fromAddresses[order.orderID] ?? "Loading...",
          toAddresses[order.orderID] ?? "Loading...",
          dateTimeFormatted,
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
    OrderResponseDto order,
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

    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageTrackingScreen(order: order),
          ),
        );
      },
      elevation: 0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.5),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text(type),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle_outlined,
                    size: 20,
                    color: Colors.deepOrangeAccent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fromAddress.substring(0, fromAddress.indexOf(',')),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          fromAddress.substring(fromAddress.indexOf(',') + 2),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 131, 131, 131),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.deepOrangeAccent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          toAddress.substring(0, toAddress.indexOf(',')),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          toAddress.substring(toAddress.indexOf(',') + 2),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 131, 131, 131),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
