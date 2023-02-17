import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_app/models/User.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class FirestoreMethod {
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Some error occured";
    try {
      String postId = const Uuid().v1();
      String photoUrl = await StorageMethod().uploadImage("posts", file, true);
      Post post = Post(
          uid: uid,
          username: username,
          photoUrl: photoUrl,
          postId: postId,
          description: description,
          datePublished: DateTime.now(),
          profileImage: profileImage,
          likes: []);
      _firebaseFirestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String result;
    try {
      String commentId = Uuid().v1();
      if (text.isNotEmpty) {
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "postId": postId,
          "comment": text,
          "datePublished": DateTime.now()
        });
        result = "success";
      } else {
        result = "";
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> deletePost(String postId) async {
    String result = "";
    try {
      await FirebaseFirestore.instance.collection("posts").doc(postId).delete();
      result = "success";
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  Future<User> getUserById(String id) async {
    var snap =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    // print(snap['usernmae']);
    return User.fromDocument(snap);
  }

  Future<int> posLenght(String id) async {
    var snaps = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: id)
        .get();

    return snaps.docs.length;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      var snap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];

      if (following.contains(followId)) {
        await _firebaseFirestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firebaseFirestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firebaseFirestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firebaseFirestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postMessage(
      {required String chatId,
      required User receiver,
      required String sender,
      required String message,
      required User currentUser}) async {
    var time = DateTime.now();
    var snap = await _firebaseFirestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc()
        .set({
      "receiver": receiver.uid,
      "sender": sender,
      "message": message,
      "time": time,
      "timestamp": DateTime.now().microsecondsSinceEpoch.toString()
    });

    updateFriends(receiver.uid, sender, message, currentUser, receiver);
  }

  Future<void> updateFriends(String friendId, String userId, String last_messge,
      User currenUser, User reciever) async {
    var snap = await _firebaseFirestore
        .collection("users")
        .doc(userId)
        .collection("friends")
        .doc(friendId)
        .set({
      "photoUrl": reciever.photoUrl,
      "username": reciever.username,
      "friendId": friendId,
      "last_message": last_messge,
      "time": DateTime.now()
    });

    var snap2 = await _firebaseFirestore
        .collection("users")
        .doc(friendId)
        .collection("friends")
        .doc(userId)
        .set({
      "photoUrl": currenUser.photoUrl,
      "username": currenUser.username,
      "friendId": userId,
      "last_message": last_messge,
      "time": DateTime.now()
    });
  }
}
