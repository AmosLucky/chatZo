import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/resources/storage_methods.dart';
import 'package:social_app/models/User.dart' as model;
import 'package:social_app/screens/signin.dart';

import '../constants.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ////method//
  Future<model.User> getUserData() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromDocument(snapshot);
  }

  Future<model.User> getFriendData(String friendId) async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(friendId).get();

    return model.User.fromDocument(snapshot);
  }

  Future<model.User> getUserById(String friendId) async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(friendId).get();

    return model.User.fromDocument(snapshot);
  }

  Future<String> signUp(
      {required String username,
      required String email,
      required String bio,
      required String password,
      required Uint8List file}) async {
    String result = "Some error occoured";
    if (username.isNotEmpty ||
        email.isNotEmpty ||
        bio.isNotEmpty ||
        password.isNotEmpty ||
        file.length < 2) {
      try {
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        ////upload profile pic///
        String photoUrl =
            await StorageMethod().uploadImage("profilePics", file, false);

        /////initialze user//////
        model.User user = model.User(
            uid: userCredential.user!.uid,
            username: username,
            email: email,
            password: password,
            photoUrl: photoUrl,
            bio: bio,
            followers: [],
            following: []);

        ////add user//
        _firebaseFirestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        result = "success";
      } on FirebaseAuthException catch (e) {
        result = e.toString();
      } catch (e) {
        result = e.toString();
      }
    }
    print(result);
    return result;
  }

  ////Logging user///
  ///
  Future<String> signInUser(
      {required String email, required String password}) async {
    String result = "Email or password not correct";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        result = "success";
      } else {
        result = "All feild required";
      }
    } catch (e) {
      result = "Username or password incorrect";
    }
    return result;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  deleteAccount(BuildContext context) async {
    await _firebaseAuth.currentUser!.delete();
    await _firebaseAuth.signOut();
  }
}
