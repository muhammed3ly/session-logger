import 'package:flutter/cupertino.dart';
import 'package:sessions_logger/models/log.dart';

class Group {
  final String id, creatorId, invitationCode;
  String groupName, photoURL, description;
  List<String> admins;
  List<Log> logs;
  Group({
    @required this.id,
    @required this.groupName,
    @required this.creatorId,
    @required this.invitationCode,
    @required this.photoURL,
    @required this.description,
  });
}
