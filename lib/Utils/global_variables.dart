import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/User.dart';
import 'package:social_app/screens/add_post.dart';
import 'package:social_app/screens/friends.dart';
import 'package:social_app/screens/feeds.dart';
import 'package:social_app/screens/profile.dart';
import 'package:social_app/screens/search.dart';

var homeScreenItems = [
  Feeds(),
  // Search(),
  AddPost(),
  FriendList(),
  Profile(where: "profile")
];

var appName = "SwisChat";
