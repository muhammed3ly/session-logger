import 'package:flutter/material.dart';
import 'package:sessions_logger/models/document.dart';

class DocumentViewItem extends StatefulWidget {
  final Document document;
  final bool live;
  DocumentViewItem(this.document, {this.live = false});

  @override
  _DocumentViewItemState createState() => _DocumentViewItemState();
}

class _DocumentViewItemState extends State<DocumentViewItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  @override
  void initState() {
    super.initState();
    if (widget.live) {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600),
      );
      _animationController.repeat(reverse: true);
      _animation = ColorTween(begin: Colors.red[700], end: Colors.red[900])
          .animate(_animationController)
            ..addListener(() {
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    if (widget.live) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.live
        ? AnimatedBuilder(
            animation: _animation,
            builder: (ctx, child) => Card(
              elevation: 8,
              color: _animation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text('LIVE: ${widget.document.documentName}'),
                subtitle: Text(widget.document.creationDate.toIso8601String()),
                trailing:
                    IconButton(icon: Icon(Icons.arrow_right), onPressed: () {}),
              ),
            ),
          )
        : Card(
            elevation: 8,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text('${widget.document.documentName}'),
              subtitle: Text(widget.document.creationDate.toIso8601String()),
              trailing:
                  IconButton(icon: Icon(Icons.arrow_right), onPressed: () {}),
            ),
          );
  }
}
