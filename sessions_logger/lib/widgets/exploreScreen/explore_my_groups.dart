import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
import 'package:sessions_logger/providers/users_provider.dart';
import 'package:sessions_logger/widgets/exploreScreen/group_item.dart';

class ExploreMyGroups extends StatefulWidget {
  @override
  _ExploreMyGroupsState createState() => _ExploreMyGroupsState();
}

class _ExploreMyGroupsState extends State<ExploreMyGroups> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Provider.of<GroupsProvider>(context, listen: false)
          .fetchMyGroups(Provider.of<UsersProvider>(context).user.userID),
      displacement: 60,
      color: Theme.of(context).primaryColor,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5 / 4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 8,
          ),
          itemCount: Provider.of<GroupsProvider>(context).myOwnGroups.length,
          itemBuilder: (ctxx, i) {
            return GroupItem(
              groupName:
                  Provider.of<GroupsProvider>(context).myOwnGroups[i].groupName,
              groupID: Provider.of<GroupsProvider>(context).myOwnGroups[i].id,
              groupPhotoURL:
                  Provider.of<GroupsProvider>(context).myOwnGroups[i].photoURL,
            );
          },
        ),
      ),
    );
  }
}
