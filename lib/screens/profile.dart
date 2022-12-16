import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/resources/auth_methods.dart';
import 'package:social_app/resources/firestore_methods.dart';
import 'package:social_app/screens/signin.dart';
import 'package:social_app/widgets/follow_button.dart';

import '../models/User.dart';
import '../providers/user_provider.dart';
import '../widgets/account_delet_dialog.dart';

class Profile extends StatefulWidget {
  final User? user;
  final String where;
  const Profile({Key? key, this.user, this.where = ""}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  bool isFollowing = false;
  int followers = 0;
  int following = 0;
  User? user;
  int postLent = 0;
  getUser() async {
    setState(() {
      isLoading = true;
    });
    if (widget.where == "profile") {
      user = await FirestoreMethod()
          .getUserById(auth.FirebaseAuth.instance.currentUser!.uid);
      // print("profile");
      // user = Provider.of<UserProvider>(context).getUser;

      setState(() {});
    } else {
      user = widget.user;
    }
    postLent = await FirestoreMethod().posLenght(user!.uid);
    isFollowing =
        user!.followers.contains(auth.FirebaseAuth.instance.currentUser!.uid);
    following = user!.following.length;
    followers = user!.followers.length;

    isLoading = false;

    setState(() {});
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(user!.username),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: InkWell(
                      onTap: () {
                        options(context);
                      },
                      child: Icon(Icons.delete)),
                )
              ],
            ),
            body: ListView(children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(user!.photoUrl),
                    radius: 40,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                buildSatColumn(postLent, "post"),
                                buildSatColumn(following, "FolloWing"),
                                buildSatColumn(followers, "Followers"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                user!.uid ==
                                        auth.FirebaseAuth.instance.currentUser!
                                            .uid
                                    ? FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        borderColor: primaryColor,
                                        text: "SignOut",
                                        textColor: Colors.grey,
                                        function: () async {
                                          AuthMethods().signOut();
                                          var route = MaterialPageRoute(
                                              builder: (BuildContext) =>
                                                  SignIn());
                                          Navigator.pushReplacement(
                                              context, route);
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            backgroundColor: Colors.white,
                                            borderColor: primaryColor,
                                            text: "Unfollow",
                                            textColor: Colors.black,
                                            function: () async {
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                              await FirestoreMethod()
                                                  .followUser(
                                                      auth.FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      user!.uid);
                                            },
                                          )
                                        : FollowButton(
                                            backgroundColor: Colors.blue,
                                            borderColor: Colors.blue,
                                            text: "Follow",
                                            textColor: Colors.white,
                                            function: () async {
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                              await FirestoreMethod()
                                                  .followUser(
                                                      auth.FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      user!.uid);
                                            },
                                          ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                user!.username,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: 1),
                              child: Text(
                                user!.bio,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              const Divider(),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where("uid", isEqualTo: user!.uid)
                      .get(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var data = (snapshot.data! as dynamic).docs;

                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1,
                            mainAxisSpacing: 1.5),
                        itemBuilder: (ctx, index) {
                          return Container(
                            child: Image(
                              image: NetworkImage(data[index]["photoUrl"]),
                              fit: BoxFit.cover,
                            ),
                          );
                        });
                  })
            ]),
          );
  }

  Column buildSatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }

  options(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: ListView(
                  shrinkWrap: true,
                  children: ["Delete Account"]
                      .map((e) => InkWell(
                            onTap: () {
                              accountDeleteDialog(context);
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Text(e)),
                          ))
                      .toList()),
            ));
  }
}
