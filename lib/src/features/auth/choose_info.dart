import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/register_info.dart';
import 'package:datingapp/src/utils/async_value_ui.dart';
import 'package:datingapp/src/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/src/constants/app_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bar_card.dart';
import 'bar_controllers.dart';
import 'bar_list.dart';
import 'choose_location.dart';
import 'package:grouped_list/grouped_list.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class ChooseInfo extends ConsumerStatefulWidget {
  const ChooseInfo({Key? key}) : super(key: key);
  @override
  ConsumerState<ChooseInfo> createState() => _ChooseInfoState();
}

class _ChooseInfoState extends ConsumerState<ChooseInfo> 
      with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {

  final _birthdayController = TextEditingController();
  String get birthday => _birthdayController.text;
  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final _shopController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int currentYear = DateTime.now().year;
  List<Bars> bar_data = [];
  List<Bars> filteredBars = [];
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

  Future<dynamic> yourFetchDataMethod() async {
    return ref.read(BarProvider.notifier).doBarData();
  }

  void getData() async {
    ref.read(BarProvider.notifier).doBarData();

    setState(() {
      filteredBars = bar_data; // Initialize filteredBars with all data initially.
    });
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    _shopController.dispose();
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

  @override
  Widget build(BuildContext context) {
    
    if (_isKeyboardVisible == true) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = 600;
      keyboardHeight = 0;
    }

    ref.listen<AsyncValue>(BarProvider.select((state) => state),
    (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(BarProvider);
    final bars = state.value;
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
                        // Flexible(flex: 1, child: SizedBox(height: 500.h)),
                        
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
                                    '2',
                                    style: TextStyle(
                                      fontSize: 17, // Adjust the font size as needed
                                      color: Color.fromARGB(255, 155, 110, 124),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              const Text(
                                "生年月日を入力してください",
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
                            readOnly:
                                true, // make the text field read-only
                            controller: _birthdayController,
                            onTap: () async {
                              final DateTime? picked =
                                  await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null &&
                                  picked != selectedDate)
                                setState(() {
                                  selectedDate =
                                      picked; // update the selected date
                                  _birthdayController
                                      .text = DateFormat(
                                          'yyyy/MM/dd')
                                      .format(selectedDate);
                                });
                            },
                            autocorrect: false,
                            keyboardType: TextInputType
                                .datetime, // set to datetime
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              labelStyle: kLabelStyle,
                              errorStyle: kErrorStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior
                                      .always,
                              contentPadding:
                                  kContentPadding,
                              enabledBorder: kEnableBorder,
                              focusedBorder: kFocusBorder,
                              hintText: "YYYY/MM/DD",
                              filled: true,
                              fillColor: Colors.grey[50],
                              focusedErrorBorder:
                                  InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder:
                                  InputBorder.none,
                            ),
                            style: kEditStyle,
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      fontSize: 17, // Adjust the font size as needed
                                      color: Color.fromARGB(255, 155, 110, 124),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              const Text(
                                "あなたはどちらの立場で利用しますか？",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 155, 110, 124),
                                ),
                              )
                            ],
                          )
                        ), 

                        SizedBox(height: 5.h / 0.06),
                        LoginButton(
                          btnType: LoginButtonType.workBtn,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(50.0), // Adjust the radius as needed
                                ),
                              ),
                              builder: (BuildContext context) {
                                return  Container(
                                  height: MediaQuery.of(context).size.height, // Set the height as needed
                                  child:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 30,),
                                      Container(
                                        child: const Center(
                                          child: Text("店名を入力してください",
                                          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 155, 110, 124)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 100 * 3.3,
                                        child: TextField(
                                          // textAlign: TextAlign.center,
                                          controller: _shopController,
                                          keyboardType: TextInputType.name,
                                          cursorColor: Colors.grey,
                                          onChanged: (value) {
                                            setState(() {
                                              filteredBars =  bars!.where((bar) =>
                                                bar.barName.toLowerCase().contains(value.toLowerCase()))
                                              .toList();
                                            });
                                          },
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
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 15.0, horizontal: 20),
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.18, // Set the desired width
                                        height: MediaQuery.of(context).size.height / 4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                                          border: Border.all(
                                            color: Color.fromARGB(255, 155, 110, 124), // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            filteredBars.isEmpty ?
                                            Expanded(
                                              child: _shopController.text.isEmpty && bars != null && bars.isNotEmpty
                                              ? BarCard(info: bars)
                                              : const SizedBox(
                                                  child: Padding(padding: EdgeInsets.all(80),
                                                    child: Text(
                                                      "No data",
                                                    ),
                                                  )
                                                ),
                                            ):  Expanded(
                                              child: filteredBars != null && filteredBars.isNotEmpty
                                              ? BarCard(info: filteredBars)
                                              : const SizedBox(
                                                  child: Text(
                                                    "No data",
                                                  ),
                                                ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      LoginButton(
                                        btnType: LoginButtonType.checkBtn,
                                        onPressed: () async{
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          if(birthday.isEmpty) {
                                            showErrorToastMessage("生年月日を選択してください。");
                                            return;
                                          }
                                          final getYear = birthday.split('/');
                                          final selectedYear = int.parse(getYear[0]);
                                          if(selectedYear >= currentYear -18 ) {
                                            showErrorToastMessage("18歳未満のユーザーはアプリを使用できません。");
                                            return;
                                          }
                                          var barID = await prefs.getString("bar_id");
                                          if(barID == "" && barID == "0") {
                                            showErrorToastMessage("店舗を選択してください。");
                                            return;
                                          }
                                          await prefs.setString("use_purpose", "0");
                                          await prefs.setString("birthday", birthday);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const ChooseLocation(),
                                            ));
                                        },
                                      ),

                                      // Add more options as needed
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        ),
                        const SizedBox(height: 15,),
                        LoginButton(
                          btnType: LoginButtonType.hireBtn,
                          onPressed: () async{
                            
                            if(birthday.isEmpty) {
                              showErrorToastMessage("生年月日を選択してください。");
                              return;
                            }
                            final getYear = birthday.split('/');
                            final selectedYear = int.parse(getYear[0]);
                            if(selectedYear >= currentYear -18 ) {
                              showErrorToastMessage("18歳未満のユーザーはアプリを使用できません。");
                              return;
                            }
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString("bar_id", "0");
                            await prefs.setString("use_purpose", "1");
                            await prefs.setString("birthday", birthday);
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChooseLocation(),
                              ));
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
