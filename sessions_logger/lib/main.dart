import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/models/user.dart';
import 'package:sessions_logger/providers/preferences.dart';
import 'package:sessions_logger/providers/users_provider.dart';
import 'package:sessions_logger/screens/authentcication_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/constants.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var _themePreference;
    if (!prefs.containsKey('loggerTheme')) {
      prefs.setString('loggerTheme', 'light');
      _themePreference = ThemePreference.Light;
    } else {
      String theme = prefs.getString('loggerTheme');
      _themePreference =
          theme == 'light' ? ThemePreference.Light : ThemePreference.Dark;
    }
    print(_themePreference);
    runApp(
      ChangeNotifierProvider(
        create: (_) => Preferences(_themePreference, false),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersProvider()),
      ],
      child: Consumer<Preferences>(
        builder: (_, preferencesProvider, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sessions Logger',
          theme: Constants.lightTheme,
          darkTheme: Constants.darkTheme,
          themeMode:
              preferencesProvider.themePreference == ThemePreference.Light
                  ? ThemeMode.light
                  : ThemeMode.dark,
          home: Builder(
            builder: (BuildContext context) {
              return StreamBuilder(
                  stream: FirebaseAuth.instance.onAuthStateChanged,
                  builder: (ctx, userSnapShot) {
                    if (userSnapShot.connectionState ==
                        ConnectionState.waiting) {
                      return SplashScreen();
                    }
                    if (userSnapShot.hasData) {
                      Provider.of<UsersProvider>(context, listen: false)
                              .setUser =
                          User(userSnapShot.data.email, userSnapShot.data.uid);
                      return FutureBuilder(
                          future: Firestore.instance
                              .collection('users')
                              .document(userSnapShot.data.uid)
                              .get(),
                          builder: (_, userDocSnapshot) {
                            if (userDocSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SplashScreen();
                            }
                            if (userDocSnapshot.data.data != null) {
                              Provider.of<UsersProvider>(context, listen: false)
                                  .user
                                  .username = userDocSnapshot.data['username'];
                              Provider.of<Preferences>(context, listen: false)
                                  .setAutoAcceptInvitations(
                                userDocSnapshot.data['autoAcceptInvitations'],
                                Provider.of<UsersProvider>(context,
                                        listen: false)
                                    .user
                                    .userID,
                                updateDB: false,
                              );
                              print(userDocSnapshot.data['themePreference']);
                              Provider.of<Preferences>(context, listen: false)
                                  .setThemePreference(
                                      (userDocSnapshot
                                                  .data['themePreference'] ==
                                              'light')
                                          ? ThemePreference.Light
                                          : ThemePreference.Dark,
                                      userSnapShot.data.uid,
                                      updateDB: false);
                              return MainScreen();
                            } else {
                              print(Provider.of<Preferences>(context,
                                      listen: false)
                                  .themePreference);
                              return FutureBuilder(
                                future: Firestore.instance
                                    .collection('users')
                                    .document(userSnapShot.data.uid)
                                    .setData({
                                  'username': Provider.of<UsersProvider>(
                                          context,
                                          listen: false)
                                      .user
                                      .email
                                      .split('@')[0],
                                  'autoAcceptInvitations': false,
                                  'themePreference': Provider.of<Preferences>(
                                                  context,
                                                  listen: false)
                                              .themePreference ==
                                          ThemePreference.Light
                                      ? 'light'
                                      : 'dark'
                                }),
                                builder: (_, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return SplashScreen();
                                  }
                                  return MainScreen();
                                },
                              );
                            }
                          });
                    } else {
                      return AuthenticationScreen();
                    }
                  });
            },
          ),
        ),
      ),
    );
  }
}
