import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:aware/util/Util.dart';
import 'package:aware/screens/informationPageState.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _enrollPage() {
    Navigator.pushNamed(context, MInformationPage.routeName)
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: Util.verifySharedPreferences(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text(widget.title),
                  ),
                  body: new Column(
                    children: <Widget>[_buildTitleEntrarEstudo()],
                  ),
                  floatingActionButton: new FloatingActionButton.extended(
                    onPressed: _enrollPage,
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
                    onPressed: _enrollPage,
                    tooltip: 'Entrar no Estudo',
                    label: const Text('Entrar no Estudo'),
                    icon: const Icon(Icons.thumb_up),
                  ),
                );
              }
            } else {
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text(widget.title),
                ),
                body: new Column(
                  children: <Widget>[_buildTitleEntrarEstudo()],
                ),
                floatingActionButton: new FloatingActionButton.extended(
                  onPressed: _enrollPage,
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
