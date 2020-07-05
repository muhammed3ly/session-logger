import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => FirebaseAuth.instance.signOut(),
        ),
      ),
    );
  }
}
