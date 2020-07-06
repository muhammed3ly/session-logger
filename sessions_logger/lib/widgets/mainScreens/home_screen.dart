import 'package:flutter/material.dart';
import 'package:sessions_logger/widgets/logs_item.dart';

import '../custom_divider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CustomDivider('NEW'),
        LogsItem(title: 'Session 6', groupName: 'Mini-ITI 6/3'),
        LogsItem(
          title: 'Session 7',
          groupName: 'Mini-ITI 6/3',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer a pharetra turpis. Aliquam ac lacus pellentesque metus ullamcorper tristique. Quisque nec neque sem. Nunc faucibus, tortor vitae elementum pulvinar, diam neque iaculis mauris, eu congue mi neque eu nisi. Ut ut consequat mi, commodo elementum ipsum. In blandit arcu lorem, a vulputate dui scelerisque eu. Integer vitae nulla commodo, elementum nibh vitae, tincidunt nibh. ',
        ),
        CustomDivider('OLD'),
      ],
    );
  }
}
