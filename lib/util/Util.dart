import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import "../models/Study.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aware/AwareManager.dart';
import 'package:http/http.dart' as http;
import 'package:cron/cron.dart';

class Util {
  static Cron cron = Cron();

  static Future<Study> enrollStudy(String url, String mail, context) async {
    Study s;
    var uuid = Uuid().v5(Uuid.NAMESPACE_URL, url);
    final response = await http.post(
      Uri.parse('http://' + url + '/api/study'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mail': mail,
        'uuid': uuid,
      }),
    );

    if (response.statusCode == 200) {
      AwareManager.init(uuid);
      s = Study.fromJson(jsonDecode(response.body)["data"]);
      Util.saveDateSharedPreferences(mail, url, s, uuid);
      Util.configureCronTab(s.sync, url, context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            content: Text('Sucesso! Estudo iniciado \n\n' + mail + '\n' + url),
          );
        },
      );
    }

    return s;
  }

  static Future<void> configureCronTab(int seconds, String url, context) async {
    Util.cron.close();
    Util.cron = Cron()
      ..schedule(Schedule.parse('* */' + seconds.toString() + ' * * * *'), () {
        AwareManager.syncData(url, context);
      });
  }

  static Future<bool> verifySharedPreferences(context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> str = prefs.getStringList('userInfo');

    try {
      if (null == str || str.isEmpty) {
        return true;
      } else {
        Util.configureCronTab(int.parse(str[3]), str[1], context);
        AwareManager.init(str[4]);
        return false;
      }
    } on Exception catch (_) {
      return true;
    }
  }

  //  Shared Preferences Storage
  static void saveDateSharedPreferences(
      String email, String url, Study s, String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'userInfo', [email, url, s.name, s.sync.toString(), uuid]);
  }

  static void deleteSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    //write
    prefs.remove('userInfo');
    Util.cron.close();
  }
}
