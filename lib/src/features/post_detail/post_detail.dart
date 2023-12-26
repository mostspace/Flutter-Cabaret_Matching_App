import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/home/home_card.dart';
import 'package:datingapp/src/features/post_detail/post_controller.dart';
import 'package:datingapp/src/utils/async_value_ui.dart';
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
import 'package:grouped_list/grouped_list.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:popover/popover.dart';
import '../../components/header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/slider_bar.dart';
import '../auth/auth_controllers.dart';
import '../home/home_controller.dart';
import '../home/home_screen.dart';
import '../user_profile/profile_controller.dart';
import '../user_profile/profile_repository.dart';
import 'detail_card.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({
    Key? key,
    required this.a_id,
  }) : super(key: key);

  final String a_id;
  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {

  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final int _currentIndex = 0;
  String email = "";
  String name = "";
  String photo = "";
  String loginId = "";
  bool isLoading = false;
  bool personArticle = false;
  final response_data = TextEditingController();
  String? displayText;
  String get res_data => response_data.text;
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
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });
    getData();
  }

  void submit() {
    String msg = response_data.text;
    response_data.clear();
    final controller = ref.read(loginControllerProvider.notifier);
    controller.doResArticleData(widget.a_id, msg).then(
      (value) async{
        // go home only if login success.
        if (value == true) {
          getData();
        } else {}
      },
    );
  }

  void getData() async{
    // get main article data
    ref.read(profileProvider.notifier).deUserProfileInfoData(widget.a_id);

    // get parent article data
    ref.read(postDataProvider.notifier).doParentData(widget.a_id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginId = await prefs.getString("login_id")!;
    email = await prefs.getString("login_email")!;
    name = await prefs.getString("login_name")!;
    photo = await prefs.getString("login_photo")!;
  }

  void backBtn() {
    ref.read(profileProvider.notifier).deUserProfileInfoData(widget.a_id);
    Navigator.pop(context,true);
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
    //detail info data
    final profile = ref.watch(profileStateChangesProvider).value;

    profile != null?
    displayText = profile!.content.length > 22 ? profile!.content.substring(0, 22) + "..." : profile!.content: displayText = "";

    //detail data
    ref.listen<AsyncValue>(postDataProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(postDataProvider);
    final datas = state.value;

    loginId == profile?.user_id? personArticle = true: personArticle = false;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: NavBar(u_email: email, u_name: name, u_photo: photo),
        backgroundColor: Color.fromARGB(255, 242, 234, 234),
        resizeToAvoidBottomInset: false, // Set this to false
          body: isLoading == false ? 
          Container(
            child: Center(
              child: SizedBox(
                width: 100.0, // Adjust the size of the loading indicator as needed
                height: 100.0,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: _kDefaultRainbowColors,
                  strokeWidth: 4.0,
                ),
              ),
            ),
          ) : SafeArea(
          child: Container(
            child: SizedBox.expand(
              child: FocusScope(
                child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at the start and end of the row
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomeScreen(),
                                      ));
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
                                child: Container(
                                  child: Image.asset(
                                    'assets/images/icon/notification.png',
                                    height: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20,),
                        Padding(padding:EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity, // or provide a specific width
                                height: MediaQuery.of(context).size.height / 2.3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 12,
                                        left: 10,
                                        child: InkWell(
                                          onTap: () {
                                          },
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
                                                    "http://43.207.77.181/uploads/image/" + profile!.user_photo,
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
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        profile.user_name,  // Add the text you want to display
                                                        style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                        fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  
                                                  Container(
                                                    child :Row(children: [
                                                      Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                                      Text(
                                                        '${profile.residence}',  // Add the text you want to display
                                                        style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                        fontSize: 10),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      const Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                                      Text(
                                                        '${profile.add_location}',  // Add the text you want to display
                                                        style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                        fontSize: 10),
                                                      ),
                                                    ],)
                                                  ),
                                                ],
                                              ),
                                              loginId == profile?.user_id ?
                                              Padding(padding: EdgeInsets.only(top: vhh(context, 1), left: vww(context, 35)),
                                                child: InkWell(
                                                  onTap: () async{
                                                    await showMenu(
                                                      context: context,
                                                      position: RelativeRect.fromDirectional(
                                                        textDirection: TextDirection.rtl,
                                                        start: 450,
                                                        top: 150,
                                                        end: 250,
                                                        bottom: 0,
                                                      ),
                                                      items: [
                                                        PopupMenuItem(
                                                          onTap: () {},
                                                          child: Text(
                                                            "編集",
                                                            style: TextStyle(fontSize: 15),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          onTap: () {
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
                                                                          controller.doArticleAllData(profile.article_id).then(
                                                                            (value) async{
                                                                              // go home only if login success.
                                                                              if (value == true) {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => const HomeScreen(),
                                                                                  ));
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
                                                            );
                                                          },
                                                          child: Text(
                                                            "削除",
                                                            style: TextStyle(color: Colors.red, fontSize: 15),
                                                          ),
                                                        ),
                                                      ],
                                                      elevation: 10.0,
                                                    );
                                                  },
                                                  child: Icon(Icons.more_vert, size: 20,color: Colors.grey[500],),
                                                ) 
                                              ):Container()
                                            ],
                                          ),
                                        )
                                      ),
                                      Positioned(
                                        top: 60,
                                        left: 0,
                                        child: InkWell(
                                          onTap: () {
                                          },
                                          child: Image.network(
                                            profile.photo1,
                                            width: MediaQuery.of(context).size.width,
                                            height: 210,
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
                                        )
                                      ),
                                      Positioned(
                                        top: MediaQuery.of(context).size.height / 2.8,
                                        left: 10,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                              },
                                              child: Text(
                                                '${displayText}…',  // Add the text you want to display
                                                style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                fontSize: 14),
                                              ),
                                            ),
                                            
                                            const SizedBox(height: 10,),
                                            Container(
                                              child :Row(children: [
                                                const Icon(Icons.mail, size: 20, color: Color.fromARGB(255, 155, 110, 124)),
                                                const SizedBox(width: 5,),
                                                Text(
                                                  '${profile.article_count}',  // Add the text you want to display
                                                  style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                  fontSize: 12),
                                                ),
                                                const SizedBox(width: 10,),
                                                const Icon(Icons.favorite, size: 20, color: Color.fromARGB(255, 155, 110, 124)),
                                                const SizedBox(width: 5,),
                                                Text(
                                                  '${profile.following_count}',  // Add the text you want to display
                                                  style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                                  fontSize: 12),
                                                ),
                                              ],)
                                            ),
                                          ],
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: () {
                                  if (datas == null || datas.isEmpty) {
                                    return vhh(context, 0);
                                  } else if (datas.length == 1) {
                                    return vhh(context, 10);
                                  } else if (datas.length == 2) {
                                    return vhh(context, 20);
                                  } else {
                                    return vhh(context, 25);
                                  } 
                                }(),
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
                                      return DetailCardScreen(
                                        isPermiss: personArticle,
                                        aId : profile.article_id,
                                        loginId: loginId.toString(),
                                        info: element,
                                        onPressed: () {},
                                      );
                                    },
                                  )
                                : Container(),
                              ),
                              
                              const Divider(
                                height: 1,
                                color: Colors.grey,
                                thickness: 1,  
                              ),
                              
                              Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top:0, left:15, right:15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              color: Colors.white,
                                            ),
                                            child:TextFormField(
                                            maxLines: null,
                                            keyboardType: TextInputType.multiline,
                                            controller: response_data,
                                            textInputAction: TextInputAction.newline,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "コメント",
                                              hintStyle: TextStyle(
                                                  color: Color.fromARGB(255, 193, 192, 201)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(255, 193, 192, 201))),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(255, 193, 192, 201)),
                                              ),
                                              contentPadding: EdgeInsets.all(10),
                                            ),
                                            
                                          ),
                                        )),
                                        SizedBox(
                                          width: 25,
                                          child:  Material(
                                            color: Colors.transparent,
                                            child: IconButton(
                                              icon: const Icon(Icons.send, color: Color.fromARGB(255, 155, 110, 124),),
                                              onPressed: () {
                                                submit();
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                )
                              )
                            ],
                          ) 
                        ),
                      ],
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
