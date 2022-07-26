import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/screens/chat_screen.dart';

import '../models/User.dart';
import '../resources/firestore_methods.dart';

class UserWidget extends StatefulWidget {
  var data;
  UserWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  User? user;
  bool isLoading = true;
  getUser() async {
    print(widget.data);
    user = await FirestoreMethod().getUserById(widget.data["friendId"]);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    //print(widget.data);
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: ListTile(
              leading: CircleAvatar(),
              title: Text("####"),
              subtitle: Text("######"),
            ),
          )
        : ListTile(
            onTap: () {
              var route = MaterialPageRoute(
                  builder: (BuildContext) => ChatScreen(receiver: user!));
              Navigator.push(context, route);
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoUrl),
            ),
            title: Text(user!.username),
            subtitle: Text(widget.data["last_message"]),
            trailing:
                Text(DateFormat.MMMd().format(widget.data["time"].toDate())),
          );
  }
}
