import 'dart:math';
import 'dart:async';

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

import 'login_screen.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class ChoosePrivacy extends ConsumerStatefulWidget {
  const ChoosePrivacy({Key? key}) : super(key: key);
  @override
  ConsumerState<ChoosePrivacy> createState() => _ChoosePrivacyState();
}

class _ChoosePrivacyState extends ConsumerState<ChoosePrivacy> {
  late Timer timer;

  int currentDecorationIndex = 0; // Initialize with the first decoration
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 234, 234),
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
                    SizedBox(height: 350.h),
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 30.h / 0.06),
                    Text(
                      "このアプリは18歳以上の方のみが利用できます",
                      style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 155, 110, 124))),
                    SizedBox(height: 10.h / 0.06),
                    LoginButton(
                      btnType: LoginButtonType.privacyBtn,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(type: "Register"),
                        )),
                    ),
                    SizedBox(height: 20,),
                    LogoutButton(
                      btnType: LogoutButtonType.outBtn,
                      onPressed: () => Navigator.pop(context),
                    ),
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
