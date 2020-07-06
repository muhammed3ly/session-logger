import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  CustomDivider(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(children: <Widget>[
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: Divider(
            color: Theme.of(context).accentColor,
          ),
        )),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: Divider(
            color: Theme.of(context).accentColor,
          ),
        )),
      ]),
    );
  }
}
