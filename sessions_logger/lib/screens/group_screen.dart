import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sessions_logger/models/group.dart';
import 'package:sessions_logger/providers/groups_provider.dart';
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
  TabController tabController;
  TabBar _getTabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.label,
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
      controller: tabController,
    );
  }

  @override
  void initState() {
    super.initState();
    _firstRun = true;
    tabController = TabController(length: 3, vsync: this);
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
    tabController.dispose();
  }

  void addLog() {}
  void share() {
    Share.share(
      group.invitationCode,
      subject:
          '[Sessions Logger] Please join ${group.groupName} using this code',
    );
  }

  void delete() {}

  //TODO: SliverScroll
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: group.photoURL.contains('assets')
                      ? Image.asset(
                          group.photoURL,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          group.photoURL,
                          fit: BoxFit.cover,
                        ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.75), Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height *
                      (MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 0.4
                          : 0.5),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: group.id,
                          child: CircleAvatar(
                            minRadius: 30,
                            maxRadius: 60,
                            backgroundImage: group.photoURL.contains('assets')
                                ? AssetImage(
                                    group.photoURL,
                                  )
                                : NetworkImage(
                                    group.photoURL,
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          group.groupName,
                          style: TextStyle(
                            fontSize:
                                20 * MediaQuery.of(context).textScaleFactor,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '@${group.invitationCode}',
                              style: TextStyle(
                                fontSize:
                                    18 * MediaQuery.of(context).textScaleFactor,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '12',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22 *
                                        MediaQuery.of(context).textScaleFactor,
                                  ),
                                ),
                                Text(
                                  'Members',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 14 *
                                        MediaQuery.of(context).textScaleFactor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '100',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22 *
                                        MediaQuery.of(context).textScaleFactor,
                                  ),
                                ),
                                Text(
                                  'Documents',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 14 *
                                        MediaQuery.of(context).textScaleFactor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 5,
                  top: MediaQuery.of(context).padding.top + 5,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: MediaQuery.of(context).padding.top + 5,
                  child: PopupMenuButton<String>(
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
                              size: 20 * MediaQuery.of(context).textScaleFactor,
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
                              size: 20 * MediaQuery.of(context).textScaleFactor,
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
                              size: 20 * MediaQuery.of(context).textScaleFactor,
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
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: <Widget>[
                  _getTabBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'About',
                                style: TextStyle(
                                  fontSize: 20 *
                                      MediaQuery.of(context).textScaleFactor,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              Text(
                                group.description,
                                softWrap: true,
                                maxLines: 100,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18 *
                                      MediaQuery.of(context).textScaleFactor,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                          Text('Documents'),
                          Text('Members'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
