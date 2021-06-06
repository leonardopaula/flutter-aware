import 'package:flutter/material.dart';

class Study {
  final int id;
  final String name;
  final int sync;

  Study({@required this.id, @required this.name, @required this.sync});

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      id: json['id'],
      name: json['title'],
      sync: json['sync'],
    );
  }
}
