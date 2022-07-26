import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_app/screens/profile.dart';

import '../Utils/dimensions.dart';
import '../models/User.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool isShowUser = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
              labelText: "Search user", border: InputBorder.none),
          onFieldSubmitted: (text) {
            setState(() {
              isShowUser = true;
            });
          },
        )),
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.width > webScreenSize ? size.width * 0.2 : 0,
              vertical: size.width > webScreenSize ? 15 : 0),
          child: isShowUser
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .where("username",
                          isGreaterThanOrEqualTo: searchController.text)
                      .get(),
                  builder: (Ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var data = (snapshot.data! as dynamic).docs;

                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (ctx, index) {
                          User user = User.fromDocument(data[index]);
                          if (user.uid ==
                              auth.FirebaseAuth.instance.currentUser!.uid) {
                            return Container();
                          }
                          return ListTile(
                            onTap: () {
                              var route = MaterialPageRoute(
                                  builder: (BuildContext) =>
                                      Profile(user: user));
                              Navigator.push(context, route);
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data[index]["photoUrl"]),
                            ),
                            title: Text(data[index]["username"]),
                            subtitle: Text("Account"),
                          );
                        });
                  },
                )
              : Container(
                  child: FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection("posts").get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        var data = (snapshot.data! as dynamic).docs;
                        return StaggeredGridView.countBuilder(
                          itemCount: data.length,
                          crossAxisCount: 3,
                          itemBuilder: (ctx, index) {
                            return Image.network(
                              data[index]["photoUrl"],
                              fit: BoxFit.fill,
                            );
                          },
                          staggeredTileBuilder: (index) {
                            return StaggeredTile.count(
                                index % 7 == 0 ? 2 : 1, index % 7 == 0 ? 2 : 1);
                          },
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        );
                      }),
                ),
        ));
  }
}
