import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sessions_logger/screens/create_group_screen.dart';
import 'package:sessions_logger/widgets/exploreScreen/explore_action.dart';
import 'package:sessions_logger/widgets/exploreScreen/explore_groups.dart';
import 'package:sessions_logger/widgets/exploreScreen/explore_my_groups.dart';
import 'package:sessions_logger/widgets/exploreScreen/join_by_code.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int screenIndex;
  List<Widget> screens;
  @override
  void initState() {
    super.initState();
    screenIndex = 1;
    screens = [ExploreMyGroups(), ExploreGroups(), JoinByCode()];
  }

  void _createGroup() {
    Navigator.of(context).pushNamed(CreateGroupScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Groups',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26 * MediaQuery.of(context).textScaleFactor,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                    size: 30,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
        Container(
          height: 35 * MediaQuery.of(context).textScaleFactor,
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              ExploreAction(
                  actionIcon: FontAwesomeIcons.edit,
                  actionText: 'Create Log',
                  actionFunction: () {}),
              ExploreAction(
                  actionIcon: Icons.add_circle,
                  actionText: 'Create Group',
                  actionFunction: _createGroup),
              ExploreAction(
                  actionIcon: Icons.group,
                  actionText: 'Your Own Groups',
                  actionFunction: () {
                    setState(() {
                      screenIndex = 0;
                    });
                  }),
              ExploreAction(
                  actionIcon: Icons.group_work,
                  actionText: 'All Groups',
                  actionFunction: () {
                    setState(() {
                      screenIndex = 1;
                    });
                  }),
              ExploreAction(
                  actionIcon: FontAwesomeIcons.connectdevelop,
                  actionText: 'Join by Code',
                  actionFunction: () {
                    setState(() {
                      screenIndex = 2;
                    });
                  }),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
        Expanded(child: screens[screenIndex]),
      ],
    );
  }
}
