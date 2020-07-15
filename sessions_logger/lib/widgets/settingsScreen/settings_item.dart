import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsItem extends StatelessWidget {
  final IconData iconData, actionIcon;
  final String title;
  final dynamic data;
  final Function fireAction;
  final bool switchable;
  final bool editable;
  final TextEditingController controller;
  SettingsItem({
    this.iconData,
    @required this.title,
    @required this.fireAction,
    this.editable = false,
    this.controller,
    this.switchable = false,
    this.data,
    this.actionIcon = FontAwesomeIcons.edit,
  }) : assert((editable && controller != null) ||
            (!editable && controller == null));

  final borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  );
  Widget textFieldBuilder(BuildContext context) {
    return Material(
      elevation: 2,
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: (value) {
          //passwordNode.requestFocus();
        },
        validator: (value) {
          if (value.isEmpty || value.length < 3 || value.contains(' ')) {
            return 'Please enter at least 3 characters with no spaces';
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
          suffixIcon:
              IconButton(icon: Icon(Icons.cancel), onPressed: fireAction),
          filled: true,
          fillColor: Colors.white,
          border: borderStyle,
          enabledBorder: borderStyle,
          errorBorder: borderStyle,
          focusedBorder: borderStyle,
          disabledBorder: borderStyle,
          focusedErrorBorder: borderStyle,
          errorMaxLines: 2,
          hintText: data,
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: iconData == null
          ? null
          : Icon(
              iconData,
              color: Theme.of(context).accentColor,
              size: 35 * MediaQuery.of(context).textScaleFactor,
            ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).accentColor,
        ),
      ),
      subtitle: data == null || switchable
          ? null
          : !editable
              ? Text(
                  data as String,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                )
              : textFieldBuilder(context),
      trailing: switchable
          ? Switch.adaptive(
              value: data as bool,
              activeColor: Colors.green,
              onChanged: fireAction,
            )
          : IconButton(
              icon: Icon(
                editable ? FontAwesomeIcons.solidSave : actionIcon,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                if (editable) {
                  if (controller.text.length < 3 ||
                      controller.text.length > 12 ||
                      controller.text.contains(' ')) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Username length must be between 3 and 12 without spaces',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    fireAction(user: controller.text);
                  }
                } else {
                  fireAction();
                }
              },
            ),
    );
  }
}
