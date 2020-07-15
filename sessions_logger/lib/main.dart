import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/models/user.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
import 'package:sessions_logger/providers/preferences.dart';
import 'package:sessions_logger/providers/screen_provider.dart';
import 'package:sessions_logger/providers/users_provider.dart';
import 'package:sessions_logger/screens/authentcication_screen.dart';
import 'package:sessions_logger/screens/create_group_screen.dart';
import 'package:sessions_logger/screens/group_screen.dart';
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
        ChangeNotifierProvider(create: (_) => GroupsProvider()),
        ChangeNotifierProvider(create: (_) => ScreenProvider()),
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
                      return MainScreen();
                    } else {
                      return AuthenticationScreen();
                    }
                  });
            },
          ),
          routes: {
            SplashScreen.routeName: (ctx) => SplashScreen(),
            CreateGroupScreen.routeName: (ctx) => CreateGroupScreen(),
            GroupScreen.routeName: (ctx) => GroupScreen(),
          },
        ),
      ),
    );
  }
}
