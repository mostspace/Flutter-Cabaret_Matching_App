import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/home/profile_info.dart';
import 'package:datingapp/src/features/user_profile/profile_controller.dart';
import 'package:datingapp/src/features/user_profile/profile_repository.dart';
import 'package:datingapp/src/utils/async_value_ui.dart';
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
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../utils/index.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../auth/auth_controllers.dart';
import '../home/home_controller.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({
    Key? key,
    required this.login_id,
    required this.article_id
  }) : super(key: key);

  final String login_id;
  final String article_id;
  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver{

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final int _currentIndex = 0;
  final _birthdayController = TextEditingController();
  String get email => _birthdayController.text;
  final _emailController = TextEditingController();
  List<dynamic> items = [];
  late int _current = 0;
  DateTime? now;
  int? currentYear;
  int? month;
  List<Map<String, dynamic>> dateList = [];
  late Future<void> otherProfileDataFuture;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (this.mounted) {
        setState(() {
          this.keyboardHeight = keyboardHeight;
          ref.read(profileProvider.notifier).deUserProfileInfoData(widget.article_id);
        });
      }
    });
    WidgetsBinding.instance.addObserver(this);
    // getData();
    otherProfileDataFuture = getData();
    initializeDateList();
  }

  Future<void> getData() async{
    ref.read(profileProvider.notifier).deUserProfileInfoData(widget.article_id);
  }

  void initializeDateList() {
    final now = DateTime.now();
    for (int i = 0; i < 6; i++) {
       try {
        // Create a new DateTime object by adding 'i' days to 'now'
        DateTime date = now.add(Duration(days: i)); // Change subtract to add

        // Format the date as "M/d"
        String formattedDate = DateFormat('M/d').format(date);
        
        // Add the date to the dateList array with isSelected set to false
        dateList.add({
          "isSelected": false,
          "date": DateFormat('M/d', 'ja').format(date),
          "day": DateFormat('EEE', 'ja').format(date),
        });
      } catch (e) {
        // Invalid date, skip to the next iteration
        continue;
      }
    }
    
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
    ref.listen<AsyncValue>(loginControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(loginControllerProvider);

    final profile = ref.watch(profileStateChangesProvider).value;
    setState(() {
      this.keyboardHeight = keyboardHeight;
      items = [
        if (profile?.photo1 != "http://43.207.77.181/uploads/post_image/null" && profile?.photo1 != "http://43.207.77.181/uploads/post_image/") profile?.photo1,
        if (profile?.photo2 != "http://43.207.77.181/uploads/post_image/null" && profile?.photo2 != "http://43.207.77.181/uploads/post_image/") profile?.photo2,
        if (profile?.photo3 != "http://43.207.77.181/uploads/post_image/null" && profile?.photo3 != "http://43.207.77.181/uploads/post_image/") profile?.photo3,
        if (profile?.photo4 != "http://43.207.77.181/uploads/post_image/null" && profile?.photo4 != "http://43.207.77.181/uploads/post_image/") profile?.photo4,
        if (profile?.photo5 != "http://43.207.77.181/uploads/post_image/null" && profile?.photo5 != "http://43.207.77.181/uploads/post_image/") profile?.photo5,
        if (profile?.photo6 != "http://43.207.77.181/uploads/post_image/null" && profile?.photo6 != "http://43.207.77.181/uploads/post_image/") profile?.photo6,
      ];
    });
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 234, 234),
        resizeToAvoidBottomInset: false, // Set this to false
          body: isLoading == false ? 
          Container(
            child: Center(
              child: SizedBox(
                width: 100.0, // Adjust the size of the loading indicator as needed
                height: 100.0,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: _kDefaultRainbowColors,
                  strokeWidth: 4.0,
                ),
              ),
            ),
          ): SafeArea(
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
                                child: Container(
                                  child: Image.asset(
                                    'assets/images/icon/notification.png',
                                    height: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: SingleChildScrollView( 
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      SizedBox(
                                        height: vhh(context, 49),
                                        width: vww(context, 100),
                                        child: ListView(children: [
                                          CarouselSlider(
                                            items: items.map((item) { // Iterate over each item in the 'items' array
                                              return Container(
                                                height: double.infinity,
                                                width: double.infinity,
                                                margin: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(255, 155, 110, 124),
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(vww(context, 10)),
                                                    bottomRight: Radius.circular(vww(context, 10)),
                                                  ),
                                                  image: DecorationImage(
                                                    image: NetworkImage(item), // Use the current item from the array
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: Container(
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(10.0), // Default radius
                                                          topRight: Radius.circular(10.0), // Default radius
                                                        ),
                                                      ),
                                                    ],),
                                                  ),
                                                
                                              );
                                            }).toList(),
                                            options: CarouselOptions(
                                              enableInfiniteScroll: true,
                                              height: vhh(context, 46),
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _current = index;
                                                });
                                              },
                                              viewportFraction: 1,
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Positioned(
                                        bottom: 30,
                                        child: CarouselIndicator(
                                          count: items.length,
                                          index: _current,
                                          activeColor: Colors.black,
                                          color: const Color.fromARGB(255, 131, 131, 131),
                                          height: 10,
                                          width: 10,
                                        )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: vhh(context, 0),
                                            horizontal: vww(context, 6)),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 0),
                                            child: Column(children: [
                                              Column(children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.only(
                                                      top: 0, bottom: 0, right: 0),
                                                  child: Text("${profile?.user_name}",
                                                      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 155, 110, 124),)
                                                      )
                                                    ),
                                                SizedBox(height: 10,),
                                                Padding(
                                                    padding: EdgeInsets.only(right: 1),
                                                    child: Container(
                                                      padding: EdgeInsets.all(0),
                                                      child : Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  
                                                        children: [
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                                                            children: [
                                                              Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                                              Text(
                                                                '${profile?.residence}',  // Add the text you want to display
                                                                style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                                fontSize: 10),
                                                              ),
                                                              SizedBox(width: 10,),
                                                              Icon(Icons.coffee, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                                              Text(
                                                                '${profile?.add_location}',  // Add the text you want to display
                                                                style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                                fontSize: 10),
                                                              ),
                                                            ],
                                                          ),
                                                          profile?.ischeckFollow == "0"?
                                                          profile?.user_id == widget.login_id ?
                                                          Container():
                                                          Container(
                                                            height: 100 / 5,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                final controller = ref.read(loginControllerProvider.notifier);
                                                                controller.doSearchFollowData(profile!.user_id).then(
                                                                  (value) async{
                                                                    // go home only if login success.
                                                                    if (value == true) {
                                                                      getData();
                                                                    } else {}
                                                                  },
                                                                );
                                                              },
                                                              child: Text(
                                                                'フォロー',
                                                                style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 242, 234, 234)),
                                                              ),
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<Color>( Color.fromARGB(255, 155, 110, 124)), // Adjust background color
                                                                shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(
                                                                        20.0), // Adjust border radius
                                                                  ),
                                                                ),
                                                                minimumSize: MaterialStateProperty.all<Size>(
                                                                    Size(80.0, 10.0)), // Adjust button size
                                                              ),
                                                            ),
                                                          ):
                                                          Container(
                                                            height: 100 / 5,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                // Navigator.push(
                                                                //   context,
                                                                //   MaterialPageRoute(
                                                                //     builder: (context) => const ProfileInfoScreen(),
                                                                //   )
                                                                // );
                                                              },
                                                              child: Text(
                                                                'フォロー中',
                                                                style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 155, 110, 124)),
                                                              ),
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<Color>(Color.fromARGB(255, 242, 234, 234)), // Adjust background color
                                                                shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(
                                                                        20.0), // Adjust border radius
                                                                  ),
                                                                ),
                                                                minimumSize: MaterialStateProperty.all<Size>(
                                                                    Size(80.0, 10.0)), // Adjust button size
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ) 
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Padding(
                                                    padding: EdgeInsets.only(right: 1, left: 5),
                                                    child: Container(
                                                      padding: EdgeInsets.all(0),
                                                      child : Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  
                                                        children: [
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                                                            children: [
                                                              Text(
                                                                'Age. ${profile?.age}',  // Add the text you want to display
                                                                style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                                fontSize: 10),
                                                              ),
                                                              SizedBox(width: 10,),
                                                              Icon(Icons.person, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                                              Text(
                                                                '${profile?.following_count}人',  // Add the text you want to display
                                                                style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                                fontSize: 10),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 100 / 5,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                //  _showBottomSheet(context);
                                                              },
                                                              child: Text(
                                                                'メッセージ',
                                                                style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 242, 234, 234)),
                                                              ),
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<Color>(Color.fromARGB(255, 155, 110, 124)), // Adjust background color
                                                                shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(
                                                                        20.0), // Adjust border radius
                                                                  ),
                                                                ),
                                                                minimumSize: MaterialStateProperty.all<Size>(
                                                                    Size(80.0, 10.0)), // Adjust button size
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ) 
                                                  ),
                                                ),
                                              ]),
                                            ]
                                          )
                                        )
                                      ),
                                      SizedBox(height: 15,),
                                      Container(
                                        width: 100 *3.5,
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Icon(Icons.calendar_month, size: 25, color: Color.fromARGB(255, 155, 110, 124)),
                                            SizedBox(width: 5,),
                                            Text("予定", style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 155, 110, 124)),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: dateList.map((e) {
                                          return Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width / 1.3,
                                                height: MediaQuery.of(context).size.height / 15,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 10, right: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          '${e["date"]} (${e["day"]}) 出勤',
                                                          style: TextStyle(
                                                            color: Colors.grey[500],
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          '予約不可',
                                                          style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 155, 110, 124)),
                                                        ),
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 242, 234, 234)),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                            ),
                                                          ),
                                                          minimumSize: MaterialStateProperty.all<Size>(Size(80.0, 20.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          );
                                        }).toList()
                                      ),

                                      SizedBox(height: 15,),
                                    ],
                                  ),
                                ]
                              )
                            )
                          )
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
