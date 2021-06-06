import 'package:flutter/material.dart';
import 'package:aware/routes/routes.dart';
import 'package:aware/screens/homePageState.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Aware Framework - Gustavo e Leonardo Study',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Gustavo e Leonardo Study'),
      routes: routes,
    );
  }
}
