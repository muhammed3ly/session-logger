import 'package:flutter/material.dart';

class DocumentItem {
  final String id;
  String title, description, timeStamp;
  DateTime date, date2;
  DocumentItem({
    @required this.id,
    this.title,
    this.date,
    this.date2,
    this.description,
    this.timeStamp,
  });
}
