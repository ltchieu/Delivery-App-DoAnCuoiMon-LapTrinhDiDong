import 'package:do_an_cuoi_mon/view/order_details.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryInfoScreen extends StatefulWidget {
  final String diaChiNguoiGui;
  final String tenNguoiGui;
  final String SDTNguoiGui;
  final LatLng? toaDoNguoiNhan;
  final bool isDiaChiNhanHangSelected;
  const DeliveryInfoScreen({
    Key? key,
    required this.toaDoNguoiNhan,
    required this.isDiaChiNhanHangSelected,
    required this.tenNguoiGui,
    required this.SDTNguoiGui,
    required this.diaChiNguoiGui,
  }) : super(key: key);

  @override
  State<DeliveryInfoScreen> createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late GoogleMapController mapController;
  String streetAddress = "";
  String districtAddress = "";
  String diaChiNguoiNhan = "";

  bool _isRecipient = true;

  @override
  void initState() {
    super.initState();
    getAddressFromLatLng(widget.toaDoNguoiNhan);
  }

  // @override
  // void dispose() {
  //   _recipientNameController.dispose();
  //   _phoneController.dispose();
  //   super.dispose();
  // }

  void _moveCameraWithOffset() {
    final LatLng center = widget.toaDoNguoiNhan!;
    final LatLng adjustedCenter = LatLng(
      center.latitude - 0.00067,
      center.longitude,
    );

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(adjustedCenter, 19.0),
    );
  }

  void getAddressFromLatLng(LatLng? location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location!.latitude,
      location.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        streetAddress = place.street!;
        districtAddress =
            '${place.subLocality} ${place.locality} ${place.subAdministrativeArea} ${place.administrativeArea}';
        diaChiNguoiNhan = streetAddress + districtAddress;
      });
      print('Địa chỉ: $diaChiNguoiNhan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    _moveCameraWithOffset();
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.toaDoNguoiNhan!.latitude,
                      widget.toaDoNguoiNhan!.longitude,
                    ),
                    zoom: 17.0,
                  ),
                  zoomControlsEnabled: true,
                  markers: {
                    Marker(
                      markerId: MarkerId("diaChiLayHang"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(
                        widget.toaDoNguoiNhan!.latitude,
                        widget.toaDoNguoiNhan!.longitude,
                      ),
                    ),
                  },
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                ),

                // Google logo
                const Positioned(
                  bottom: 450,
                  left: 16,
                  child: Text(
                    'Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'PTSans',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
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

          // Draggable bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Delivery section
                            const Text(
                              'Giao đến',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'PTSans',
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Address container
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
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
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          streetAddress.isNotEmpty
                                              ? streetAddress
                                              : "Lỗi khi lấy địa chỉ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily: 'PTSans',
                                          ),
                                        ),
                                        SizedBox(height: 4),

                                        Text(
                                          districtAddress.isNotEmpty
                                              ? districtAddress
                                              : 'Lỗi khi lấy địa chỉ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'PTSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Add address note
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.note_add_outlined,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Thêm ghi chú địa chỉ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontFamily: 'PTSans',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Recipient information
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.isDiaChiNhanHangSelected
                                      ? 'Thông tin người gửi'
                                      : 'Thông tin người nhận',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'PTSans',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isRecipient = !_isRecipient;
                                    });
                                  },
                                  child: Text(
                                    widget.isDiaChiNhanHangSelected
                                        ? 'Tôi là người gửi'
                                        : 'Tôi là người nhận',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      fontFamily: 'PTSans',
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Recipient name field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: TextField(
                                controller: _recipientNameController,
                                style: const TextStyle(
                                  fontFamily: 'PTSans',
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      widget.isDiaChiNhanHangSelected
                                          ? 'Tên người gửi'
                                          : 'Tên người nhận',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'PTSans',
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  suffixIcon: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Phone number field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  fontFamily: 'PTSans',
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Số điện thoại',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'PTSans',
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 200), // Space for button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // confirm button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    widget.isDiaChiNhanHangSelected
                        ? Navigator.pop(context, {
                          "sdt": _phoneController.text,
                          "tenNguoiGui": _recipientNameController.text,
                          "diaChi": streetAddress,
                        })
                        : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => OrderDetails(
                                  tenNguoiGui: widget.tenNguoiGui,
                                  SDTNguoiGui: widget.SDTNguoiGui,
                                  diaChiNguoiGui: widget.diaChiNguoiGui,
                                  diaChiNguoiNhan: diaChiNguoiNhan,
                                  tenNguoiNhan: _recipientNameController.text,
                                  SDTNguoiNhan: _phoneController.text,
                                ),
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'PTSans',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
