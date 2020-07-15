import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
import 'package:sessions_logger/providers/users_provider.dart';
import 'package:sessions_logger/widgets/exploreScreen/group_item.dart';

class ExploreGroups extends StatefulWidget {
  @override
  _ExploreGroupsState createState() => _ExploreGroupsState();
}

class _ExploreGroupsState extends State<ExploreGroups> {
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
          itemCount: Provider.of<GroupsProvider>(context).myAllGroups.length,
          itemBuilder: (ctxx, i) {
            return GroupItem(
              groupName:
                  Provider.of<GroupsProvider>(context).myAllGroups[i].groupName,
              groupID: Provider.of<GroupsProvider>(context).myAllGroups[i].id,
              groupPhotoURL:
                  Provider.of<GroupsProvider>(context).myAllGroups[i].photoURL,
            );
          },
        ),
      ),
    );
  }
}
