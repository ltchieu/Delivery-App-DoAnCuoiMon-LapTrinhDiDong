import 'package:do_an_cuoi_mon/model/location_dto.dart';
import 'package:do_an_cuoi_mon/service/map_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as per;

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _addressController = TextEditingController();
  final FocusNode _addressFocusNode = FocusNode();
  final MapService _mapService = MapService();
  LatLng? currentLocation = null;

  @override
  void dispose() {
    _addressController.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Điểm giao hàng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'PTSans',
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Handle paste functionality
              _addressFocusNode.requestFocus();
            },
            child: const Text(
              'Paste',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'PTSans',
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Address input section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TypeAheadField<String>(
                      suggestionsCallback: (pattern) async {
                        final suggestions = await _mapService.getSuggestions(
                          pattern,
                        );
                        return suggestions;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(title: Text(suggestion));
                      },

                      onSelected: (suggestion) async {
                        _addressController.text = suggestion;

                        final placeId =
                            _mapService.descriptionToPlaceIdMap[suggestion];
                        if (placeId != null) {
                          final LatLng? location = await _mapService
                              .getCoordinatesFromPlaceId(placeId);
                          if (location != null) {
                            setState(() {
                              currentLocation = location;
                            });
                          }
                        }
                      },

                      builder: (context, controller, focusNode) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          style: const TextStyle(
                            fontFamily: 'PTSans',
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Số nhà, đường, phường, quận',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'PTSans',
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Current location section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.navigation,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lấy vị trí hiện tại',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: 'PTSans',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Phường 15, Tân Bình, Hồ Chí Minh, Việt Nam',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'PTSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Saved addresses section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Địa điểm đã lưu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'PTSans',
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Xem tất cả',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PTSans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Add new address
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thêm mới',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: 'PTSans',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lưu địa điểm thân quen của bạn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'PTSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Frequently used section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Thường được sử dụng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'PTSans',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Frequently used addresses list
                    Container(
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.access_time,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '6/19/1 Đ. Trần Thị Trong',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily: 'PTSans',
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Phường 15, Tân Bình, Hồ Chí Minh',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: 'PTSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 100), // Extra space for keyboard
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Fixed bottom button
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Chọn từ bản đồ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PTSans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedAddress = '106/14 Cống Lở';
  late GoogleMapController mapController;
  Set<Marker> _maker = {};
  LatLng? _currentLocation = null;

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
  }

  // void _onMarkerDragEnd(LatLng newPosition) {
  //   setState(() {
  //     _currentLocation = newPosition;
  //   });
  //   print("Marker dragged to: $_currentLocation");
  // }

  void _onMapTapped(LatLng tappedPosition) {
    setState(() {
      _currentLocation = tappedPosition;
      _maker.clear();
      _maker.add(
        Marker(
          markerId: MarkerId("newCurrentLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(tappedPosition.latitude, tappedPosition.longitude),
        ),
      );
    });
    print("Map tapped at: $_currentLocation");
  }

  Future<void> requestLocationPermission(per.Permission permission) async {
    if (await permission.isDenied) {
      await permission.request();
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error("Location services are disable");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location denied permanently");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.7769, 106.7009), // Tọa độ TP.HCM
              zoom: 13.0,
            ),
            zoomControlsEnabled: true,
            markers: _maker,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            onTap: _onMapTapped,
          ),

          // Current location button
          Positioned(
            bottom: 170,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  Position position = await getCurrentLocation();
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 15.0,
                      ),
                    ),
                  );
                  setState(() {
                    _maker.clear();
                    _maker.add(
                      Marker(
                        markerId: MarkerId("currentLocation"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueCyan,
                        ),
                        position: LatLng(position.latitude, position.longitude),
                      ),
                    );
                  });
                },
                icon: const Icon(
                  Icons.my_location,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // Location suggestions at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Confirm button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, selectedAddress);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'PTSans',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MapPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = Colors.grey[300]!
//           ..strokeWidth = 1;

//     // Draw grid lines to simulate map
//     for (int i = 0; i < size.width; i += 50) {
//       canvas.drawLine(
//         Offset(i.toDouble(), 0),
//         Offset(i.toDouble(), size.height),
//         paint,
//       );
//     }

//     for (int i = 0; i < size.height; i += 50) {
//       canvas.drawLine(
//         Offset(0, i.toDouble()),
//         Offset(size.width, i.toDouble()),
//         paint,
//       );
//     }

//     // Draw some street-like lines
//     final streetPaint =
//         Paint()
//           ..color = Colors.grey[400]!
//           ..strokeWidth = 3;

//     canvas.drawLine(
//       Offset(0, size.height * 0.3),
//       Offset(size.width, size.height * 0.3),
//       streetPaint,
//     );

//     canvas.drawLine(
//       Offset(size.width * 0.4, 0),
//       Offset(size.width * 0.4, size.height),
//       streetPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
