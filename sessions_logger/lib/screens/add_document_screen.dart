import 'package:flutter/material.dart';

class AddDocumentScreen extends StatefulWidget {
  static const String routeName = '/add-document';
  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  GlobalKey<FormState> _form;
  OutlineInputBorder borderStyle;
  TextEditingController _title, _description;
  FocusNode _descriptionNode;
  String groupID;
  bool _firstBuild, _switch;
  @override
  void initState() {
    super.initState();
    _switch = false;
    _firstBuild = true;
    _form = GlobalKey<FormState>();
    borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: const BorderRadius.all(
        const Radius.circular(8.0),
      ),
    );
    _title = TextEditingController();
    _description = TextEditingController();
    _descriptionNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstBuild) {
      _firstBuild = false;
      groupID = ModalRoute.of(context).settings.arguments as String;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _description.dispose();
    _descriptionNode.dispose();
  }

  void _tryAddDocument() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Document'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _tryAddDocument,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Document Title',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22 * MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                _textFormFieldBuilder(
                  controller: _title,
                  validation: (value) {
                    if (value.isEmpty ||
                        value.length < 3 ||
                        value.length > 35) {
                      return 'Title should contains between 3 and 35 characters';
                    }
                    return null;
                  },
                  submit: (value) {
                    _descriptionNode.requestFocus();
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Document Description',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22 * MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                _textFormFieldBuilder(
                  controller: _description,
                  myFocusNode: _descriptionNode,
                  validation: (value) {
                    return null;
                  },
                  submit: (value) {
                    _tryAddDocument();
                  },
                  done: true,
                ),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  title: Text(
                    'Live Document',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'If you set this option you will not be able to add any items until the live begins.',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Switch.adaptive(
                      value: _switch,
                      onChanged: (value) {
                        setState(() {
                          _switch = value;
                        });
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material _textFormFieldBuilder(
      {@required TextEditingController controller,
      @required Function validation,
      @required Function submit,
      FocusNode myFocusNode,
      bool done = false}) {
    return Material(
      elevation: 2,
      child: TextFormField(
        controller: controller,
        focusNode: myFocusNode == null ? null : myFocusNode,
        onFieldSubmitted: submit,
        validator: validation,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14 * MediaQuery.of(context).textScaleFactor,
        ),
        cursorColor: Theme.of(context).primaryColor,
        textInputAction: done ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 6,
          ),
          filled: true,
          fillColor: Colors.white,
          border: borderStyle,
          enabledBorder: borderStyle,
          errorBorder: borderStyle,
          focusedBorder: borderStyle,
          disabledBorder: borderStyle,
          focusedErrorBorder: borderStyle,
          errorMaxLines: 2,
        ),
      ),
    );
  }
}
