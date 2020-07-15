import 'package:flutter/material.dart';

class ExploreAction extends StatelessWidget {
  final String actionText;
  final IconData actionIcon;
  final Function actionFunction;
  ExploreAction(
      {@required this.actionIcon,
      @required this.actionText,
      @required this.actionFunction});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2.5, right: 2.5),
      child: FlatButton.icon(
        color: Colors.grey[300],
        shape: StadiumBorder(),
        icon: Icon(
          actionIcon,
          color: Colors.black,
          size: 20 * MediaQuery.of(context).textScaleFactor,
        ),
        label: Text(
          actionText,
          style: TextStyle(
            fontSize: 16 * MediaQuery.of(context).textScaleFactor,
            color: Colors.black,
          ),
        ),
        onPressed: actionFunction,
      ),
    );
  }
}
