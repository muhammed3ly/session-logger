import 'package:flutter/material.dart';

import 'log_item.dart';

class Log {
  final String id, creatorId;
  final DateTime creationDate;
  DateTime finishDate;
  bool live, showTimeStamps;
  List<LogItem> logsItems;
  Log({
    @required this.id,
    @required this.creatorId,
    @required this.creationDate,
    @required this.showTimeStamps,
    this.live = false,
    this.finishDate,
  }) : assert((live && finishDate != null) || !live);
}
