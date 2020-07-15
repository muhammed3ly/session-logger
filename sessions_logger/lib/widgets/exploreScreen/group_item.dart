import 'package:flutter/material.dart';
import 'package:sessions_logger/screens/group_screen.dart';

class GroupItem extends StatelessWidget {
  final String groupName, groupID, groupPhotoURL;
  GroupItem({
    @required this.groupName,
    @required this.groupID,
    @required this.groupPhotoURL,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          GroupScreen.routeName,
          arguments: groupID,
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Hero(
                  tag: groupID,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: groupPhotoURL.contains('assets')
                        ? Image.asset(
                            'assets/images/all-group-placeholder.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            groupPhotoURL,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    groupName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
