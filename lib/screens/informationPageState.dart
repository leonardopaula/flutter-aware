import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:aware/screens/startForms.dart';

class MInformationPage extends StatefulWidget {
  MInformationPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/MInformationPage";

  final String title;

  @override
  _MyInformationPageState createState() => new _MyInformationPageState();
}

class _MyInformationPageState extends State<MInformationPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: MyStartForm(),
        floatingActionButton: new FloatingActionButton(
          onPressed: _onButtonPressed,
          tooltip: 'Add',
          child: new Icon(Icons.arrow_back),
        ),
      ),
    );
  }

  void _onButtonPressed() {
    setState(() {});
    rebuildAllChildren(context);
    Navigator.pop(context);
  }

   void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
}