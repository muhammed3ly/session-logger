import 'package:flutter/material.dart';

class LogsItem extends StatelessWidget {
  final String title, groupName, description;
  LogsItem({@required this.title, @required this.groupName, this.description});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          subtitle: description == null
              ? null
              : Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          trailing: Text(
            groupName,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
