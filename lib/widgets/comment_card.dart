import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';
import '../providers/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snapshot;
  const CommentCard({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.snapshot["profilePic"]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: widget.snapshot["name"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(
                          text: " " + widget.snapshot["comment"],
                          style: TextStyle(color: Colors.white))
                    ])),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd()
                            .format(widget.snapshot["datePublished"].toDate()),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    )
                  ]),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.favorite,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
