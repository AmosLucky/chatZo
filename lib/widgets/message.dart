import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MessageWidget extends StatelessWidget {
  var data;
  var currentUserId;
  MessageWidget({Key? key, required this.data, required this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,

        // ignore: prefer_const_constructors
        child: Row(
          mainAxisAlignment: data['sender'] == currentUserId
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 2.3,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 28, 27, 27),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                // height: 30,
                child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: data['sender'] == currentUserId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['message'],
                        textAlign: data['sender'] == currentUserId
                            ? TextAlign.end
                            : TextAlign.start,
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}
