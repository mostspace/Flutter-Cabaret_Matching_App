import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/schedule/girl/update_schedule.dart';
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

class AddScheduleScreen extends ConsumerStatefulWidget {
  const AddScheduleScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends ConsumerState<AddScheduleScreen> {

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final int _currentIndex = 0;
  final _birthdayController = TextEditingController();
  String get email => _birthdayController.text;
  final _emailController = TextEditingController();
  DateTime? _currentDate;
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

  void updateSchedule() {
    if(_currentDate == null) {
      showErrorToastMessage("予約日を選択してください。");
      return;
    }
    DateTime? currentTime = _currentDate;
    // String sel_date = currentTime!.year.toString() + "-" + currentTime!.month.toString() + "-" + currentTime!.day.toString();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateScheduleScreen(selectedYear : currentTime!.year.toString(), selectedMonth : currentTime!.month.toString(), selectedDay : currentTime!.day.toString(), dateTime: currentTime),
      ));
  }

  @override
  Widget build(BuildContext context) {

    if (_isKeyboardVisible == true) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = 600;
      keyboardHeight = 0;
    }
    DateTime currentDate = DateTime.now();
    int month = currentDate.month;

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
                                        "出勤予定", 
                                        style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),),
                                      )
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 100 * 3.5,
                          height: vhh(context, 55),
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          child: CalendarCarousel(
                            onDayPressed: (DateTime date, List events) {
                              setState(() => _currentDate = date);
                            },
                            weekendTextStyle: TextStyle(
                              color: Colors.black,
                            ),
                            thisMonthDayBorderColor: Colors.grey,
                            customDayBuilder: (   /// you can provide your own build function to make custom day containers
                              bool isSelectable,
                              int index,
                              bool isSelectedDay,
                              bool isToday,
                              bool isPrevMonthDay,
                              TextStyle textStyle,
                              bool isNextMonthDay,
                              bool isThisMonthDay,
                              DateTime day,
                            ) {
                                // if (day.day == 15) {
                                //   return Center(
                                //     child: Icon(Icons.local_airport),
                                //   );
                                // } else {
                                //   return null;
                                // }
                            },
                            weekFormat: false,
                            leftButtonIcon: Image.asset("assets/images/icon/back_btn.png"),
                            rightButtonIcon: Image.asset("assets/images/icon/right_btn.png"),
                            headerTextStyle:TextStyle(color: Color.fromARGB(255, 155, 110, 124)),
                            iconColor: Color.fromARGB(255, 155, 110, 124),
                            selectedDayBorderColor: Color.fromARGB(255, 155, 110, 124),
                            selectedDayButtonColor: Color.fromARGB(255, 155, 110, 124),
                            todayBorderColor: Colors.white,  
                            todayButtonColor: Colors.white,
                            weekdayTextStyle: TextStyle(color: Color.fromARGB(255, 155, 110, 124), fontSize: 12),
                            todayTextStyle: TextStyle(color: Colors.black),
                            selectedDateTime: _currentDate,
                            daysHaveCircularBorder: null, /// null for not rendering any border, true for circular border, false for rectangular border
                          ),
                        ),
                        
                        SizedBox(height: 30,),
                        LoginButton(
                          btnType: LoginButtonType.scheduleSaveBtn,
                          onPressed: () {
                            updateSchedule();
                          },
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
