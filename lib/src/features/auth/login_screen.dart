import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/choose_info.dart';
import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/auth/register_info.dart';
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
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';
import 'auth_controllers.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class LoginScreen extends ConsumerStatefulWidget {
  final String? type;
  const LoginScreen({super.key, required this.type});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String get email => _emailController.text;
  String get password => _passwordController.text;
  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  User user = User();

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginBtn() {
    final emailError = "メールを入力してください。";
    if (email == "") {
      showErrorToastMessage(emailError);
      return;
    }

    // check password textfield's validation.
    final pwdError = "パスワードを入力してください。";
    if (password == "") {
      showErrorToastMessage(pwdError);
      return;
    }

    // try to login with input data.
    final controller = ref.read(loginControllerProvider.notifier);
    controller.doLogin(email, password).then(
      (value) {
        if (value == true) {
          showToastMessage("ログインが成功しました。");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          
        }
      },
    );
    // context.goNamed(AppRoute.homeScreen.name);
  }

  void registerBtn() {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
    final emailError = "メールを入力してください。";
    if (email == "") {
      showErrorToastMessage(emailError);
      return;
    }

    if(!emailRegex.hasMatch(email)) {
      showErrorToastMessage("正しいメール形式を入力してください。");
      return;
    }

    // check password textfield's validation.
    final pwdError = "パスワードを入力してください。";
    if (password == "") {
      showErrorToastMessage(pwdError);
      return;
    }
    if (password.length < 8) {
      showErrorToastMessage("パスワードはセキュリティ上8文字以上でなければなりません。");
      return;
    }
    
    // try to login with input data.
    final controller = ref.read(loginControllerProvider.notifier);
    controller.doEmailCompare(email).then(
      (value) async {
        if (value == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("email", email);
          await prefs.setString("password", password);
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => ChooseInfo(),
            )
          );
        } else {
          final msg = "登録しようとしているメールがあります。";
          showErrorToastMessage(msg);
        }
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
                          child: widget.type == "Login" ? Row(
                            children: [
                              SizedBox(width: 60.sp,),
                              // Container(
                              //   alignment: Alignment.topLeft,
                              //   width: 40,
                              //   height: 40,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     color: Colors.white,
                              //   ),
                              //   child: Center(
                              //     child: Text(
                              //       '1',
                              //       style: TextStyle(
                              //         fontSize: 17, // Adjust the font size as needed
                              //         color: Color.fromARGB(255, 155, 110, 124),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(width: 10,),
                              Text(
                                "サインイン方法を選択してください",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 155, 110, 124),
                                ),
                              )
                            ],
                          ): Row(
                            children: [
                              SizedBox(width: 40.sp,),
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
                                    '1',
                                    style: TextStyle(
                                      fontSize: 17, // Adjust the font size as needed
                                      color: Color.fromARGB(255, 155, 110, 124),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "サインイン方法を選択してください",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 155, 110, 124),
                                ),
                              )
                            ],
                          )
                        ),
                        
                        SizedBox(height: 3.h / 0.06),
                        SizedBox(
                          width: 100 * 3.3,
                          child: TextField(
                            // textAlign: TextAlign.center,
                            controller: _emailController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              // labelStyle: kLabelStyle,
                              // errorStyle: kErrorStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: kEnableBorder,
                              focusedBorder: kFocusBorder,
                              hintText: "Email",
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
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            autocorrect: false,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              // labelStyle: kLabelStyle,
                              // errorStyle: kErrorStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: kEnableBorder,
                              focusedBorder: kFocusBorder,
                              hintText: "Password",
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

                        SizedBox(height: 5.h / 0.06),
                        LoginButton(
                          btnType: LoginButtonType.startBtn,
                          onPressed: () {
                            widget.type == "Login" ? loginBtn(): registerBtn();
                          }
                        ),
                        widget.type == "Login" ?
                        TextButton(
                          onPressed: () {
                            
                          }, 
                          child: Text(
                          "パスワードをお忘れですか？",
                          style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 155, 110, 124))),
                        ) : Container(),
                        SizedBox(height: 20,),
                        KindButton(
                          btnType: KindButtonType.appleLogin,
                          onPressed: () {},
                        ),
                        SizedBox(height: 5,),
                        KindButton(
                          btnType: KindButtonType.googleLogin,
                          onPressed: () {},
                        ),
                        SizedBox(height: 5,),
                        KindButton(
                          btnType: KindButtonType.twitterLogin,
                          onPressed: () {},
                        ),
                        SizedBox(height: 5,),
                        KindButton(
                          btnType: KindButtonType.facebookLogin,
                          onPressed: () {},
                        ),
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
