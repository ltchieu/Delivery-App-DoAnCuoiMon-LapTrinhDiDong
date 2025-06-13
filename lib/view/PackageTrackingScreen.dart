import 'dart:async';
import 'dart:convert';

import 'package:do_an_cuoi_mon/consts.dart';
import 'package:do_an_cuoi_mon/service/assign_service.dart';
import 'package:do_an_cuoi_mon/service/map_service.dart';
import 'package:do_an_cuoi_mon/service/order_service.dart';
import 'package:do_an_cuoi_mon/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:do_an_cuoi_mon/model/orde_response_dto.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PackageTrackingScreen extends StatefulWidget {
  final OrderResponseDto order;
  const PackageTrackingScreen({super.key, required this.order});

  @override
  State<PackageTrackingScreen> createState() => _PackageTrackingScreenState();
}

class _PackageTrackingScreenState extends State<PackageTrackingScreen> {
  late GoogleMapController _mapController;
  final PolylinePoints _polylinePoints = PolylinePoints();
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  String _currentStatus = '';
  Timer? _positionTimer;
  bool isLoading = false;
  String deliveryPersonName = '';
  String khoangCach = '';
  String thoiGianVanChuyen = '';
  MapService _mapService = MapService();

  String formatDurationText(int durationMinutes) {
    if (durationMinutes < 60) {
      return "${durationMinutes} phút";
    } else {
      int hours = durationMinutes ~/ 60;
      int minutes = durationMinutes % 60;
      return minutes > 0 ? "${hours}h${minutes}'" : "${hours}h";
    }
  }

  Future<void> _getRouteFromGoogleMaps() async {
    final startLat = widget.order.sourceLocation!.latitude!;
    final startLng = widget.order.sourceLocation!.longitude!;
    final endLat = widget.order.destinationLocation!.latitude!;
    final endLng = widget.order.destinationLocation!.longitude!;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$GOOGLE_MAPS_API_KEY',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      List<PointLatLng> result = _polylinePoints.decodePolyline(points);

      polylineCoordinates.clear();
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      _addPolyline();
    } else {
      throw Exception('Lỗi khi gọi Directions API');
    }
  }

  void _addPolyline() {
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: polylineCoordinates,
    );
    setState(() {
      _polylines.add(polyline);
    });
  }

  void _startLocationPolling() {
    _positionTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _getStatus();
    });
  }

  void _getStatus() async {
    setState(() {
      isLoading = true;
    });
    try {
      OrderResponseDto o = await OrderService.getOrderByOrderId(
        widget.order.orderID!,
      );
      setState(() {
        _currentStatus = o.orderStatus.toString();
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Có lỗi khi gọi API $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _assignOrder(String orderId) async {
    final result = await AssignService.assignOrderToNearestShipper(orderId);
    if (result != null) {
      if (result.success) {
        setState(() {
          widget.order.deliveryPersonId = result.deliveryPersonId;
        });
        _getDeliveryPersonInfor();
      } else {
        Fluttertoast.showToast(
          msg: 'Không tìm thấy người giao hàng: ${result.message}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      print('Failed to connect to server.');
    }
  }

  void _getDeliveryPersonInfor() async {
    if (widget.order.deliveryPersonId!.isEmpty) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Đơn hàng chưa có shipper nào nhận đơn',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    final result = await UserService.getUserInfor(
      widget.order.deliveryPersonId!,
    );
    setState(() {
      deliveryPersonName = result.userName!;
    });
    Fluttertoast.showToast(
      msg: 'Người giao hàng: $deliveryPersonName đã nhận đơn hàng',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _getKhoangCachVaThoiGianVanChuyen() async {
    final result = await _mapService.getDistanceAndTimeInKmAndMinutes(
      originLat: widget.order.sourceLocation!.latitude!,
      originLng: widget.order.sourceLocation!.longitude!,
      destLat: widget.order.destinationLocation!.latitude!,
      destLng: widget.order.destinationLocation!.longitude!,
    );

    if (result != null) {
      setState(() {
        khoangCach = result['distanceKm'].toString();
        thoiGianVanChuyen = formatDurationText(result['durationMinutes']);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Không lấy được dữ liệu khoảng cách và thời gian',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getRouteFromGoogleMaps();
    _currentStatus = widget.order.orderStatus.toString();
    _assignOrder(widget.order.orderID!);
    _getKhoangCachVaThoiGianVanChuyen();
    _startLocationPolling();
  }

  @override
  void dispose() {
    _positionTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng source = LatLng(
      widget.order.sourceLocation?.latitude ?? 0,
      widget.order.sourceLocation?.longitude ?? 0,
    );
    final LatLng destination = LatLng(
      widget.order.destinationLocation?.latitude ?? 0,
      widget.order.destinationLocation?.longitude ?? 0,
    );
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Tracking ${widget.order.orderID}",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(target: source, zoom: 13),
              polylines: _polylines,
              markers: {
                Marker(
                  markerId: const MarkerId('source'),
                  position: source,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange,
                  ),
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: destination,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan,
                  ),
                ),
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  color: const Color.fromARGB(164, 236, 235, 235),
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: Column(
                    children: [
                      SizedBox(height: 15),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              FontAwesomeIcons.boxOpen,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Trạng thái đơn hàng:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              widget.order.orderStatus!,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: Color.fromARGB(255, 218, 217, 217),
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              FontAwesomeIcons.truck,
                              color: Colors.orangeAccent,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Người giao hàng:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              deliveryPersonName.isEmpty
                                  ? "Chưa xác định được shipper"
                                  : deliveryPersonName,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  color: const Color.fromARGB(164, 236, 235, 235),
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              FontAwesomeIcons.route,
                              color: Colors.lightBlueAccent,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Khoảng cách di chuyển:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT San',
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              khoangCach.isEmpty
                                  ? 'Đang tính toán...'
                                  : '$khoangCach km',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT San',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: Color.fromARGB(255, 218, 217, 217),
                      ),
                      SizedBox(height: 15),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              FontAwesomeIcons.clock,
                              color: Colors.lightBlueAccent,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Thời gian vận chuyển:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT San',
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              thoiGianVanChuyen.isEmpty
                                  ? "Đang tính toán..."
                                  : thoiGianVanChuyen,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT San',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
