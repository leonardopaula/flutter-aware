import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel('leo/aware');

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await platform.invokeMethod('init');
  }

  void teste() async {
    String res = await platform.invokeMethod('accelerometer');
    print(res);
    String res1 = await platform.invokeMethod('battery');
    print('Bateria... ');
    print(res1);
    String res2 = await platform.invokeMethod('location');
    print(res2);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: Container(
            child: RaisedButton(
              onPressed: () {
                teste();
              },
              child: Text('teste'),
            ),
          )),
    );
  }
}
