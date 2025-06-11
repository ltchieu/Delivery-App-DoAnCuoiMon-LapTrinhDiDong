import 'package:carousel_slider/carousel_slider.dart';
import 'package:do_an_cuoi_mon/main.dart';
import 'package:do_an_cuoi_mon/model/location_dto.dart';
import 'package:do_an_cuoi_mon/model/user_dto.dart';
import 'package:do_an_cuoi_mon/service/map_service.dart';
import 'package:do_an_cuoi_mon/service/user_service.dart';
import 'package:do_an_cuoi_mon/view/CustomBottomNavBar.dart';
import 'package:do_an_cuoi_mon/view/location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomnePageState();
}

class _HomnePageState extends State<HomePage> {
  TextEditingController txt_diaChiNhanHang = TextEditingController();
  bool isDiaChiNhanHangSelected = false;
  String diaChiNhanHang = "";
  String tenNguoiGui = "";
  String sdtNguoiGui = "";
  LatLng toaDoNguoiGui = LatLng(0, 0);
  UserDto user = UserDto();
  bool isLoading = false;
  LocationDto userLocation = LocationDto();
  final _mapService = MapService();

  List<Map<String, String>> myList = [
    {'image': 'lib/images/logo_giaohang.png', 'title': 'Giao hàng'},
    {'image': 'lib/images/datdoan.png', 'title': 'Đặt món ăn'},
    {'image': 'lib/images/xetai.png', 'title': 'Xe tải'},
    {'image': 'lib/images/lientinh.png', 'title': 'Liên tỉnh'},
    {'image': 'lib/images/aidatdon.jpg', 'title': 'AI Đặt đơn'},
    {'image': 'lib/images/hoivien.png', 'title': 'Gói Hội Viên'},
  ];

  List<String> bannerList = [
    'lib/images/banner1.png',
    'lib/images/banner2.png',
    'lib/images/banner3.png',
    'lib/images/banner4.png',
  ];

  String layTitleAppBarTheoBuoi() {
    DateTime time = DateTime.now();
    if (time.hour <= 10) {
      return "Chào buổi sáng";
    } else if (time.hour <= 13) {
      return "Chào buổi trưa";
    } else if (time.hour <= 18) {
      return "Chào buổi chiều";
    } else {
      return "Chào buổi tối";
    }
  }

  void _chonDiaChiLayHang(bool isDcNhanHangSelected) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LocationPickerScreen(
              toaDoNguoiGui: toaDoNguoiGui,
              tenNguoiGui: tenNguoiGui,
              SDTNguoiGui: sdtNguoiGui,
              diaChiNguoiGui: diaChiNhanHang,
              isDiaChiNhanHangSelected: isDcNhanHangSelected,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        diaChiNhanHang = result['diaChi'];
        tenNguoiGui = result['tenNguoiGui'];
        sdtNguoiGui = result['sdt'];
        toaDoNguoiGui = result['toaDoNguoiGui'];
        _updateUserLocation(toaDoNguoiGui);
      });
    }
  }

  Future<void> _updateUserLocation(LatLng toaDoNguoiGui) async {
    setState(() {
      isLoading = true;
    });
    try {
      LocationDto location = LocationDto(
        latitude: toaDoNguoiGui.latitude,
        longitude: toaDoNguoiGui.longitude,
      );
      await UserService.saveOrUpdateUserLocation(
        user.userId!,
        location,
      ); //update location trong DB
      setState(() {
        //update lại userLocation
        userLocation.latitude = toaDoNguoiGui.latitude;
        userLocation.longitude = toaDoNguoiGui.longitude;
        Fluttertoast.showToast(
          msg: 'Cập nhật địa điểm thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Lỗi update user location $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _getUserLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      final location = await UserService.getUserLocation(user.userId!);
      setState(() {
        userLocation = location;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user location: $e')),
      );
    }
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

  Future<void> _setDiaChiNhanHang() async {
    setState(() {
      isLoading = true;
    });
    if (isDiaChiNhanHangSelected == false &&
        userLocation.latitude != null &&
        userLocation.longitude != null) {
      LatLng? l = LatLng(userLocation.latitude!, userLocation.longitude!);
      String address = await _mapService.getAddressFromLatLng(l);
      setState(() {
        diaChiNhanHang = address;
        isLoading = false;
      });
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo()
        .then((_) {
          _getUserLocation().then((_) {
            _setDiaChiNhanHang();
          });
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi load user info: $error')),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
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
              '${layTitleAppBarTheoBuoi()} ${user.userName!.split(' ').last}!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  MyApp.navigatorKey.currentState!.pushNamed('Notification');
                },
                icon: Icon(FontAwesomeIcons.solidBell, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Container(
              width: 350,
              height: 160,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 253, 249, 249),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Icon(FontAwesomeIcons.locationDot),
                      ),
                      Expanded(
                        child:
                            diaChiNhanHang.isNotEmpty ||
                                    (userLocation.latitude != null &&
                                        userLocation.longitude != null)
                                ? TextButton(
                                  style: TextButton.styleFrom(
                                    alignment: Alignment.centerLeft,
                                  ),
                                  onPressed: () {
                                    isDiaChiNhanHangSelected = true;
                                    _chonDiaChiLayHang(
                                      isDiaChiNhanHangSelected,
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        diaChiNhanHang,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'PT Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      if (tenNguoiGui.isNotEmpty)
                                        SizedBox(height: 7),
                                      if (tenNguoiGui.isNotEmpty)
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: tenNguoiGui,
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    100,
                                                    100,
                                                    100,
                                                  ),
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                ),
                                              ),

                                              if (sdtNguoiGui.isNotEmpty)
                                                TextSpan(
                                                  text: ' | ' + sdtNguoiGui,
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      100,
                                                      100,
                                                      100,
                                                    ),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                                : TextField(
                                  decoration: InputDecoration(
                                    hintText: "Bạn muốn lấy hàng ở đâu?",
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () {
                                    isDiaChiNhanHangSelected = true;
                                    _chonDiaChiLayHang(
                                      isDiaChiNhanHangSelected,
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 15),
                        child: Icon(FontAwesomeIcons.locationCrosshairs),
                      ),
                      Expanded(
                        child: TextField(
                          controller: txt_diaChiNhanHang,
                          decoration: InputDecoration(
                            hintText: "Bạn muốn giao hàng đến đâu?",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          onTap: () {
                            isDiaChiNhanHangSelected = false;
                            if (toaDoNguoiGui == LatLng(0, 0) &&
                                (userLocation.latitude == null &&
                                    userLocation.longitude == null)) {
                              Fluttertoast.showToast(
                                msg: 'Bạn cần chọn địa chỉ lấy hàng trước',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return;
                            }
                            if (toaDoNguoiGui == LatLng(0, 0) &&
                                (userLocation.latitude != null &&
                                    userLocation.longitude != null)) {
                              setState(() {
                                toaDoNguoiGui = LatLng(
                                  userLocation.latitude!,
                                  userLocation.longitude!,
                                );
                              });
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LocationPickerScreen(
                                      toaDoNguoiGui: toaDoNguoiGui,
                                      tenNguoiGui: tenNguoiGui,
                                      SDTNguoiGui: sdtNguoiGui,
                                      diaChiNguoiGui: diaChiNhanHang,
                                      isDiaChiNhanHangSelected:
                                          isDiaChiNhanHangSelected,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: myList.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(myList[index]["image"]!),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Text(myList[index]['title']!),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            CarouselSlider.builder(
              options: CarouselOptions(
                autoPlay: false,
                height: 180,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              itemCount: bannerList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    bannerList[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        userId: user.userId!,
      ),
    );
  }
}
