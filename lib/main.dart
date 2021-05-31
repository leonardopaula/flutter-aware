import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

// // body: Container(
// //             child: RaisedButton(
// //               onPressed: () {
// //                 teste();
// //               },
// //               child: Text('teste'),
// //             ),
// //           )

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

  void deleteSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    //write
    prefs.remove('userInfo');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    urlController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
        FloatingActionButton.extended(
          // When the user presses the button, show an alert dialog containing
          // the text that the user has entered into the text field.
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text the that user has entered by using the
                  // TextEditingController.
                  content: Text('Sucesso! Estudo iniciado \n\n' +
                      emailController.text +
                      '\n' +
                      urlController.text),
                );
              },
            );
            saveDateSharedPreferences(emailController.text, urlController.text);
          },
          tooltip: 'Show me the value!',
          label: const Text('Entrar'),
          icon: const Icon(Icons.account_circle),
        ),
        FloatingActionButton.extended(
          // When the user presses the button, show an alert dialog containing
          // the text that the user has entered into the text field.
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('Estudo Finalizado'));
              },
            );
            deleteSharedPreferences();
          },
          label: const Text('Sair do Estudo'),
          icon: const Icon(Icons.exit_to_app),
        ),
      ],
    );
  }
}

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      MyItemsPage.routeName: (BuildContext context) =>
          new MyItemsPage(title: "MyItemsPage"),
    };
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    // Navigator.pushNamed(context, MyItemsPage.routeName);
    Navigator.pushNamed(context, MyItemsPage.routeName).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: verifySharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                var button = new IconButton(
                    icon: new Icon(Icons.access_alarm),
                    onPressed: _onButtonPressed);
                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text(widget.title),
                  ),
                  body: new Column(
                    children: <Widget>[_buildTitleEntrarEstudo()],
                  ),
                  floatingActionButton: new FloatingActionButton.extended(
                    onPressed: _incrementCounter,
                    tooltip: 'Entrar no Estudo',
                    label: const Text('Entrar no Estudo'),
                    icon: const Icon(Icons.thumb_up),
                  ),
                );
              } else {
                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text(widget.title),
                  ),
                  body: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[_buildTitleParticipandoEstudo()],
                  ),
                  floatingActionButton: new FloatingActionButton.extended(
                    onPressed: _incrementCounter,
                    tooltip: 'Entrar no Estudo',
                    label: const Text('Entrar no Estudo'),
                    icon: const Icon(Icons.thumb_up),
                  ),
                );
              }
            } else {
              var button = new IconButton(
                  icon: new Icon(Icons.access_alarm),
                  onPressed: _onButtonPressed);
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text(widget.title),
                ),
                body: new Column(
                  children: <Widget>[_buildTitleEntrarEstudo()],
                ),
                floatingActionButton: new FloatingActionButton.extended(
                  onPressed: _incrementCounter,
                  tooltip: 'Entrar no Estudo',
                  label: const Text('Entrar no Estudo'),
                  icon: const Icon(Icons.thumb_up),
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

  void _onButtonPressed() {
    Navigator.pushNamed(context, MyItemsPage.routeName);
  }

  Widget _buildTitleParticipandoEstudo() {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              "Sucesso! Voce esta participando do estudo!",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              // textAlign: TextAlign.center,
            ),
            Text(
              "Seus dados estao sendo comunicados com o servidor",
              style: TextStyle(
                color: Colors.red,
              ),
              // textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleEntrarEstudo() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            Text(
              "Bem vindo ao Aware",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "\n\nVoce nao esta participando de estudos :(",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Clique no botao entrar no estudo para comecar a enviar dados!",
              style: TextStyle(
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MyItemsPage extends StatefulWidget {
  MyItemsPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/MyItemsPage";

  final String title;

  @override
  _MyItemsPageState createState() => new _MyItemsPageState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   MyItemsPage.routeName: (BuildContext context) => new MyItemsPage(title: "MyItemsPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, MyItemsPage.routeName);
///

class _MyItemsPageState extends State<MyItemsPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: MyCustomForm(),
        floatingActionButton: new FloatingActionButton(
          onPressed: _onButtonPressed,
          tooltip: 'Add',
          child: new Icon(Icons.arrow_back),
        ),
      ),
    );
  }

  void _onFloatingActionButtonPressed() {}

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
