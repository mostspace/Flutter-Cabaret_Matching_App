import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/home/home_screen.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:datingapp/src/widgets/progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_controllers.dart';
import 'choose_location.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class ChoosePicture extends ConsumerStatefulWidget {
  const ChoosePicture({Key? key}) : super(key: key);
  @override
  ConsumerState<ChoosePicture> createState() => _ChoosePictureState();
}

class _ChoosePictureState extends ConsumerState<ChoosePicture> {

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  File? _image;
  String? avaImg;
  String? previewImg;
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

  Future<void> UpdateImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File image = File(pickedFile.path);
    setState(() {
      _image = image;
      if (_image != null) {
        avaImg = pickedFile.path.split('/').last;
        previewImg = pickedFile.path;
        // uploadImage(avaImg);
      }
    });
  }

  Future<void> submit() async{
    if (avaImg == "" || avaImg == null) {
      showErrorToastMessage("写真を選択してください。 ");
      return;
    }
     // try to login with input data.
    final controller = ref.read(loginControllerProvider.notifier);
    List<int> imageBytes = _image!.readAsBytesSync();
    String baseimage = base64Encode(imageBytes);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    controller.doUploadfile(avaImg!, baseimage).then(
      (value) async{
        // go home only if login success.
        if (value == true) {
          await prefs.setString("email","");
          await prefs.setString("password","");
          await prefs.setString("bar_id","");
          await prefs.setString("birthday","");
          await prefs.setString("username","");
          await prefs.setString("location","");
          await prefs.setString("add_location","");
          await prefs.setString("gender","");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {}
      },
    );
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
                            children: [
                              SizedBox(width: 15,),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/icon/back_btn.png', // Replace with the actual image path
                                      width: 24, // Adjust the width to your preference
                                      height: 24, // Adjust the height to your preference
                                    ),
                                    SizedBox(width: 10,),
                                    Text(
                                      "戻る",
                                    style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 155, 110, 124))),
                                  ],
                                ) 
                              )
                            ],
                          )
                        ),
                        SizedBox(height: 70.h),
                        Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 5.h / 0.06),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Container(
                                alignment: Alignment.topLeft,
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    '6',
                                    style: TextStyle(
                                      fontSize: 17, // Adjust the font size as needed
                                      color: Color.fromARGB(255, 155, 110, 124),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "プロフィール写真を設定してください",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 155, 110, 124),
                                ),
                              )
                            ],
                          )
                        ),
                        
                        SizedBox(height: 3.h / 0.06),
                        
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              UpdateImage();
                            },
                            child: avaImg == null? Image.asset(
                              'assets/images/icon/upload_img.png', 
                              width: 250,
                              height: 250,
                            ): ClipRRect(
                                borderRadius: BorderRadius.circular(150.0),
                                child: previewImg != null ?Image.file(File(previewImg!),
                                    fit: BoxFit.cover, width: 250, height: 250):Container())
                          )
                        ),

                        SizedBox(height: 20.h / 0.06),
                        LoginButton(
                          btnType: LoginButtonType.imgUploadBtn,
                          onPressed: () {
                            submit();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const HomeScreen(),
                            //   ));
                          }
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    ));
  }
}
