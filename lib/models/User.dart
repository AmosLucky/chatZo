import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String password;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;
  User(
      {required this.uid,
      required this.username,
      required this.email,
      required this.password,
      required this.photoUrl,
      required this.bio,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "password": password,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc["uid"],
      username: doc["username"],
      email: doc["email"],
      password: doc["password"],
      photoUrl: doc["photoUrl"],
      bio: doc["bio"],
      followers: doc["followers"],
      following: doc["following"],

      //////////////////insta
    );
  }
}
