import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/models/user.dart';
import 'package:sessions_logger/providers/users_provider.dart';
import 'package:sessions_logger/screens/authentcication_screen.dart';

import 'helpers/constants.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UsersProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sessions Logger',
        theme: ThemeData(
          primarySwatch: Constants.customColor,
          accentColor: Colors.white,
        ),
        home: Consumer<UsersProvider>(builder: (_, usersProvider, __) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (ctx, userSnapShot) {
                if (userSnapShot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }
                if (userSnapShot.hasData) {
                  usersProvider.setUser =
                      User(userSnapShot.data.email, userSnapShot.data.uid);
                  return HomeScreen();
                } else {
                  return AuthenticationScreen();
                }
              });
        }),
      ),
    );
  }
}
