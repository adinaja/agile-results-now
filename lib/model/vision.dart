import 'package:flutter/material.dart';

class Vision {
  String text;
  int priority;

  Vision({
    @required this.text,
    @required this.priority
  });

  Vision.fromMap(Map<String, dynamic> map): this(
    text: map["text"],
    priority: map["priority"]
  );
}
