import 'package:flutter/material.dart';

class Sensor {
  final String name;
  final int sync;

  Sensor({@required this.name, @required this.sync});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      name: json['title'],
      sync: json['sync'],
    );
  }
}
