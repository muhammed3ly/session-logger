import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
import 'package:sessions_logger/providers/preferences.dart';
import 'package:sessions_logger/providers/screen_provider.dart';
import 'package:sessions_logger/providers/users_provider.dart';
import 'package:sessions_logger/screens/splash_screen.dart';
import 'package:sessions_logger/widgets/mainScreens/explore_screen.dart';
import 'package:sessions_logger/widgets/mainScreens/home_screen.dart';
import 'package:sessions_logger/widgets/mainScreens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading;
  bool _preparingData;
  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _preparingData = true;
  }

  void loading({int idx = -1}) {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> prepareData() async {
    final userID = Provider.of<UsersProvider>(context).user.userID;
    final userData =
        await Firestore.instance.collection('users').document(userID).get();

    if (userData.exists) {
      Provider.of<UsersProvider>(context, listen: false)
          .changeUsername(userData.data['username']);
      Provider.of<Preferences>(context, listen: false).setAutoAcceptInvitations(
        userData.data['autoAcceptInvitations'],
        Provider.of<UsersProvider>(context, listen: false).user.userID,
        updateDB: false,
      );
      Provider.of<Preferences>(context, listen: false).setThemePreference(
        (userData.data['themePreference'] == 'light')
            ? ThemePreference.Light
            : ThemePreference.Dark,
        userID,
        updateDB: false,
      );
      await Provider.of<GroupsProvider>(context, listen: false)
          .fetchMyGroups(userID);
    } else {
      await Firestore.instance.collection('users').document(userID).setData({
        'username': Provider.of<UsersProvider>(context, listen: false)
            .user
            .email
            .split('@')[0],
        'autoAcceptInvitations': false,
        'themePreference':
            Provider.of<Preferences>(context, listen: false).themePreference ==
                    ThemePreference.Light
                ? 'light'
                : 'dark'
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_preparingData) {
      await prepareData();
      setState(() {
        _preparingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _preparingData
        ? SplashScreen()
        : Stack(
            children: <Widget>[
              DefaultTabController(
                length: 3,
                initialIndex: Provider.of<ScreenProvider>(context).screenIndex,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      Provider.of<UsersProvider>(context, listen: false)
                          .user
                          .username,
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: <Widget>[
                      IconButton(
                        tooltip: 'Add Log',
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                    bottom: TabBar(
                      onTap: (index) {
                        Provider.of<ScreenProvider>(context, listen: false)
                            .changeScreen(index);
                      },
                      tabs: <Widget>[
                        Tab(
                          child: Text('Home',
                              style: TextStyle(color: Colors.white)),
                        ),
                        Tab(
                          child: Text('Explore',
                              style: TextStyle(color: Colors.white)),
                        ),
                        Tab(
                          child: Text('Settings',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      HomeScreen(),
                      ExploreScreen(),
                      SettingsScreen(loading),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.9),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
            ],
          );
  }
}
