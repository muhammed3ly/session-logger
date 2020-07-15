import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UsersProvider extends ChangeNotifier {
  User user;

  set setUser(User u) {
    user = u;
  }

  Future<void> changeUsername(String username, {bool updateDB = true}) async {
    if (updateDB) {
      await Firestore.instance
          .collection('users')
          .document(user.userID)
          .setData(
        {
          'username': username,
        },
        merge: true,
      );
    }
    user.username = username;
    notifyListeners();
  }

  Future<void> changePassword(String password) async {
    final user = await FirebaseAuth.instance.currentUser();
    await user.updatePassword(password);
  }
}
