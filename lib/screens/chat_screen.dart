import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/User.dart';

import '../Utils/utils.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../widgets/comment_card.dart';
import '../widgets/message.dart';

class ChatScreen extends StatefulWidget {
  User receiver;
  ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  String chatId = "";
  String currentUserId = "";
  String receiverId = "";
  final ScrollController scrollController = ScrollController();

  User? receiver;
  init() {
    currentUserId = auth.FirebaseAuth.instance.currentUser!.uid;
    receiver = widget.receiver;
    receiverId = receiver!.uid;

    if (currentUserId.hashCode <= receiverId.hashCode) {
      chatId = '$currentUserId-$receiverId';
    } else {
      chatId = '$receiverId-$currentUserId';
    }
    print(chatId);
  }

  @override
  void initState() {
    init();
    scrollController.addListener((_scrollListerner));
    // TODO: implement initState
    super.initState();
  }

  int _limit = 28;
  int _limitIncrement = 28;

  _scrollListerner() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        leading: Container(),
        title: Row(children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.receiver.photoUrl)),
          ),
          Text(widget.receiver.username)
        ]),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(chatId)
            .collection("messages")
            .orderBy("time", descending: true)
            .limit(_limit)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var data = (snapshot.data! as dynamic).docs;

          return data.length == 0
              ? Center(child: Text("Be first to say hi"))
              : ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  controller: scrollController,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    // print(index);
                    return MessageWidget(
                      data: data[index],
                      currentUserId: currentUserId,
                    );
                    // return CommentCard(
                    //     snapshot: (snapshot.data! as dynamic).docs[index]);
                  });
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(children: [
          // CircleAvatar(
          //   backgroundImage: NetworkImage(user.photoUrl),
          // ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: TextFormField(
              controller: messageController,
              decoration:
                  InputDecoration(labelText: "Write", border: InputBorder.none),
            ),
          )),
          InkWell(
            onTap: () {
              if (messageController.text.trim().isEmpty) {
                showSnackBar("Null message", context);
                return;
              }
              //print("lll");
              FirestoreMethod().postMessage(
                  currentUser: currentUser,
                  chatId: chatId,
                  receiver: widget.receiver,
                  sender: currentUserId,
                  message: messageController.text);
              messageController.text = "";
              scrollController.animateTo(0,
                  duration: Duration(microseconds: 300), curve: Curves.easeOut);
              // setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Icon(Icons.send),
            ),
          )
        ]),
      )),
    );
  }
}
