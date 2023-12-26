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

class GentleProfile extends ConsumerStatefulWidget {
  const GentleProfile({
    Key? key,
    required this.login_id,
    required this.article_id
  }) : super(key: key);

  final String login_id;
  final String article_id;
  @override
  ConsumerState<GentleProfile> createState() => _GentleProfileState();
}

class _GentleProfileState extends ConsumerState<GentleProfile> with
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
  }

  Future<void> getData() async{
    ref.read(profileProvider.notifier).deUserProfileInfoData(widget.article_id);
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0), // Adjust the radius as needed
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height /2, // Set the height as needed
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20,),
              Container(
                child: Center(
                  child: Text("来店を記録",
                  style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 155, 110, 124)),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 100 * 3.3,
                child: TextField(
                  // textAlign: TextAlign.center,
                  controller: _birthdayController,
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    // labelStyle: kLabelStyle,
                    // errorStyle: kErrorStyle,
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                    enabledBorder: kEnableBorder,
                    focusedBorder: kFocusBorder,
                    hintText: "店舗名",
                    hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    focusedErrorBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    // Align the text within the TextField vertically and horizontally
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    counterText: '',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 100 * 3.3,
                child: TextField(
                  // textAlign: TextAlign.center,
                  controller: _birthdayController,
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    // labelStyle: kLabelStyle,
                    // errorStyle: kErrorStyle,
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                    enabledBorder: kEnableBorder,
                    focusedBorder: kFocusBorder,
                    hintText: "滞在時間",
                    hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    focusedErrorBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    // Align the text within the TextField vertically and horizontally
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    counterText: '',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 100 * 3.3,
                child: TextField(
                  // textAlign: TextAlign.center,
                  controller: _birthdayController,
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    // labelStyle: kLabelStyle,
                    // errorStyle: kErrorStyle,
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                    enabledBorder: kEnableBorder,
                    focusedBorder: kFocusBorder,
                    hintText: "金額",
                    hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    focusedErrorBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    // Align the text within the TextField vertically and horizontally
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    counterText: '',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              LoginButton(
                btnType: LoginButtonType.saveBtn,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
                                                                'メッセージ',
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
                                                          // profile?.user_id == widget.login_id ?
                                                          // Container():
                                                          Container(
                                                            height: 100 / 5,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => ProfileInfoScreen(photo: profile!.user_photo, name: profile!.user_name)
                                                                  ));
                                                              },
                                                              child: Text(
                                                                'メモ',
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
                                            Icon(Icons.location_on, size: 25, color: Color.fromARGB(255, 155, 110, 124)),
                                            SizedBox(width: 5,),
                                            Text("活動地域", style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 155, 110, 124)),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.3, // Set the desired width
                                        height: MediaQuery.of(context).size.height / 15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10, right: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  _showBottomSheet(context);
                                                },
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '東京都/新宿',
                                                    style: TextStyle(
                                                      color: Colors.grey[500]
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ),

                                      SizedBox(height: 3,),

                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.3, // Set the desired width
                                        height: MediaQuery.of(context).size.height / 15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10, right: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  _showBottomSheet(context);
                                                },
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '東京都/新宿',
                                                    style: TextStyle(
                                                      color: Colors.grey[500]
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ),
                                      SizedBox(height: 3,),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.3, // Set the desired width
                                        height: MediaQuery.of(context).size.height / 15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10, right: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  _showBottomSheet(context);
                                                },
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '東京都/新宿',
                                                    style: TextStyle(
                                                      color: Colors.grey[500]
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ),



                                      SizedBox(height: 15,),
                                      Container(
                                        width: 100 *3.5,
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Icon(Icons.time_to_leave, size: 25, color: Color.fromARGB(255, 155, 110, 124)),
                                            SizedBox(width: 5,),
                                            Text("あなたとの記録", style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 155, 110, 124)),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.3, // Set the desired width
                                        height: MediaQuery.of(context).size.height / 15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.0, // Border width
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
                                                  '平均時間',
                                                  style: TextStyle(
                                                    color: Colors.grey[500]
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '2時間30分',
                                                  style: TextStyle(
                                                    color: Colors.grey[500]
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ),

                                      SizedBox(height: 3,),

                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.3, // Set the desired width
                                        height: MediaQuery.of(context).size.height / 15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.0, // Border width
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
                                                  '平均単価',
                                                  style: TextStyle(
                                                    color: Colors.grey[500]
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '￥120,000',
                                                  style: TextStyle(
                                                    color: Colors.grey[500]
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ),
                                      SizedBox(height: 50,)
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
