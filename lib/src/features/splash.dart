import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/choose_privacy.dart';
import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/home/home_screen.dart';
import 'package:datingapp/src/widgets/login_button.dart';
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

import '../widgets/gradient_button.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late Timer timer;

  final List<BoxDecoration> bgDecorations = [
    kBgDecoration1,
    kBgDecoration2,
    kBgDecoration3,
    kBgDecoration4,
  ];

  int currentDecorationIndex = 0; // Initialize with the first decoration
  @override
  void initState() {
    super.initState();
     timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        currentDecorationIndex = (currentDecorationIndex + 1) % bgDecorations.length;
      });
    });
    getData();
  }

  void getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = await prefs.getBool("isLogin") ?? false;
    if (isLogin!) {
      Timer(const Duration(microseconds: 1),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
          }  
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel(); // Cancel the timer when the widget is disposed
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: SizedBox.expand(
          child: FocusScope(
            child: Container(
              decoration: bgDecorations[currentDecorationIndex],
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Flexible(flex: 1, child: SizedBox(height: 500.h)),
                    SizedBox(height: 350.h),
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 60.h / 0.06),
                    SizedBox(height: 130.h),
                    LoginButton(
                      btnType: LoginButtonType.startBtn,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(type: "Login"),
                          )),
                    ),
                    TextButton(
                      onPressed: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString("email", "");
                        await prefs.setString("password", "");
                        await prefs.setString("bar_id", "");
                        await prefs.setString("use_purpose", "");
                        await prefs.setString("birthday", "");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChoosePrivacy(),
                          ));
                      }, 
                      child: Text(
                      "初めてご利用される方はこちら",
                      style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 155, 110, 124))),
                    ),
                    
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height /8.5,
                      child:  TextButton(
                        onPressed: () {
                          
                        }, 
                        child: Text(
                        "プライバシーポリシー",
                        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 155, 110, 124))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
