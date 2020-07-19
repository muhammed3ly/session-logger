import 'package:flutter/material.dart';

import 'document_item.dart';

class Document {
  final String id, creatorId;
  final DateTime creationDate;
  String documentName;
  DateTime finishDate;
  bool live, showTimeStamps;
  List<DocumentItem> logsItems;
  Document({
    @required this.id,
    @required this.creatorId,
    @required this.creationDate,
    @required this.showTimeStamps,
    @required this.documentName,
    this.live = false,
    this.finishDate,
  }) : assert((live && finishDate != null) || !live);
}
