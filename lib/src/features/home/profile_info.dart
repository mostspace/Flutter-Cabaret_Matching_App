import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
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

class ProfileInfoScreen extends ConsumerStatefulWidget {
  const ProfileInfoScreen({
    Key? key,
    required this.photo,
    required this.name,
  }) : super(key: key);

  final String photo;
  final String name;
  @override
  ConsumerState<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends ConsumerState<ProfileInfoScreen> {

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final int _currentIndex = 0;
  final _birthdayController = TextEditingController();
  String get email => _birthdayController.text;
  final _emailController = TextEditingController();
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
                                      'assets/images/icon/save_btn.png',
                                      height: 30,
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          width: 100 * 3.5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(color: Colors.black45),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    "http://43.207.77.181/uploads/image/" + widget.photo,
                                    width: 165,
                                    height: 165,
                                    fit: BoxFit.cover, 
                                    loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    }
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(
                                    '${widget.name}',  // Add the text you want to display
                                    style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                    fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: 100 * 3.5,
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Container(
                                padding: EdgeInsets.all(0),
                                child : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                                      children: [
                                        Text(
                                          '初回来店　2021/12/25',  // Add the text you want to display
                                          style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                          fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 100 / 5,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          
                                        },
                                        child: Text(
                                          '来店履歴',
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
                                    ),
                                  ],
                                ) 
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: 100 * 3.5,
                            child: Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Container(
                                padding: EdgeInsets.all(0),
                                child : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                                      children: [
                                        Text(
                                          '最終来店　2023/3/10',  // Add the text you want to display
                                          style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                          fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ) 
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                          width: 100 * 3.5,
                          child: Container( 
                            padding: EdgeInsets.all(0.0),
                            child: TextField(
                              maxLines: 12,
                              decoration: InputDecoration(
                                hintText: 'メモ',
                                filled: true,
                                fillColor: Color.fromARGB(255, 248, 244, 244),  // Set the background color to white
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),  // Set the border radius to 10
                                   borderSide: BorderSide(color: Color.fromARGB(255, 155, 110, 124)),
                                ),
                              ),
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
