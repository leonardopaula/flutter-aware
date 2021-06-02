import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:aware/main.dart';


class MyStartForm extends StatefulWidget {
  @override
  MyStartFormState createState() {
    return MyStartFormState();
  }
}

class MyStartFormState extends State<MyStartForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final urlController = TextEditingController();
  final emailController = TextEditingController();

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
