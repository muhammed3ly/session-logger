import 'package:flutter/material.dart';
import '../models/user.dart';

class UsersProvider extends ChangeNotifier {
  User user;

  set setUser(User u) {
    user = u;
  }
}
