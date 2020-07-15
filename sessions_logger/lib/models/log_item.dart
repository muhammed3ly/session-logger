import 'package:flutter/material.dart';

class LogItem {
  final String id;
  String title, description, timeStamp;
  DateTime date, date2;
  LogItem({
    @required this.id,
    this.title,
    this.date,
    this.date2,
    this.description,
    this.timeStamp,
  });
}
