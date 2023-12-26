import 'dart:math';
import 'dart:async';

import 'package:datingapp/src/features/auth/login_screen.dart';
import 'package:datingapp/src/features/home/article_data.dart';
import 'package:datingapp/src/features/home/profile_info.dart';
import 'package:datingapp/src/features/post_detail/post_detail.dart';
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
import '../user_profile/gentle_profile.dart';
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

class HomeCardScreen extends ConsumerStatefulWidget {
  const HomeCardScreen({
    Key? key,
    required this.login_id,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final String login_id;
  final ArticleData info;
  final VoidCallback onPressed;
  @override
  ConsumerState<HomeCardScreen> createState() => _HomeCardScreenState();
}

class _HomeCardScreenState extends ConsumerState<HomeCardScreen> {

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArticleData InfoConvert = widget.info;
    String content = InfoConvert.content;
    String displayText = content.length > 22 ? content.substring(0, 22) + "..." : content;

    return Padding(padding:EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white, // Change the color of the rectangle
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 10,
                  child: InkWell(
                    onTap: () {
                      InfoConvert.bar_id == "0"?
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GentleProfile(article_id: InfoConvert.article_id, login_id: widget.login_id),
                        )
                      ):
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(article_id: InfoConvert.article_id, login_id: widget.login_id),
                        ));
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
                        
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              InfoConvert.user_name,  // Add the text you want to display
                              style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                              fontSize: 18),
                            ),
                            Container(
                              child :Row(children: [
                                Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                Text(
                                  '${InfoConvert.residence}',  // Add the text you want to display
                                  style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                  fontSize: 10),
                                ),
                                const SizedBox(width: 10,),
                                const Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 155, 110, 124)),
                                Text(
                                  '${InfoConvert.add_location}',  // Add the text you want to display
                                  style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                                  fontSize: 10),
                                ),
                              ],)
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(a_id : InfoConvert.article_id),
                        ));
                    },
                    child: Image.network(
                      "http://43.207.77.181/uploads/post_image/" + InfoConvert.photo1,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailScreen(a_id : InfoConvert.article_id),
                            ));
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
                            '${InfoConvert.article_count}',  // Add the text you want to display
                            style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                            fontSize: 12),
                          ),
                          const SizedBox(width: 10,),
                          const Icon(Icons.favorite, size: 20, color: Color.fromARGB(255, 155, 110, 124)),
                          const SizedBox(width: 5,),
                          Text(
                            '${InfoConvert.following_count}',  // Add the text you want to display
                            style: const TextStyle(color: Color.fromARGB(255, 155, 110, 124),
                            fontSize: 12),
                          ),
                        ],)
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
          SizedBox(height: 20,)
        ],
      ) 
    );
  }
}
