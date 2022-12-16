import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/Utils/global_variables.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:provider/provider.dart';
// import 'package:social_app/User.dart';
// import 'package:social_app/providers/user_provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  // onPageChanged(int index) {
  //   setState(() {
  //     _page = index;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserProvider>(context).getUser;
    // ignore: prefer_const_constructors
    return Scaffold(
      body: PageView(
        allowImplicitScrolling: false,
        children: homeScreenItems,
        controller: pageController,
      ),
      bottomNavigationBar: 1 == 1
          ? CurvedNavigationBar(
              height: 50,
              backgroundColor: blackColor,
              items: <Widget>[
                Icon(
                  Icons.home,
                  size: 30,
                  color: blueColor,
                ),
                Icon(
                  Icons.add_circle,
                  size: 30,
                  color: blueColor,
                ),
                Icon(
                  Icons.message,
                  size: 30,
                  color: blueColor,
                ),
                Icon(
                  Icons.person,
                  size: 30,
                  color: blueColor,
                ),
              ],
              onTap: (index) {
                navigationTapped(index);
                //Handle button tap
              },
            )
          : CupertinoTabBar(
              backgroundColor: mobileBackgroundColor,
              onTap: navigationTapped,
              items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home,
                          color: _page == 0 ? primaryColor : secondaryColor),
                      label: "",
                      backgroundColor: primaryColor),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search,
                          color: _page == 1 ? primaryColor : secondaryColor),
                      label: "",
                      backgroundColor: primaryColor),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle,
                          color: _page == 2 ? primaryColor : secondaryColor),
                      label: "",
                      backgroundColor: primaryColor),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.message,
                          color: _page == 3 ? primaryColor : secondaryColor),
                      label: "",
                      backgroundColor: primaryColor),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person,
                          color: _page == 4 ? primaryColor : secondaryColor),
                      label: "",
                      backgroundColor: primaryColor),
                ]),
    );
  }
}
