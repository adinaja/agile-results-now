import 'package:flutter/material.dart';
import 'pages/monday_vision_page.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  final DateTime date = new DateTime.now();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Agile Results NOW',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Agile Results NOW"),
        ),
        body: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new MondayVision(date: date,),
        )
      )
    );
  }
}
