import 'package:datingapp/src/features/splash.dart';
import 'package:datingapp/src/schedule/girl/home_schedule.dart';
import 'package:datingapp/src/utils/async_value_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends ConsumerStatefulWidget {
   const NavBar({
    Key? key,
    required this.u_email, required this.u_name, required this.u_photo
  }) : super(key: key);

  final String u_email;
  final String u_name;
  final String u_photo;
  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {

  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // UserAccountsDrawerHeader(
                //   accountName: Text('${widget.u_name}'),
                //   accountEmail: Text('${widget.u_email}'),
                //   currentAccountPicture: CircleAvatar(
                //     child: ClipOval(
                //       child: Image.network(
                //         'http://43.207.77.181/uploads/image/${widget.u_photo}',
                //         fit: BoxFit.cover,
                //         width: 90,
                //         height: 90,
                //       ),
                //     ),
                //   ),
                //   decoration: BoxDecoration(
                //     color: Color.fromARGB(255, 155, 110, 124),
                //   ),
                // ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Stack(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 155, 110, 124),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: 0, bottom: 35, left: 10, right: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(padding: EdgeInsets.only(left: 0),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                border: Border.all(color: Colors.black45),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(50),
                                                child: Image.network(
                                                  "http://43.207.77.181/uploads/image/${widget.u_photo}",
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
                                          ),
                                          Padding(padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              "${widget.u_name}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),]
                        )
                      )
                    ],
                  )
                ),

                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('出勤予定を登録'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScheduleScreen(),
                      ));
                  },
                ),
                Divider(),
                // ListTile(
                //   leading: Icon(Icons.notifications),
                //   title: Text('通知'),
                //   onTap: () => null,
                //   trailing: ClipOval(
                //     child: Container(
                //       color: Colors.red,
                //       width: 20,
                //       height: 20,
                //       child: Center(
                //         child: Text(
                //           '8',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 12,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Divider(),
              ],
            ),
          ),
          ListTile(
            title: Text('サインアウト'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async{
              showDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  content: const Text('ログアウトしますか？',
                      style: TextStyle(fontSize: 16)),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool("isLogin", false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                            ));
                        },
                        child: const Text('ログアウト',
                            style:
                                TextStyle(fontSize: 15))),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('キャンセル',
                          style: TextStyle(fontSize: 15)),
                    )
                  ],
                ));
            },
          ),
        ],
      ),
    );
  }
}