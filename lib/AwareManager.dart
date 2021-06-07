import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AwareManager {
  // Canal para comunicação com o Aware Core
  static const channel = const MethodChannel('ch/aware');

  static void init(String uuid) async {
    await channel.invokeMethod("init", <String, dynamic>{
      'uuid': uuid,
    });
  }

  // Recebe a lista dos sensores e efetua a consulta
  Future<String> getData() async {
    String accelerometer = await channel.invokeMethod('accelerometer');
    String battery = await channel.invokeMethod('battery');
    String location = await channel.invokeMethod('location');
    String light = await channel.invokeMethod('light');

    List<Map<String, dynamic>> data = [
      {
        "accelerometer":
            jsonDecode((accelerometer == "") ? "[]" : accelerometer)
      },
      {"battery": jsonDecode((battery == "") ? "[]" : battery)},
      {"location": jsonDecode((location == "") ? "[]" : location)},
      {"light": jsonDecode((light == "") ? "[]" : light)},
    ];

    return jsonEncode(data);
  }

  Future<String> enroll() async {
    return await channel.invokeMethod('enroll');
  }

  void enviar() async {
    await channel.invokeMethod('enviar');
  }

  void putz() async {
    await channel.invokeMethod('putz');
  }

  static Future<void> syncData(String url, context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Enviando dados...'),
    ));

    String res = await AwareManager().getData();
    final response = await http.post(
      Uri.parse('http://' + url + '/api/sensor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: res,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Sucesso!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Deu erro...'),
        action: SnackBarAction(
          label: 'Action',
          onPressed: () {
            // Code to execute.
          },
        ),
      ));
    }
  }
}
