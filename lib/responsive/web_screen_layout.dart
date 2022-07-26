import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/Utils/colors.dart';

import '../Utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;

  late PageController pageController;

  navigationTapped(int index) {
    pageController.jumpToPage(index);
    setState(() {
      _page = index;
    });
  }

  onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ChatZo",
          style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
        ),
        // title: SvgPicture.asset(
        //   "assets/images/ic_instagram.svg",
        //   color: mobileBackgroundColor,
        //   height: 32,
        // ),
        actions: [
          IconButton(
              onPressed: () {
                navigationTapped(0);
              },
              icon: Icon(Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () {
                navigationTapped(1);
              },
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () {
                navigationTapped(2);
              },
              icon: Icon(Icons.add_a_photo,
                  color: _page == 2 ? primaryColor : secondaryColor)),
          // IconButton(
          //     onPressed: () {
          //       navigationTapped(3);
          //     },
          //     icon: Icon(Icons.favorite,
          //         color: _page == 3 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () {
                navigationTapped(3);
              },
              icon: Icon(Icons.message,
                  color: _page == 3 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () {
                navigationTapped(4);
              },
              icon: Icon(Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor)),
        ],
      ),
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
