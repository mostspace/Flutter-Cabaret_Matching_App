import 'package:datingapp/src/features/home/home_screen.dart';
import 'package:datingapp/src/features/mail/mail_screen.dart';
import 'package:datingapp/src/features/search/search_screen.dart';
import 'package:flutter/material.dart';

import '../features/add/add_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    void onTabTapped(int index) {
      switch (index) {
        case 0:
          currentIndex == 0? "":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
          break;
        case 1:
          currentIndex == 1? "":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ));
          break;
        case 2:
          currentIndex == 2? "":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScreen(),
            ));
          break;
        case 3:
          currentIndex == 3? "":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MailScreen(),
            ));
          break;
        default:
          break;
      }
    }

    return Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 155, 110, 124),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.white,
          currentIndex: currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Image(
                    image: currentIndex == 0
                        ? const AssetImage("assets/images/navbar_icon/home1.png")
                        : const AssetImage(
                            "assets/images/navbar_icon/home.png"),
                    width: 28),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 1, top: 1),
                  child: Image(
                      image: currentIndex == 1
                          ? const AssetImage(
                              "assets/images/navbar_icon/search1.png")
                          : const AssetImage(
                              "assets/images/navbar_icon/search.png"),
                      width: 28),
                ),
                label: "Search"),
            BottomNavigationBarItem(
                icon: currentIndex == 2
                    ? const Image(
                        image: AssetImage("assets/images/navbar_icon/add1.png"),
                        width: 28)
                    : const Image(
                        image: AssetImage("assets/images/navbar_icon/add.png"),
                        width: 28),
                label: "Add Item"),
            BottomNavigationBarItem(
                icon: Image(
                    image: currentIndex == 3
                        ? const AssetImage(
                            "assets/images/navbar_icon/mail1.png")
                        : const AssetImage(
                            "assets/images/navbar_icon/mail.png"),
                    width: 28),
                label: "Mail"),
          ],
        ));
  }
}
