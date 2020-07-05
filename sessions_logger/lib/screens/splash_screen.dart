import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              'Loading...',
              style: TextStyle(
                fontFamily: 'Century',
                color: Colors.white,
                fontSize: 16 * MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
