import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
import 'package:sessions_logger/providers/preferences.dart';
import 'package:sessions_logger/providers/users_provider.dart';

class CreateGroupScreen extends StatefulWidget {
  static const String routeName = '/ceate_group';
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  GlobalKey<FormState> _form;
  GlobalKey<ScaffoldState> globalKey;
  TextEditingController _groupName, _invitationCode, _groupDescription;
  FocusNode _desc;
  File _pickedImage;
  ImagePicker picker;
  bool _loading;
  final borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  );
  @override
  void initState() {
    super.initState();
    _form = GlobalKey<FormState>();
    _groupName = TextEditingController();
    _invitationCode = TextEditingController();
    _groupDescription = TextEditingController();
    picker = ImagePicker();
    _loading = false;
    globalKey = GlobalKey<ScaffoldState>();
    _desc = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _groupName.dispose();
    _invitationCode.dispose();
    _groupDescription.dispose();
    _desc.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void tryAddGroup() async {
    if (_form.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        String codeVerification =
            await Provider.of<GroupsProvider>(context, listen: false)
                .verifyCode(_invitationCode.text);
        if (codeVerification != 'Verified') {
          globalKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                'This invitation code already exists',
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
          return;
        }
        await Provider.of<GroupsProvider>(context, listen: false).addGroup(
          _groupName.text,
          _groupDescription.text,
          _invitationCode.text,
          _pickedImage,
          Provider.of<UsersProvider>(context).user.userID,
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
      } on PlatformException catch (error) {
        globalKey.currentState.showSnackBar(
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
        setState(() {
          _loading = false;
        });
      } catch (error) {
        globalKey.currentState.showSnackBar(
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
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Group'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        elevation: 2,
                        child: TextFormField(
                          controller: _groupName,
                          onFieldSubmitted: (value) {
                            _desc.requestFocus();
                          },
                          validator: (value) {
                            if (value.isEmpty ||
                                value.length < 3 ||
                                value.length > 30) {
                              return 'Group name should contains between 3 and 30 characters';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize:
                                14 * MediaQuery.of(context).textScaleFactor,
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
                            labelText: 'Group Name',
                            labelStyle: TextStyle(
                              color: Provider.of<Preferences>(context)
                                          .themePreference ==
                                      ThemePreference.Light
                                  ? Theme.of(context).accentColor
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        elevation: 2,
                        child: TextFormField(
                          controller: _groupDescription,
                          focusNode: _desc,
                          validator: (value) {
                            print(value.length);
                            if (value.isEmpty ||
                                value.length < 3 ||
                                value.length > 1000) {
                              return 'Group description should contains between 3 and 500 characters';
                            }
                            return null;
                          },
                          maxLines: 12,
                          minLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize:
                                14 * MediaQuery.of(context).textScaleFactor,
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),
                            labelText: 'Group Description',
                            labelStyle: TextStyle(
                              color: Provider.of<Preferences>(context)
                                          .themePreference ==
                                      ThemePreference.Light
                                  ? Theme.of(context).accentColor
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        elevation: 2,
                        child: TextFormField(
                          controller: _invitationCode,
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
                            fontSize:
                                14 * MediaQuery.of(context).textScaleFactor,
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          textInputAction: TextInputAction.done,
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
                            labelText:
                                'Invitation Code (Invite users by this code)',
                            labelStyle: TextStyle(
                              color: Provider.of<Preferences>(context)
                                          .themePreference ==
                                      ThemePreference.Light
                                  ? Theme.of(context).accentColor
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: getImage,
                  child: Stack(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _pickedImage == null
                                ? Image.asset(
                                    'assets/images/all-group-placeholder.jpg',
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(
                                    _pickedImage,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                            ),
                            color: Colors.black54,
                          ),
                          child: Text(
                            'Press to pick a group photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_loading) CircularProgressIndicator(),
                if (!_loading)
                  FlatButton.icon(
                    color: Theme.of(context).accentColor,
                    icon: Icon(
                      Icons.add_circle,
                      color:
                          Provider.of<Preferences>(context).themePreference ==
                                  ThemePreference.Light
                              ? Colors.white
                              : Colors.black,
                    ),
                    label: Text(
                      'Create Group',
                      style: TextStyle(
                        color:
                            Provider.of<Preferences>(context).themePreference ==
                                    ThemePreference.Light
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                    onPressed: tryAddGroup,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
