import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;

  const CustomTitle({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Text(
      text, 
      textAlign: TextAlign.left,
      style: new TextStyle(
        fontSize: 20.0
      ),
    );
  }
}


