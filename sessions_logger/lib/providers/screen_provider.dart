import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  int screenIndex = 0;
  void changeScreen(int index) {
    screenIndex = index;
    notifyListeners();
  }
}
