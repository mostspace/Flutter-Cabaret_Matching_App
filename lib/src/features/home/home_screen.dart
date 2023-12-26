import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/home/home_card.dart';
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
import 'package:grouped_list/grouped_list.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/slider_bar.dart';
import '../user_profile/user_profile.dart';
import 'home_controller.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final int _currentIndex = 0;
  String email = "";
  String name ="";
  String photo = "";
  String? loginId;
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
    getData();
    
  }

  void getData() async{
    ref.read(homeDataProvider.notifier).doFetchNotifs();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginId = await prefs.getString("login_id")!;
    email = await prefs.getString("login_email")!;
    name = await prefs.getString("login_name")!;
    photo = await prefs.getString("login_photo")!;
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

    ref.listen<AsyncValue>(homeDataProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(homeDataProvider);
    final datas = state.value;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: NavBar(u_email: email, u_name: name, u_photo: photo),
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
                        
                        HeaderWidget(type: "any"),

                        SizedBox(height: 20,),

                        Expanded(
                          // physics: const AlwaysScrollableScrollPhysics(),
                          child: datas != null && datas.isNotEmpty
                          ? GroupedListView(
                              order: GroupedListOrder.ASC,
                              elements: datas,
                              groupBy: (data) => data.article_id,
                              groupSeparatorBuilder: (value) {
                                final now = DateTime.now();
                                return Container(
                                  child: SizedBox(),
                                );
                              },
                              itemBuilder: (context, element) {
                                return  HomeCardScreen(
                                  login_id: loginId.toString(),
                                  info: element,
                                  onPressed: () {},
                                );
                              },
                            )
                          : const SizedBox(
                              child: Text(
                                "No data",
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
