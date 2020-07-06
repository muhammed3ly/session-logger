import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePasswordSheet extends StatefulWidget {
  final Function _changePassword;
  ChangePasswordSheet(this._changePassword);

  @override
  _ChangePasswordSheetState createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController _password;
  FocusNode confirmPasswordNode;
  bool registering = false;
  final borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  );

  void _tryChanging() {
    if (_form.currentState.validate()) {
      widget._changePassword(_password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 10,
      ),
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Material(
                elevation: 2,
                child: TextFormField(
                  controller: _password,
                  onFieldSubmitted: (value) {
                    confirmPasswordNode.requestFocus();
                  },
                  validator: (value) {
                    RegExp reg =
                        RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
                    if (!reg.hasMatch(value)) {
                      return 'Password must contains at least eight characters, at least one letter and one number';
                    }
                    return null;
                  },
                  obscureText: true,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
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
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Material(
                elevation: 2,
                child: TextFormField(
                  focusNode: confirmPasswordNode,
                  onFieldSubmitted: registering ? null : (_) => _tryChanging(),
                  validator: (value) {
                    if (value != _password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: true,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
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
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FlatButton.icon(
                color: Colors.white,
                icon: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: _tryChanging,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
