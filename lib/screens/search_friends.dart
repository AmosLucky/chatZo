import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_app/screens/chat_screen.dart';
import 'package:social_app/widgets/user_widget.dart';

import '../models/User.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({Key? key}) : super(key: key);

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool isSearch = false;
  String currentUserId = "";
  @override
  void initState() {
    currentUserId = auth.FirebaseAuth.instance.currentUser!.uid;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextFormField(
        autofocus: true,
        controller: searchController,
        decoration:
            InputDecoration(labelText: "Search user", border: InputBorder.none),
        onFieldSubmitted: (text) {
          setState(() {
            isSearch = true;
          });
        },
      )),
      body: Container(
          child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("username", isGreaterThanOrEqualTo: searchController.text)
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
                if (user.uid == currentUserId) {
                  return Container();
                }
                return ListTile(
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (BuildContext) => ChatScreen(receiver: user));
                    Navigator.push(context, route);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data[index]["photoUrl"]),
                  ),
                  title: Text(data[index]["username"]),
                  subtitle: Text(data[index]["bio"]),
                );
              });
        },
      )),
    );
  }

  friendList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .collection("friends")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        var data = (snapshot.data! as dynamic).docs;

        return data.length == 0
            ? Center(
                child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.search),
                  ),
                  Text(
                      "You dont have any friend yet.\nPlease search for a friend to start chatting"),
                ],
              ))
            : ListView.builder(
                shrinkWrap: true,
                //reverse: true,
                // controller: scrollController,
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  // print(index);
                  return UserWidget(data: data[index]);
                  // return CommentCard(
                  //     snapshot: (snapshot.data! as dynamic).docs[index]);
                });
      },
    );
  }
}
