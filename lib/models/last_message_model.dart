import 'package:cloud_firestore/cloud_firestore.dart';

class LastMesageModel {
  String last_message, username, friendId, photoUrl;
  var time;

  LastMesageModel(
      {required this.last_message,
      required this.time,
      required this.username,
      required this.friendId,
      required this.photoUrl});
  factory LastMesageModel.fromDocs(DocumentSnapshot docs) {
    return LastMesageModel(
        last_message: docs['last_message'],
        time: docs['time'],
        username: docs['username'],
        friendId: docs['friendId'],
        photoUrl: docs['photoUrl']);
  }
}
