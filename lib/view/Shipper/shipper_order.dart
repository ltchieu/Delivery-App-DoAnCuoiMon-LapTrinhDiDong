import 'package:do_an_cuoi_mon/model/orde_response_dto.dart';
import 'package:do_an_cuoi_mon/model/user_dto.dart';
import 'package:do_an_cuoi_mon/service/map_service.dart';
import 'package:do_an_cuoi_mon/service/order_service.dart';
import 'package:do_an_cuoi_mon/view/Shipper/shipper_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShipperOrder extends StatefulWidget {
  const ShipperOrder({super.key});

  @override
  State<ShipperOrder> createState() => _ShipperOrderState();
}

class _ShipperOrderState extends State<ShipperOrder> {
  bool isLoading = false;
  UserDto user = UserDto();
  List<OrderResponseDto> orders = [];
  final MapService _mapService = MapService();
  Map<int, String> fromAddresses = {};
  Map<int, String> toAddresses = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfo().then((_) {
      _fetchOrders().then((_) {
        _loadOrderAddresses();
      });
    });
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user.userId = prefs.getString('userId');
      user.userName = prefs.getString('userName');
      user.role = prefs.getString('role');
      isLoading = false;
    });
  }

  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<OrderResponseDto> fetchedOrders = [];
      fetchedOrders = await OrderService.getOrderByShipperId(user.userId!);

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
    for (int i = 0; i < orders.length; i++) {
      final fromLatLng = LatLng(
        orders[i].sourceLocation!.latitude!,
        orders[i].sourceLocation!.longitude!,
      );

      final toLatLng = LatLng(
        orders[i].destinationLocation!.latitude!,
        orders[i].destinationLocation!.longitude!,
      );

      String fromAddress = await _mapService.getFullAddressFromLatLng(
        fromLatLng,
      );
      String toAddress = await _mapService.getFullAddressFromLatLng(toLatLng);

      fromAddresses[i] = fromAddress;
      toAddresses[i] = toAddress;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 252, 75, 21),
                  const Color.fromARGB(255, 255, 145, 111),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.9],
              ),
            ),
            child: AppBar(
              title: Text(
                'Chúc ${user.userName!.split(' ').last}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.arrowLeft),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _fetchOrders();
                  },
                  icon: Icon(FontAwesomeIcons.rotateLeft, color: Colors.white),
                  tooltip: "Reload",
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Không có đơn hàng nào',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 252, 75, 21),
                const Color.fromARGB(255, 255, 145, 111),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.9],
            ),
          ),
          child: AppBar(
            title: Text(
              'Chào ${user.userName!.split(' ').last}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                _fetchOrders();
              },
              icon: Icon(FontAwesomeIcons.rotateLeft, color: Colors.white),
              tooltip: "Reload",
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/Welcome');
                },
                icon: Icon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                ),

                tooltip: "Logout",
              ),
            ],
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(order: orders[index]),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 7.5,
              ),
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
                          orders[index].createdAt.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          orders[index].orderStatus.toString(),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 53, 185, 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
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
                                fromAddresses[index]!.substring(
                                  0,
                                  fromAddresses[index]!.indexOf(','),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                fromAddresses[index]!.substring(
                                  fromAddresses[index]!.indexOf(',') + 2,
                                ),
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    131,
                                    131,
                                    131,
                                  ),
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
                                toAddresses[index]!.substring(
                                  0,
                                  toAddresses[index]!.indexOf(','),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                toAddresses[index]!.substring(
                                  toAddresses[index]!.indexOf(',') + 2,
                                ),
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    131,
                                    131,
                                    131,
                                  ),
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
        },
      ),
    );
  }
}
