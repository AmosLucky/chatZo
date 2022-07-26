import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String photoUrl;
  final String postId;
  final String description;
  final datePublished;

  final String profileImage;
  final likes;
  Post(
      {required this.uid,
      required this.username,
      required this.photoUrl,
      required this.postId,
      required this.datePublished,
      required this.profileImage,
      required this.description,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "photoUrl": photoUrl,
        "postId": postId,
        "datePublished": datePublished,
        "profileImage": profileImage,
        "description": description,
        "likes": likes
      };

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      uid: doc["uid"],
      username: doc["username"],
      photoUrl: doc["photoUrl"],
      postId: doc["postId"],
      datePublished: doc["datePublished"],
      description: doc["description"],

      profileImage: doc["profileImage"],
      likes: doc["likes"],

      //////////////////insta
    );
  }
}
