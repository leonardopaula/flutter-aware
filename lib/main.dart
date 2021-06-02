import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aware/routes/routes.dart';
import 'package:aware/screens/homePageState.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   static const platform = const MethodChannel('ch/aware');

//   @override
//   void initState() {
//     super.initState();
//     teste();
//   }

//   void init() async {
//     await platform.invokeMethod('init');
//   }

//   void teste() async {
//     String res = await platform.invokeMethod('accelerometer');
//     print(res);
//     String res1 = await platform.invokeMethod('battery');
//     print('Bateria... ');
//     print(res1);
//     String res2 = await platform.invokeMethod('schedule');
//     print(res2);
//     String res3 = await platform.invokeMethod('sync');
//     print(res3);
//     String res4 = await platform.invokeMethod('application');
//     print(res4);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: const Text('Plugin Example App'),
//         ),
//         body: MyCustomForm(),
//       ),
//     );
//   }
// }

void main() => runApp(new MyApp());

Future<bool> verifySharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> str = prefs.getStringList('userInfo');
  try {
    if (null == str || str.isEmpty) {
      return true;
    } else {
      return false;
    }
  } on Exception catch (_) {
    return true;
  }
}

//  Shared Pregerences Storage                                    
  void saveDateSharedPreferences(String email, String url) async {
    final prefs = await SharedPreferences.getInstance();
    //write
    prefs.setStringList('userInfo', [email, url]);
    List<String> str = prefs.getStringList('userInfo');
    for (var i = 0; i < str.length; i++) {
      print(str.elementAt(i));
    }
  }

  void deleteSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    //write
    prefs.remove('userInfo');
  }

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
