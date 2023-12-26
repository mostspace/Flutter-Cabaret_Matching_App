import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/post_detail/post_controller.dart';
import 'package:datingapp/src/features/post_detail/post_data.dart';
import 'package:datingapp/src/utils/index.dart';
import 'package:datingapp/src/widgets/kind_button.dart';
import 'package:datingapp/src/widgets/login_button.dart';
import 'package:datingapp/src/widgets/logout_button.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../components/header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../auth/auth_controllers.dart';
import '../user_profile/profile_controller.dart';
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

class DetailCardScreen extends ConsumerStatefulWidget {
  const DetailCardScreen({
    Key? key,
    required this.isPermiss,
    required this.aId,
    required this.loginId,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final bool isPermiss;
  final String aId;
  final String loginId;
  final PostData info;
  final VoidCallback onPressed;
  @override
  ConsumerState<DetailCardScreen> createState() => _DetailCardScreenState();
}

class _DetailCardScreenState extends ConsumerState<DetailCardScreen> {

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
    getData();
  }

  void getData() {
    ref.read(profileProvider.notifier).deUserProfileInfoData(widget.aId);
    ref.read(postDataProvider.notifier).doParentData(widget.aId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostData InfoConvert = widget.info;
    String content = InfoConvert.res_content;
    String displayText = content.length > 255 ? content.substring(0, 255) + "..." : content;
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Colors.grey,
          thickness: 1,  
        ),
        InkWell(
          onLongPress: () {
            widget.isPermiss == false?
            widget.loginId == InfoConvert.user_id ?
            Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    content: const Text(
                      '削除しますか？',
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          final controller = ref.read(loginControllerProvider.notifier);
                          controller.doParentArticleData(InfoConvert.parent_id).then(
                            (value) async{
                              // go home only if login success.
                              if (value == true) {
                                getData();
                                Navigator.pop(context);
                              } else {}
                            },
                          );
                        },
                        child: const Text(
                          '削除',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'キャンセル',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  );
                },
              )
            ): Container(): 
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  content: const Text(
                    '削除しますか？',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        final controller = ref.read(loginControllerProvider.notifier);
                        controller.doParentArticleData(InfoConvert.parent_id).then(
                          (value) async{
                            // go home only if login success.
                            if (value == true) {
                              getData();
                              Navigator.pop(context);
                            } else {}
                          },
                        );
                      },
                      child: const Text(
                        '削除',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child:  Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(top:10, left:15, right:0),
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
                          "http://43.207.77.181/uploads/image/" + InfoConvert.user_photo,
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
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${InfoConvert.user_name}", 
                                style: TextStyle(color: Color.fromARGB(255, 155, 110, 124)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: vww(context, 30)),
                                child:  Text("${InfoConvert.created_at}", 
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width /1.4,
                            child: Text("${displayText}", 
                              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 155, 110, 124)),
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                ),
            )
          ),
        )
      ],
    );
  }
}
