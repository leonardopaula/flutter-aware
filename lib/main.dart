import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel('ch/aware');

  @override
  void initState() {
    super.initState();
    teste();
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
    String res2 = await platform.invokeMethod('schedule');
    print(res2);
    String res3 = await platform.invokeMethod('sync');
    print(res3);
    String res4 = await platform.invokeMethod('application');
    print(res4);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// body: Container(
//             child: RaisedButton(
//               onPressed: () {
//                 teste();
//               },
//               child: Text('teste'),
//             ),
//           )

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final urlController = TextEditingController();
  final emailController = TextEditingController();

  void saveDateSharedPreferences(String email, String url) async {
    final prefs = await SharedPreferences.getInstance();
    //write
    prefs.setStringList('userInfo', [email, url]);
    List<String> str = prefs.getStringList('userInfo');
    for (var i = 0; i < str.length; i++) {
      print(str.elementAt(i));
    }
  }

  Future<bool> verifySharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> str = prefs.getStringList('userInfo');
    if (str.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    urlController.dispose();
    emailController.dispose();
    super.dispose();
  }

  //aqui para testar tenho que tentar fazer o Build enxergar caso o SharedPreferences ja tenha guardado algo, se tiver mostrar apenas
  //uma mensagem que o estudo esta ok!
  // verifySharedPreferences().then((bool existPreference) {
  //PRoblema com Future

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Qual seu e-mail?',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: urlController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Digite aqui a URL de seu estudo :)',
            ),
          ),
        ),
        FloatingActionButton(
          // When the user presses the button, show an alert dialog containing
          // the text that the user has entered into the text field.
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text the that user has entered by using the
                  // TextEditingController.
                  content:
                      Text(emailController.text + '\n' + urlController.text),
                );
              },
            );
            saveDateSharedPreferences(emailController.text, urlController.text);
          },
          tooltip: 'Show me the value!',
          child: Icon(Icons.text_fields),
        ),
      ],
    );
  }
}
