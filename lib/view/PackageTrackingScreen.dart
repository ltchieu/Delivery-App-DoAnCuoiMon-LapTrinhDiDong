import 'package:flutter/material.dart';
import 'package:do_an_cuoi_mon/model/orde_response_dto.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PackageTrackingScreen extends StatefulWidget {
  final OrderResponseDto order;
  const PackageTrackingScreen({super.key, required this.order});

  @override
  State<PackageTrackingScreen> createState() => _PackageTrackingScreenState();
}

class _PackageTrackingScreenState extends State<PackageTrackingScreen> {
  late GoogleMapController _mapController;

  final List<Map<String, dynamic>> _statusSteps = [
    {
      "label": "Order Placed",
      "status": "Your order has been placed.",
      "completed": true,
    },
    {
      "label": "Dispatched",
      "status": "Order is on the way.",
      "completed": true,
    },
    {
      "label": "Out for Delivery",
      "status": "Driver is delivering.",
      "completed": false,
    },
    {"label": "Delivered", "status": "Package delivered.", "completed": false},
  ];

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (controller) => _mapController = controller,
                initialCameraPosition: CameraPosition(target: source, zoom: 13),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(_statusSteps.length, (index) {
                      final step = _statusSteps[index];
                      final isLast = index == _statusSteps.length - 1;
                      return _buildTimelineItem(
                        label: step['label'],
                        status: step['status'],
                        isCompleted: step['completed'],
                        isLast: isLast,
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String label,
    required String status,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.orange : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child:
                  isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
