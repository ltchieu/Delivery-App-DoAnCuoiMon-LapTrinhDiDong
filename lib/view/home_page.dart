import 'package:carousel_slider/carousel_slider.dart';
import 'package:do_an_cuoi_mon/main.dart';
import 'package:do_an_cuoi_mon/view/CustomBottomNavBar.dart';
import 'package:do_an_cuoi_mon/view/Notification.dart';
import 'package:do_an_cuoi_mon/view/PackageTrackingScreen.dart';
import 'package:do_an_cuoi_mon/view/location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomnePageState();
}

class _HomnePageState extends State<HomePage> {
  TextEditingController txt_diaChiNhanHang = TextEditingController();
  int _selectedIndex = 0;
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
      return "Chào buổi sáng!";
    } else if (time.hour <= 13) {
      return "Chào buổi trưa!";
    } else if (time.hour <= 18) {
      return "Chào buổi chiều!";
    } else {
      return "Chào buổi tối!";
    }
  }

  @override
  Widget build(BuildContext context) {
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
              layTitleAppBarTheoBuoi(),
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
                        padding: EdgeInsets.only(left: 10, right: 15),
                        child: Icon(FontAwesomeIcons.locationDot),
                      ),
                      Expanded(
                        child: TextField(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const LocationPickerScreen(),
                              ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const LocationPickerScreen(),
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
                        radius: 35,
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
            TextButton(
              onPressed: () {
                MyApp.navigatorKey.currentState!.pushNamed('CTDonHang');
              },
              child: Text("Chuyển đến trang chi tiết đơn hàng"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }
}
