import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => OrderDetailsState();
}

class OrderDetailsState extends State<OrderDetails> {
  TextEditingController txt_khoiLuong = TextEditingController();
  TextEditingController txt_ghiChuTaiXe = TextEditingController();

  static final TextStyle _textStyleCTHangHoa = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12,
    fontFamily: 'PT Sans',
  );
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL', '3XL'];
  final List<String> loaiHang = [
    'Thời trang',
    'Mỹ phẩm',
    'Thực phẩm khô / đóng gói',
    'Khác',
  ];

  final List<String> lst_yeuCauDacBiet = [
    'Túi giữ nhiệt',
    'Giao hàng dễ vỡ',
    'Gửi SMS cho người nhận',
    'Quay lại điểm lấy hàng',
    'Giao hàng tận tay',
  ];

  int _khoangCach = 10;
  String _diaChiNhanHang =
      'Địa chỉ từ CSDL'; // địa chỉ nhận hàng lấy từ cơ sở dữ liệu

  String _diaChiGiaoHang = 'Địa chỉ giao hàng';
  String _tenNguoiNhan = 'Tên người nhận';
  String _sdtNguoiNhan = '0963552971';

  bool _isExpand = false;
  int _selectedIndex = 0;
  late HashMap<int, bool> _lstSelectedHangHoa = HashMap();
  late String ngayLayHang;
  final formatter = DateFormat('HH:mm');
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String formatVietnameseDate(DateTime date) {
    const weekdays = [
      'Chủ nhật',
      'Thứ hai',
      'Thứ ba',
      'Thứ tư',
      'Thứ năm',
      'Thứ sáu',
      'Thứ bảy',
    ];
    final weekday = weekdays[date.weekday % 7];
    return '$weekday, ${date.day}/${date.month}';
  }

  String truncateText(String text) {
    if (text.length > 15) {
      return text.substring(0, 15);
    }
    return text;
  }

  void _showGhiChuTaiXe() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(FontAwesomeIcons.xmark),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 80),
                        child: Text(
                          'Ghi chú cho tài xế',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PT Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      height: 150,
                      child: TextField(
                        controller: txt_ghiChuTaiXe,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: 'Nhập lời nhắn của bạn',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 131, 131, 131),
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          setModalState(() {
                            txt_ghiChuTaiXe.text = txt_ghiChuTaiXe.text;
                            Navigator.pop(context);
                          });
                        });
                      },
                      color: Colors.deepOrange,
                      minWidth: MediaQuery.of(context).size.width * 1,
                      height: 50,
                      child: Text(
                        'Xác nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PT Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDateTimeBottomSheet() async {
    ngayLayHang =
        'Hôm nay, ' +
        formatter.format(DateTime.now()) +
        ' - ' +
        formatter.format(DateTime.now().add(Duration(minutes: 15)));

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(FontAwesomeIcons.xmark),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 90),
                        child: Text(
                          'Hẹn giờ lấy hàng',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PT Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      ngayLayHang,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'PT Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          final DateTime now = DateTime.now();
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: now,
                            lastDate: now.add(Duration(days: 7)),
                          );
                          if (picked != null) {
                            //Chọn ngày
                            setState(() {
                              selectedDate = picked;
                              setModalState(() {
                                String dateAfterFomat = formatVietnameseDate(
                                  selectedDate!,
                                );
                                ngayLayHang =
                                    dateAfterFomat +
                                    " " +
                                    formatter.format(DateTime.now()) +
                                    ' - ' +
                                    formatter.format(
                                      DateTime.now().add(Duration(minutes: 15)),
                                    );
                              });
                            });
                          }
                        },
                        color: Colors.orangeAccent,
                        child: Text(
                          'Chọn ngày',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PT Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      MaterialButton(
                        onPressed: () async {
                          if (selectedDate == null) {
                            Fluttertoast.showToast(
                              msg: "Bạn nên chọn ngày trước",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              //Chọn giờ
                              setState(() {
                                selectedTime = picked;
                                setModalState(() {
                                  String dateAfterFomat = formatVietnameseDate(
                                    selectedDate!,
                                  );
                                  final startDateTime = DateTime(
                                    selectedDate!.year,
                                    selectedDate!.month,
                                    selectedDate!.day,
                                    selectedTime!.hour,
                                    selectedTime!.minute,
                                  );
                                  final endDateTime = startDateTime.add(
                                    Duration(minutes: 15),
                                  );

                                  ngayLayHang =
                                      dateAfterFomat +
                                      ' ' +
                                      formatter.format(startDateTime) +
                                      ' - ' +
                                      formatter.format(endDateTime);
                                });
                              });
                            }
                          }
                        },
                        color: Colors.orangeAccent,
                        child: Text(
                          'Chọn giờ',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PT Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ngayLayHang = "";

    _lstSelectedHangHoa = HashMap.fromIterable(
      List.generate(loaiHang.length, (index) => index),
      key: (index) => index,
      value: (_) => false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 55),
          child: Text(
            'Chi tiết đơn hàng',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'PT Sans',
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.centerRight,
                colors: [
                  const Color.fromARGB(255, 255, 216, 190),
                  const Color.fromARGB(255, 233, 241, 255),
                ],
                radius: 0.9,
                stops: [0.0, 0.8],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Lộ trình ',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PT Sans',
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _khoangCach.toString() + 'km',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'PT Sans',
                                          color: const Color.fromARGB(
                                            255,
                                            124,
                                            124,
                                            124,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ElevatedButton.icon(
                                icon: Icon(
                                  FontAwesomeIcons.retweet,
                                  size: 18,
                                  color: const Color.fromARGB(
                                    255,
                                    126,
                                    126,
                                    126,
                                  ),
                                ),

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                onPressed: () {},
                                label: Text(
                                  'Hoán đổi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PT Sans',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          MaterialButton(
                            onPressed: () {},
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20, top: 5),
                                  child: Icon(FontAwesomeIcons.solidCircleStop),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 16),
                                      Text(
                                        _diaChiGiaoHang,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'PT Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _tenNguoiNhan + ' | ',
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

                                            TextSpan(
                                              text: _sdtNguoiNhan,
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
                                ),

                                Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),

                          MaterialButton(
                            height: 40,
                            onPressed: () {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20, top: 5),
                                  child: Icon(
                                    FontAwesomeIcons.solidSquareCaretDown,
                                    color: const Color.fromARGB(
                                      255,
                                      228,
                                      103,
                                      2,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 16),
                                      Text(
                                        _diaChiGiaoHang,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'PT Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _tenNguoiNhan + ' | ',
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

                                            TextSpan(
                                              text: _sdtNguoiNhan,
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
                                ),
                                Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),

                          MaterialButton(
                            height: 70,
                            onPressed: () {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20, top: 5),
                                  child: Icon(
                                    FontAwesomeIcons.solidSquarePlus,
                                    color: const Color.fromARGB(
                                      255,
                                      228,
                                      103,
                                      2,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Thêm điểm giao',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      228,
                                      103,
                                      2,
                                    ),
                                    fontFamily: 'PT Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 155,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          MaterialButton(
                            height: 80,
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 14),
                                  child: Image(
                                    image: AssetImage(
                                      'lib/images/rocket_icon.png',
                                    ),
                                    width: 35,
                                    height: 35,
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Siêu tốc',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'PT Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),

                                      Text(
                                        'Lấy hàng ngay, giao hỏa tốc',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'PT Sans',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                ),
                                Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),

                          const Divider(
                            thickness: 1,
                            height: 1,
                            color: Color(0xFFE0E0E0),
                          ),

                          MaterialButton(
                            height: 70,
                            onPressed: () {
                              _showDateTimeBottomSheet();
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 3),
                                  child: Icon(
                                    FontAwesomeIcons.calendarDays,
                                    color: const Color.fromARGB(
                                      255,
                                      189,
                                      188,
                                      187,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Thời gian lấy hàng',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'PT Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),

                                      Text(
                                        ngayLayHang.isEmpty
                                            ? 'Bây giờ'
                                            : ngayLayHang,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'PT Sans',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          MaterialButton(
                            height: 40,
                            onPressed: () {
                              setState(() {
                                _isExpand = !_isExpand;
                              });
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 20,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.box,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    Text(
                                      'Thông tin hàng hóa',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'PT Sans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.24,
                                    ),
                                    Icon(
                                      _isExpand
                                          ? Icons.keyboard_arrow_down_outlined
                                          : Icons.keyboard_arrow_up_outlined,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          AnimatedCrossFade(
                            firstChild: Padding(
                              padding: EdgeInsets.only(left: 60),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      color: const Color.fromARGB(
                                        255,
                                        216,
                                        216,
                                        216,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          _selectedIndex == -1
                                              ? 'Kích cỡ'
                                              : sizes[_selectedIndex],
                                          style: _textStyleCTHangHoa,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            color: const Color.fromARGB(
                                              255,
                                              216,
                                              216,
                                              216,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                txt_khoiLuong.text.isEmpty
                                                    ? 'Khối lượng'
                                                    : txt_khoiLuong.text + 'kg',
                                                style: _textStyleCTHangHoa,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child:
                                              _lstSelectedHangHoa.values.every(
                                                    (v) => !v,
                                                  )
                                                  ? Container(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      216,
                                                      216,
                                                      216,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        4,
                                                      ),
                                                      child: Text(
                                                        'Loại sản phẩm',
                                                        style:
                                                            _textStyleCTHangHoa,
                                                      ),
                                                    ),
                                                  )
                                                  : Wrap(
                                                    spacing:
                                                        8.0, // Khoảng cách ngang giữa các mục
                                                    runSpacing:
                                                        8.0, // Khoảng cách dọc giữa các dòng
                                                    children:
                                                        _lstSelectedHangHoa
                                                            .entries
                                                            .where(
                                                              (entry) =>
                                                                  entry.value,
                                                            )
                                                            .map(
                                                              (
                                                                entry,
                                                              ) => Container(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          6,
                                                                    ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                      color:
                                                                          const Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216,
                                                                          ),
                                                                    ),
                                                                child: Text(
                                                                  loaiHang[entry
                                                                      .key],
                                                                  style:
                                                                      _textStyleCTHangHoa,
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            secondChild: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Kích cỡ',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            92,
                                            92,
                                            92,
                                          ),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PT Sans',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Tối đa',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            119,
                                            119,
                                            119,
                                          ),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PT Sans',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(
                                        '25x26x27',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            119,
                                            119,
                                            119,
                                          ),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PT Sans',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(sizes.length, (
                                      index,
                                    ) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(6),
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  _selectedIndex == index
                                                      ? Colors.orange
                                                      : Colors.grey,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              sizes[index],
                                              style: TextStyle(
                                                color:
                                                    _selectedIndex == index
                                                        ? Colors.orange
                                                        : Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'PT Sans',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),

                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Khối lượng(kg)',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            92,
                                            92,
                                            92,
                                          ),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PT Sans',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: TextField(
                                    controller: txt_khoiLuong,
                                    onChanged: (value) {
                                      if (int.tryParse(value) == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Vui lòng nhập đúng ký tự số',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).hideCurrentSnackBar();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Nhập khối lượng',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Loại hàng hóa',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            92,
                                            92,
                                            92,
                                          ),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'PT Sans',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    bottom: 20,
                                  ),
                                  child: SizedBox(
                                    height: 45,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: loaiHang.length,
                                      itemBuilder: (context, index) {
                                        bool isSelected =
                                            _lstSelectedHangHoa[index] == true;
                                        return Padding(
                                          padding: EdgeInsets.only(right: 15),
                                          child: MaterialButton(
                                            shape: StadiumBorder(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _lstSelectedHangHoa[index] =
                                                    !isSelected;
                                              });
                                            },
                                            child: Text(
                                              loaiHang[index],
                                              style: TextStyle(
                                                color:
                                                    isSelected
                                                        ? Colors.orange
                                                        : Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            crossFadeState:
                                _isExpand
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 300),
                          ),

                          const Divider(
                            thickness: 1,
                            height: 1,
                            color: Color(0xFFE0E0E0),
                          ),
                          MaterialButton(
                            onPressed: () {
                              _showGhiChuTaiXe();
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5, right: 10),
                                  child: Icon(
                                    FontAwesomeIcons.fileLines,
                                    color: Colors.grey,
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    txt_ghiChuTaiXe.text.isEmpty
                                        ? 'Ghi chú cho tài xế'
                                        : txt_ghiChuTaiXe.text,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color:
                                          txt_ghiChuTaiXe.text.isEmpty
                                              ? Colors.black
                                              : const Color.fromARGB(
                                                255,
                                                100,
                                                100,
                                                100,
                                              ),
                                      fontFamily: 'PT Sans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),

                                Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 525,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 5),
                              child: Text(
                                'Yêu cầu đặc biệt',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PT Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: lst_yeuCauDacBiet.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              top: 5,
                                            ),
                                            child: Text(
                                              lst_yeuCauDacBiet[index],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'PT Sans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 8,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  '0đ',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      126,
                                                      126,
                                                      126,
                                                    ),
                                                    fontFamily: 'PT Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "🎟️ MÃ KHUYẾN MÃI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PT San',
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Color.fromARGB(255, 168, 168, 168),
                ),

                MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "📦 NGƯỜI GỬI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PT San',
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 1,
              color: Color.fromARGB(255, 168, 168, 168),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng phí",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PT San',
                    fontSize: 16,
                  ),
                ),
                Text(
                  "17.000₫",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed:
                    null, // một biến boolean để kiếm soát việc disable nút đặt đơn
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Đặt đơn",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PT San',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
