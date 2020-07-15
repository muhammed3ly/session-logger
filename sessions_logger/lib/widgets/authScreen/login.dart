import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginCard extends StatefulWidget {
  final Function _flip;
  LoginCard(this._flip);
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  var borderStyle;
  bool loggingIn;
  FocusNode passwordNode;
  GlobalKey<FormState> _formKey;
  TextEditingController _userName, _password;
  @override
  void initState() {
    super.initState();
    borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: const BorderRadius.all(
        const Radius.circular(8.0),
      ),
    );
    passwordNode = FocusNode();
    _formKey = GlobalKey<FormState>();
    _userName = TextEditingController();
    _password = TextEditingController();
    loggingIn = false;
  }

  @override
  void dispose() {
    super.dispose();
    passwordNode.dispose();
    _userName.dispose();
    _password.dispose();
  }

  void login() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        loggingIn = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _userName.text.trim(), password: _password.text);
      } on PlatformException catch (error) {
        setState(() {
          loggingIn = false;
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              error.message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } catch (error) {
        setState(() {
          loggingIn = false;
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              error,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0)
            .add(const EdgeInsets.symmetric(horizontal: 8)),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                child: FittedBox(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20 * MediaQuery.of(context).textScaleFactor,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Material(
                elevation: 2,
                child: TextFormField(
                  controller: _userName,
                  onFieldSubmitted: (value) {
                    passwordNode.requestFocus();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your email address';
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
                    prefixIcon: Icon(
                      FontAwesomeIcons.solidUserCircle,
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
                    hintText: 'Email Address',
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
                  controller: _password,
                  focusNode: passwordNode,
                  onFieldSubmitted: loggingIn ? null : (_) => login(),
                  validator: (value) {
                    RegExp reg =
                        RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
                    if (!reg.hasMatch(value)) {
                      return 'Password must contains at least eight characters, at least one letter and one number';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
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
              loggingIn
                  ? CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    )
                  : FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: login,
                    ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: widget._flip,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          ' Register Now!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
