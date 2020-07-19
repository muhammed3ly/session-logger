import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  final String groupName, groupIC, imageUrl, groupID;
  final int membersCount, documentsCount;
  GroupHeader({
    @required this.groupID,
    @required this.groupName,
    @required this.groupIC,
    @required this.membersCount,
    @required this.documentsCount,
    @required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: imageUrl.contains('assets')
              ? Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        Opacity(
          opacity: 0.8,
          child: Container(
            width: double.infinity,
            height: double.infinity,
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
          padding: const EdgeInsets.all(8.0),
          height: MediaQuery.of(context).size.height *
              (MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.4
                  : 0.4),
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: groupID,
                  child: CircleAvatar(
                    minRadius: 30,
                    maxRadius: 60,
                    backgroundImage: imageUrl.contains('assets')
                        ? AssetImage(
                            imageUrl,
                          )
                        : NetworkImage(
                            imageUrl,
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  groupName,
                  style: TextStyle(
                    fontSize: 20 * MediaQuery.of(context).textScaleFactor,
                    color: Colors.white,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '@$groupIC',
                      style: TextStyle(
                        fontSize: 18 * MediaQuery.of(context).textScaleFactor,
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
                          '$membersCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                22 * MediaQuery.of(context).textScaleFactor,
                          ),
                        ),
                        Text(
                          'Members',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize:
                                14 * MediaQuery.of(context).textScaleFactor,
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
                          '$documentsCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                22 * MediaQuery.of(context).textScaleFactor,
                          ),
                        ),
                        Text(
                          'Documents',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize:
                                14 * MediaQuery.of(context).textScaleFactor,
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
      ],
    );
  }
}
