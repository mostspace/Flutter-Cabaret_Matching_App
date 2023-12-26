import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/choose_picture.dart';
import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/auth/register_info.dart';
import 'package:datingapp/src/utils/async_value_ui.dart';
import 'package:datingapp/src/widgets/kind_button.dart';
import 'package:datingapp/src/widgets/login_button.dart';
import 'package:datingapp/src/widgets/logout_button.dart';
import 'package:dropdown_plus_plus/dropdown_plus_plus.dart';
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

import 'auth_controllers.dart';
import 'location_controller.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class ChooseLocation extends ConsumerStatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);
  @override
  ConsumerState<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends ConsumerState<ChooseLocation>  with TickerProviderStateMixin {

  final _username = TextEditingController();
  final _location = TextEditingController();
  final _add_location = TextEditingController();

  String get name => _username.text;
  String get location => _location.text;
  String get add_location => _add_location.text;
  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  String? selectedValue;
  TabController? _tabController;
  int _selectedTabIndex = 0; // Initial value
  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (this.mounted) {
        setState(() {
          this.keyboardHeight = keyboardHeight;
        });
      }
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  void getData () async {
    await ref.read(locationProvider.notifier).doLocationData();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTabIndex = _tabController!.index ;
    });
  }

  @override
  void dispose() {
    _username.dispose();
    _location.dispose();
    _add_location.dispose();
    _tabController!.dispose();
    super.dispose();
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      // Disable the revert action if needed
      return false;
    }
    const Dialog();
    return false;
  }

  Widget _buildTab(String label) {
    return Container(
      height: 40.0, // Tab height
      width: 40.0, // Tab width
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(fontSize: 16.0), // Tab text style
      ),
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

    ref.listen<AsyncValue>(locationProvider.select((state) => state),
    (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(locationProvider);
    final locations = state.value;
  
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 234, 234),
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
                        
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              const SizedBox(width: 15,),
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
                                    const SizedBox(width: 10,),
                                    const Text(
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
                              const SizedBox(width: 10,),
                              Container(
                                alignment: Alignment.topLeft,
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Text(
                                    '4',
                                    style: TextStyle(
                                      fontSize: 17, // Adjust the font size as needed
                                      color: Color.fromARGB(255, 155, 110, 124),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              const Text(
                                "プロフィールを入力してください",
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
                            controller: _username,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              // labelStyle: kLabelStyle,
                              // errorStyle: kErrorStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: kEnableBorder,
                              focusedBorder: kFocusBorder,
                              hintText: "ユーザー名",
                              hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.grey[50],
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              // Align the text within the TextField vertically and horizontally
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20),
                              counterText: '',
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h / 0.06),
                        Container(
                          width: 100 * 3.3,
                          color: const Color.fromARGB(255, 190, 190, 190),
                          child: DefaultTabController(
                            length: 2, // Two tabs for "Men" and "Women"
                            child: TabBar(
                              controller: _tabController, // Associate the TabBar with the TabController
                              indicator: BoxDecoration(
                                color: const Color.fromARGB(255, 178, 156, 163),
                                border: Border.all(color: const Color.fromARGB(255, 178, 156, 163)),
                              ),
                              tabs: <Widget>[
                                Container(
                                  child: _buildTab('女性'), // Custom tab widget for Women
                                ),
                                Container(
                                  child: _buildTab('男性'), // Custom tab widget for Men
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 4.h / 0.06),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Container(
                                alignment: Alignment.topLeft,
                                width: 40,
                                height: 40,
                                decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      fontSize: 17, // Adjust the font size as needed
                                      color: Color.fromARGB(255, 155, 110, 124),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              const Text(
                                "活動地域を選択してください\n1箇所以上の指定が必要です",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 155, 110, 124),
                                ),
                              )
                            ],
                          )
                        ), 
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: 100 * 3.3,
                          child: DropdownButtonFormField<String>(
                            value: selectedValue,
                            items: locations!.map((location) {
                              return DropdownMenuItem<String>(
                                value: location.residence as String,
                                child: Text(location.residence as String),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              enabledBorder: kEnableBorder,
                              focusedBorder: kFocusBorder,
                              hintText: "東京都/新宿",
                              hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.grey[50],
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                              counterText: '',
                              prefixIcon: const Icon(Icons.location_on),
                              // suffixIcon: IconButton(
                              //   icon: const Icon(Icons.cancel),
                              //   onPressed: () {
                              //     _location.clear();
                              //   },
                              // ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: 100 * 3.3,
                          child: TextField(
                            // textAlign: TextAlign.center,
                            controller: _add_location,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              // labelStyle: kLabelStyle,
                              // errorStyle: kErrorStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: kEnableBorder,
                              focusedBorder: kFocusBorder,
                              hintText: "追加",
                              hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.grey[50],
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              // Align the text within the TextField vertically and horizontally
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20),
                              counterText: '',
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5.h / 0.06),
                        LoginButton(
                          btnType: LoginButtonType.checkBtn,
                          onPressed: () async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if(selectedValue == ""){
                              await prefs.setString("location", "北海道");
                            }
                            if(name == "") {
                              showErrorToastMessage("名前を入力してください。");
                              return;
                            }
                            if(add_location == "") {
                              showErrorToastMessage("追加地域を入力してください。");
                              return;
                            }
                            final controller = ref.read(loginControllerProvider.notifier);
                            controller.doNameCompare(name).then(
                              (value) async {
                                if (value == true) {
                                  await prefs.setString("username", name);
                                  await prefs.setString("location", selectedValue.toString());
                                  await prefs.setString("add_location", add_location);
                                  await prefs.setString("gender", _selectedTabIndex.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChoosePicture(),
                                    ));
                                } else {
                                  final msg = "登録しようとしているメールがあります。";
                                  showErrorToastMessage(msg);
                                }
                              },
                            );
                          }
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
