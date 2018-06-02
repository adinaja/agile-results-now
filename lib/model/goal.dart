import 'package:flutter/material.dart';

class Goal {
  int weekId;
  String text;
  int priority;
  bool done;
  

  Goal({
    @required this.weekId,
    @required this.text,
    @required this.priority,
    @required this.done
  });

  Goal.fromMap(Map<String, dynamic> map): this(
    weekId: map["week_id"],
    text: map["text"],
    priority: map["priority"],
    done: map["done"] == 1
  );
}
