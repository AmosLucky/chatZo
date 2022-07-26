import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Utils/utils.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/resources/firestore_methods.dart';

import '../models/User.dart';
import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class Comment extends StatefulWidget {
  Post post;
  Comment({Key? key, required this.post}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController commentCTR = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: TextFormField(
              controller: commentCTR,
              decoration: InputDecoration(
                  labelText: "Comment as ${user.username}",
                  border: InputBorder.none),
            ),
          )),
          InkWell(
            onTap: () {
              if (commentCTR.text.trim().isEmpty) {
                showSnackBar("Null message", context);
                return;
              }
              FirestoreMethod().postComment(widget.post.postId, commentCTR.text,
                  user.uid, user.username, user.photoUrl);
              commentCTR.text = "";
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Icon(Icons.send),
            ),
          )
        ]),
      )),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.post.postId)
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                print(index);
                return CommentCard(
                    snapshot: (snapshot.data! as dynamic).docs[index]);
              });
        },
      ),
    );
  }
}
