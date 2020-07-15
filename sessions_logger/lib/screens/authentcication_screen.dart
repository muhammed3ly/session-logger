import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sessions_logger/widgets/authScreen/login.dart';
import 'package:sessions_logger/widgets/authScreen/register.dart';

enum AuthMode { Login, Register }

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  void _flip() {
    if (_animationStatus == AnimationStatus.dismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                child: Text(
                  'SESSIONS\nLOGGER',
                  style: TextStyle(
                      fontFamily: 'Century',
                      fontWeight: FontWeight.bold,
                      fontSize:
                          30 * MediaQuery.of(context).textScaleFactor * 1.2,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateX(pi * _animation.value),
                child: _animation.value <= 0.5
                    ? LoginCard(_flip)
                    : RegisterCard(_flip),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
