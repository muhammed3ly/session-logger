import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/providers/preferences.dart';
import 'package:sessions_logger/providers/users_provider.dart';
import 'package:sessions_logger/widgets/settingsScreen/change_password_sheet.dart';
import 'package:sessions_logger/widgets/settingsScreen/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  final Function loading;
  SettingsScreen(this.loading);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool usernameEdit, theme;
  TextEditingController _username, _password;
  @override
  void initState() {
    super.initState();
    usernameEdit = false;
    theme = false;
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _password.dispose();
  }

  void _changeUsername({String user = '-1'}) async {
    if (user == '-1') {
      setState(() {
        usernameEdit = !usernameEdit;
      });
    } else {
      try {
        setState(() {
          widget.loading();
        });
        await Provider.of<UsersProvider>(context, listen: false)
            .changeUsername(user);
        setState(() {
          usernameEdit = false;
        });
      } on PlatformException catch (error) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } catch (error) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      widget.loading();
    }
  }

  void _changePassword({String password = '-1'}) async {
    if (password == '-1') {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return ChangePasswordSheet(_changePassword);
          });
    } else {
      try {
        widget.loading();
        await Provider.of<UsersProvider>(context, listen: false)
            .changePassword(password);
      } on PlatformException catch (error) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } catch (error) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      widget.loading();
      Navigator.of(context).pop();
    }
  }

  void _autoAcceptInvitations(bool value) async {
    widget.loading();
    try {
      await Provider.of<Preferences>(context, listen: false)
          .setAutoAcceptInvitations(
        value,
        Provider.of<UsersProvider>(context).user.userID,
      );
    } on PlatformException catch (error) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    widget.loading();
  }

  void _toggleTheme(bool value) {
    if (Provider.of<Preferences>(context, listen: false).themePreference ==
        ThemePreference.Light) {
      Provider.of<Preferences>(context, listen: false).setThemePreference(
          ThemePreference.Dark,
          Provider.of<UsersProvider>(context).user.userID);
    } else {
      Provider.of<Preferences>(context, listen: false).setThemePreference(
          ThemePreference.Light,
          Provider.of<UsersProvider>(context).user.userID);
    }
  }

  void _reportProblem() {}
  void _about() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          Text(
            'My Profile',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SettingsItem(
            iconData: FontAwesomeIcons.solidUserCircle,
            title: 'Username',
            editable: usernameEdit,
            controller: usernameEdit ? _username : null,
            data: Provider.of<UsersProvider>(context).user.username,
            fireAction: _changeUsername,
          ),
          SettingsItem(
            iconData: FontAwesomeIcons.userLock,
            title: 'Change Password',
            fireAction: _changePassword,
          ),
          FlatButton.icon(
            color: Colors.red,
            icon: Icon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.white,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          SizedBox(height: 50),
          Text(
            'Preferences',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SettingsItem(
            title: 'Accept invitations automatically',
            data: Provider.of<Preferences>(context).autoAcceptInvitations,
            switchable: true,
            fireAction: _autoAcceptInvitations,
          ),
          SettingsItem(
            title: 'Dark Theme',
            data: Provider.of<Preferences>(context).themePreference ==
                ThemePreference.Dark,
            switchable: true,
            fireAction: _toggleTheme,
          ),
          FlatButton.icon(
            color: Colors.amber,
            icon: Icon(
              FontAwesomeIcons.bug,
              color: Colors.white,
            ),
            label: Text(
              'Report Problem',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: _reportProblem,
          ),
          FlatButton.icon(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              FontAwesomeIcons.infoCircle,
              color: Colors.white,
            ),
            label: Text(
              'About',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: _about,
          ),
        ],
      ),
    );
  }
}
