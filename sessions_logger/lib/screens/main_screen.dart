import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/providers/preferences.dart';
import 'package:sessions_logger/providers/users_provider.dart';
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
  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  void loading({int idx = -1}) {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<Preferences>(context, listen: false).themePreference);
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 3,
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
                tabs: <Widget>[
                  Tab(
                    child: Text('Home', style: TextStyle(color: Colors.white)),
                  ),
                  Tab(
                    child:
                        Text('Explore', style: TextStyle(color: Colors.white)),
                  ),
                  Tab(
                    child:
                        Text('Settings', style: TextStyle(color: Colors.white)),
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
