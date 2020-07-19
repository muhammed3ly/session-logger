import 'package:flutter/material.dart';
import 'package:sessions_logger/models/document.dart';
import 'package:sessions_logger/widgets/groupScreen/document_view_item.dart';

class DocumentsTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DocumentViewItem(
          Document(
            id: '1',
            creatorId: '1',
            creationDate: DateTime.now(),
            showTimeStamps: false,
            documentName: 'Session 1',
          ),
          live: true,
        ),
        DocumentViewItem(
          Document(
            id: '1',
            creatorId: '1',
            creationDate: DateTime.now(),
            showTimeStamps: false,
            documentName: 'Session 2',
          ),
        ),
        DocumentViewItem(
          Document(
            id: '1',
            creatorId: '1',
            creationDate: DateTime.now(),
            showTimeStamps: false,
            documentName: 'Session 3',
          ),
        ),
        DocumentViewItem(
          Document(
            id: '1',
            creatorId: '1',
            creationDate: DateTime.now(),
            showTimeStamps: false,
            documentName: 'Session 4',
          ),
        ),
      ],
    );
  }
}
