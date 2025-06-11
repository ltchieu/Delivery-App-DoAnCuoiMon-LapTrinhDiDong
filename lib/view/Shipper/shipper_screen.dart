import 'dart:async';
import 'dart:convert';

import 'package:do_an_cuoi_mon/consts.dart';
import 'package:do_an_cuoi_mon/model/orde_response_dto.dart';
import 'package:do_an_cuoi_mon/model/user_dto.dart';
import 'package:do_an_cuoi_mon/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class OrderDetailScreen extends StatefulWidget {
  final OrderResponseDto order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  LatLng? _currentPosition;
  Timer? _positionTimer;
  String _currentStatus = '';
  String tenNguoiGui = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.orderStatus.toString();
    _loadCurrentLocation();
    _setupMarkers();
    _getRouteFromGoogleMaps();
    _startLocationPolling();
    _setTenNguoiGui();
    setState(() {
      _currentStatus = widget.order.orderStatus.toString();
    });
  }

  Future<void> _setTenNguoiGui() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserDto u = await UserService.getUserInfor(widget.order.customerId!);
      setState(() {
        tenNguoiGui = u.userName!;
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Lỗi khi lấy tên người gửi: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

  void _setupMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          widget.order.sourceLocation!.latitude!,
          widget.order.sourceLocation!.longitude!,
        ),
        infoWindow: const InfoWindow(title: 'Điểm lấy hàng'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(
          widget.order.destinationLocation!.latitude!,
          widget.order.destinationLocation!.longitude!,
        ),
        infoWindow: const InfoWindow(title: 'Điểm giao hàng'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };
  }

  void _loadCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('shipper'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    });
  }

  void _startLocationPolling() {
    _positionTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _loadCurrentLocation();
    });
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    super.dispose();
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _currentStatus = newStatus;
    });
    // Gửi cập nhật tới backend ở đây nếu có API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.order.sourceLocation!.latitude!,
                  widget.order.sourceLocation!.longitude!,
                ),
                zoom: 14,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 248, 241),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Người gửi:', tenNguoiGui),
                  _infoRow('Người nhận:', widget.order.tenNguoiNhan.toString()),
                  const SizedBox(height: 12),
                  Text(
                    'Trạng thái: $_currentStatus',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cập nhật trạng thái:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _statusButton('Đã lấy hàng'),
                      _statusButton('Đang giao'),
                      _statusButton('Hoàn tất'),
                      _statusButton('Huỷ đơn'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _statusButton(String label) {
    return ElevatedButton(
      onPressed: () => _updateStatus(label),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
