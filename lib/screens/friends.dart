import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_app/models/User.dart';
import 'package:social_app/resources/firestore_methods.dart';
import 'package:social_app/screens/chat_screen.dart';
import 'package:social_app/screens/search_friends.dart';
import 'package:social_app/widgets/user_widget.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
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
            title: Container(
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onTap: () {
              var route =
                  MaterialPageRoute(builder: (BuildContext) => SearchFriends());
              Navigator.push(context, route);
            },
            child: Container(
                child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(
                  width: 50,
                ),
                Text(
                  "Search user",
                  style: TextStyle(fontSize: 15),
                )
              ],
            )),
          ),
        )),
        body: friendList());
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
                child: Text(
                    "You dont have any friend.\nPlease search for a friend to start chatting"))
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
