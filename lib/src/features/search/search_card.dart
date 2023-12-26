import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/search/search_controller.dart';
import 'package:datingapp/src/features/search/search_data.dart';
import 'package:datingapp/src/features/home/profile_info.dart';
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

import '../../components/header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../auth/auth_controllers.dart';
import '../user_profile/user_profile.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class SearchCardScreen extends ConsumerStatefulWidget {
  const SearchCardScreen({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final SearchData info;
  final VoidCallback onPressed;
  @override
  ConsumerState<SearchCardScreen> createState() => _SearchCardScreenState();
}

class _SearchCardScreenState extends ConsumerState<SearchCardScreen> {

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final int _currentIndex = 0;
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

  void getData() {
    ref.read(searchDataProvider.notifier).doFetchNotifs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SearchData InfoConvert = widget.info;

    return Padding(padding:EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white, // Change the color of the rectangle
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white, // Change the color of the rectangle
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 130.0,
                        height: 150.0,
                        margin: EdgeInsets.zero,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1),
                              bottomLeft: Radius.circular(1)
                            ),
                            child: Image.network(
                              "http://43.207.77.181/uploads/image/" + InfoConvert.user_photo,
                              height: 10,
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
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Wrap(
                          children: [
                            Text(
                              '${InfoConvert.user_name}',
                              style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Wrap(
                          children: [
                            Container(
                              child :Row(children: [
                                Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                Text(
                                  '${InfoConvert.residence}',  // Add the text you want to display
                                  style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                  fontSize: 10),
                                ),
                                SizedBox(width: 10,),
                                Icon(Icons.coffee, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                Text(
                                  '${InfoConvert.add_location}',  // Add the text you want to display
                                  style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                  fontSize: 10),
                                ),
                              ],)
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Wrap(
                          children: [
                            Container(
                              child :Row(children: [
                                SizedBox(width: 5,),
                                Text(
                                  'Age, ${InfoConvert.age}',  // Add the text you want to display
                                  style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                  fontSize: 10),
                                ),
                                SizedBox(width: 10,),
                                Icon(Icons.person, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                Text(
                                  '${InfoConvert.following_count}人',  // Add the text you want to display
                                  style: TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                  fontSize: 10),
                                ),
                              ],)
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 0.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InfoConvert.ischeckedFollow == "0" ? 
                              ElevatedButton(
                                onPressed: () {
                                  final controller = ref.read(loginControllerProvider.notifier);
                                  controller.doSearchFollowData(InfoConvert.user_id).then(
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
                                  style: TextStyle(fontSize: 12),
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
                                      Size(80.0, 20.0)), // Adjust button size
                                ),
                              ):
                              ElevatedButton(
                                onPressed: () {
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
                                      Size(80.0, 20.0)), // Adjust button size
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 15,)
        ],
      )
    );
  }
}
