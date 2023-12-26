import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/utils/index.dart';
import 'package:datingapp/src/widgets/kind_button.dart';
import 'package:datingapp/src/widgets/login_button.dart';
import 'package:datingapp/src/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datingapp/src/constants/app_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:datingapp/src/routing/app_router.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:datingapp/src/widgets/progress_hud.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import '../../widgets/bottom_nav_bar.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class UpdateScheduleScreen extends ConsumerStatefulWidget {
  const UpdateScheduleScreen({
    required this.selectedYear,
    required this.selectedMonth,
    required this.selectedDay,
    required this.dateTime,
    Key? key,
  }) : super(key: key);

  final DateTime dateTime;
  final String selectedYear;
  final String selectedMonth;
  final String selectedDay;

  @override
  ConsumerState<UpdateScheduleScreen> createState() => _UpdateScheduleScreenState();
}

class _UpdateScheduleScreenState extends ConsumerState<UpdateScheduleScreen> {

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final int _currentIndex = 0;
  final _birthdayController = TextEditingController();
  String get email => _birthdayController.text;
  final _emailController = TextEditingController();
  DateTime? _currentDate;
  bool active = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (this.mounted) {
        setState(() {
          this.keyboardHeight = keyboardHeight;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      // Disable the revert action if needed
      return false;
    }
    Dialog();
    return false;
  }

  @override
  Widget build(BuildContext context) {

    if (_isKeyboardVisible == true) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = 600;
      keyboardHeight = 0;
    }
    // widget.selectedYear+"-"+widget.selectedMonth+"-"+widget.selectedDay

    String week = DateFormat('EEE', 'ja').format(widget.dateTime);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 234, 234),
        resizeToAvoidBottomInset: false, // Set this to false
          body: SafeArea(
          child: Container(
            child: SizedBox.expand(
              child: FocusScope(
                child: Container(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Flexible(flex: 1, child: SizedBox(height: 500.h)),
                        
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at the start and end of the row
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    child: Image.asset(
                                      'assets/images/icon/back_btn1.png',
                                      height: 30,
                                    ),
                                  ),
                                ) 
                              ),
                              Spacer(),
                              Expanded(
                                child: Container(
                                  child: Image.asset(
                                    'assets/images/icon/text.png',
                                    height: 30,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                    child: Image.asset(
                                      'assets/images/icon/notification.png',
                                      height: 30,
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          width: 100 * 3.5,
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Container(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  "${widget.selectedYear}年 ${widget.selectedMonth}月 ${widget.selectedDay}日 (${week})", 
                                  style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),),
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 100 * 3.5,
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Container(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  Text(
                                    "出勤", 
                                    style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),),
                                  ),
                                  Switch(
                                    value: active,
                                    onChanged: (bool value) {
                                      setState(() {
                                        active = value;
                                      });
                                    },
                                  ),
                                ],
                              ) 
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 100 * 3.5,
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Container(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "予約可能時間", 
                                    style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),),
                                  ),
                                  InkWell(
                                    onTap: () {

                                    },
                                    child: Image.asset("assets/images/navbar_icon/add1.png")
                                  ) 
                                ],
                              ) 
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 100 * 3.5,
                          height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Container(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      "20:00 ~ 20:45", 
                                      style: TextStyle(color: Colors.black,),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child:  InkWell(
                                      onTap: () {
                                        
                                      },
                                      child: Image.asset("assets/images/icon/close_btn.png")
                                    ) 
                                  ),
                                ],
                              ) 
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: 100 * 3.5,
                          height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 234, 234, 234),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Container(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      "21:00 ~ 21:45", 
                                      style: TextStyle(color: Colors.black,),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child:  InkWell(
                                      onTap: () {
                                        
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 20,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 155, 110, 124),
                                          borderRadius: BorderRadius.circular(20)  
                                        ),
                                        child: Text("RESERVED", style: TextStyle(fontSize: 10, color: Colors.white),
                                        ) 
                                      )
                                    ) 
                                  ),
                                ],
                              ) 
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
    ));
  }
}
