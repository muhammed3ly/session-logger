import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
import 'package:sessions_logger/providers/preferences.dart';
import 'package:sessions_logger/providers/users_provider.dart';

class JoinByCode extends StatefulWidget {
  @override
  _JoinByCodeState createState() => _JoinByCodeState();
}

class _JoinByCodeState extends State<JoinByCode> {
  TextEditingController _code;
  OutlineInputBorder borderStyle;
  GlobalKey<FormState> _form;
  bool _loading;
  @override
  void initState() {
    super.initState();
    borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: const BorderRadius.all(
        const Radius.circular(8.0),
      ),
    );
    _code = TextEditingController();
    _form = GlobalKey<FormState>();
    _loading = false;
  }

  @override
  void dispose() {
    super.dispose();
    _code.dispose();
  }

  void _trySendRequest() async {
    if (_form.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        String verification =
            await Provider.of<GroupsProvider>(context, listen: false)
                .verifyCode(_code.text);

        if (verification == 'Verified') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No group exists with this code',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          String userID = Provider.of<UsersProvider>(context).user.userID;
          if (verification.split('~')[1] != userID) {
            await Provider.of<GroupsProvider>(context, listen: false)
                .sendRequest(verification.split('~')[0], userID);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Request Sent',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'You can\'t ask to join your own group',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        if (mounted) {
          setState(() {
            _loading = false;
            _code.clear();
          });
        }
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
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      } catch (error) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _form,
              child: Material(
                elevation: 2,
                child: TextFormField(
                  controller: _code,
                  onFieldSubmitted: (value) => _trySendRequest(),
                  validator: (value) {
                    if (value.isEmpty ||
                        value.length < 3 ||
                        value.length > 30 ||
                        value.contains(' ')) {
                      return 'Invitation Code should contains between 3 and 30 characters without spaces';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 6,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: borderStyle,
                    enabledBorder: borderStyle,
                    errorBorder: borderStyle,
                    focusedBorder: borderStyle,
                    disabledBorder: borderStyle,
                    focusedErrorBorder: borderStyle,
                    errorMaxLines: 2,
                    labelText: 'Invitation Code',
                    labelStyle: TextStyle(
                      color:
                          Provider.of<Preferences>(context).themePreference ==
                                  ThemePreference.Light
                              ? Theme.of(context).accentColor
                              : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (_loading) CircularProgressIndicator(),
            if (!_loading)
              FlatButton.icon(
                color: Theme.of(context).accentColor,
                icon: Icon(
                  Icons.send,
                  color: Provider.of<Preferences>(context).themePreference ==
                          ThemePreference.Light
                      ? Colors.white
                      : Colors.black,
                ),
                label: Text(
                  'Send Request',
                  style: TextStyle(
                    color: Provider.of<Preferences>(context).themePreference ==
                            ThemePreference.Light
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                onPressed: _trySendRequest,
              ),
          ],
        ),
      ),
    );
  }
}
