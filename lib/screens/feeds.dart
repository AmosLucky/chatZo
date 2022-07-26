import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/Utils/dimensions.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/resources/auth_methods.dart';
import 'package:social_app/resources/firestore_methods.dart';
import 'package:social_app/screens/friends.dart';
import 'package:social_app/widgets/post_card.dart';

import '../models/User.dart';
import '../providers/user_provider.dart';

class Feeds extends StatefulWidget {
  const Feeds({Key? key}) : super(key: key);

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  User? user;
  bool isLoading = false;
  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  getUser() async {
    isLoading = true;
    user = await FirestoreMethod()
        .getUserById(auth.FirebaseAuth.instance.currentUser!.uid);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: size.width > webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      appBar: size.width > webScreenSize
          ? null
          : AppBar(
              title: Text(
                "ChatZo",
                style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
              ),
              // title: SvgPicture.network(
              //   "assets/images/ic_instagram.svg",
              //   color: primaryColor,
              //   height: 32,
              // ),
              actions: [
                IconButton(
                    onPressed: () {
                      var route = MaterialPageRoute(
                          builder: (BuildContext) => FriendList());
                      Navigator.push(context, route);
                    },
                    icon: Icon(Icons.message))
              ],
            ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .orderBy("datePublished", descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal:
                              size.width > webScreenSize ? size.width * 0.3 : 0,
                          vertical: size.width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCard(
                            user: user!,
                            post:
                                Post.fromDocument(snapshot.data!.docs[index])),
                      );
                    });
              },
            ),
    );
  }
}
