import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/models/group.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
import 'package:sessions_logger/screens/add_document_screen.dart';
import 'package:sessions_logger/widgets/groupScreen/documents_tab_view.dart';
import 'package:sessions_logger/widgets/groupScreen/group_header.dart';
import 'package:share/share.dart';

class GroupScreen extends StatefulWidget {
  static const String routeName = '/group_screen';
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with SingleTickerProviderStateMixin {
  Group group;
  bool _firstRun;
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset >
            (MediaQuery.of(context).size.height * 0.4 - kToolbarHeight);
  }

  TabBar _getTabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.white,
      tabs: <Widget>[
        Tab(
          child: Text('Documents', style: TextStyle(color: Colors.white)),
        ),
        Tab(
          child: Text('About', style: TextStyle(color: Colors.white)),
        ),
        Tab(
          child: Text('Members', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _firstRun = true;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    lastStatus = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstRun) {
      final groupID = ModalRoute.of(context).settings.arguments as String;
      group = Provider.of<GroupsProvider>(context)
          .myAllGroups
          .firstWhere((g) => g.id == groupID);
      _firstRun = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void addLog() {
    Navigator.of(context).pushNamed(
      AddDocumentScreen.routeName,
      arguments: group.id,
    );
  }

  void share() {
    Share.share(
      'Please join ${group.groupName} using this code: ${group.invitationCode} in Binder #LINK',
      subject: '[Sessions Logger] Invitation To ${group.groupName} ',
    );
  }

  void delete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (ctx, innerViewIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(ctx),
                child: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    stretch: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.5,
                    title: lastStatus ? Text(group.groupName) : null,
                    actions: <Widget>[
                      PopupMenuButton<String>(
                        color: Colors.white,
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (String result) {
                          if (result == 'Add') {
                            addLog();
                          } else if (result == 'Share') {
                            share();
                          } else if (result == 'Delete') {
                            delete();
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Add',
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.black,
                                  size: 20 *
                                      MediaQuery.of(context).textScaleFactor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Add Document'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Share',
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.shareAlt,
                                  color: Colors.black,
                                  size: 20 *
                                      MediaQuery.of(context).textScaleFactor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Share Group'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Delete',
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.black,
                                  size: 20 *
                                      MediaQuery.of(context).textScaleFactor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Delete Group'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    bottom: _getTabBar(),
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: GroupHeader(
                        groupID: group.id,
                        groupName: group.groupName,
                        groupIC: group.invitationCode,
                        membersCount: 12,
                        documentsCount: 100,
                        imageUrl: group.photoURL,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8,
            ),
            child: TabBarView(
              children: <Widget>[
                DocumentsTabView(),
                ListView(
                  children: <Widget>[
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20 * MediaQuery.of(context).textScaleFactor,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Text(
                      group.description,
                      softWrap: true,
                      maxLines: 100,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                Text('Members'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
