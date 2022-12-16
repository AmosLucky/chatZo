import 'package:flutter/cupertino.dart';
import 'package:social_app/resources/auth_methods.dart';

import '../models/User.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods authMethods = AuthMethods();
  User? _user;
  User? _currentFriend;
  User get getCurrentFriend => _currentFriend!;
  User get getUser => _user!;
  Future<void> setCurrentFriend(String friendId) async {
    _currentFriend = await authMethods.getFriendData(friendId);
    notifyListeners();
  }

  Future<void> refreshUser() async {
    User user = await authMethods.getUserData();
    _user = user;
    notifyListeners();
  }
}
