import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference { Light, Dark }

class Preferences extends ChangeNotifier {
  bool _autoAcceptInvitations;
  ThemePreference _themePreference;

  Preferences(this._themePreference, this._autoAcceptInvitations);

  Future<void> setAutoAcceptInvitations(bool pref, String uid,
      {bool updateDB = true}) async {
    if (updateDB) {
      await Firestore.instance.collection('users').document(uid).setData({
        'autoAcceptInvitations': pref,
      }, merge: true);
      _autoAcceptInvitations = pref;
      notifyListeners();
    } else {
      _autoAcceptInvitations = pref;
    }
  }

  bool get autoAcceptInvitations {
    return _autoAcceptInvitations;
  }

  Future<void> setThemePreference(ThemePreference theme, String uid,
      {bool updateDB = true}) async {
    if (updateDB) {
      await Firestore.instance.collection('users').document(uid).setData({
        'themePreference': theme == ThemePreference.Dark ? 'dark' : 'light',
      }, merge: true);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'loggerTheme', theme == ThemePreference.Dark ? 'dark' : 'light');
      _themePreference = theme;
      notifyListeners();
    } else {
      _themePreference = theme;
    }
  }

  ThemePreference get themePreference {
    return _themePreference;
  }
}
