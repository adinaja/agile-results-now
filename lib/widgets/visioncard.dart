import 'package:flutter/material.dart';
import '../model/vision.dart';

class VisionCard extends StatelessWidget {
  final Vision vision;

  const VisionCard({Key key, @required this.vision}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding (
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(vision.text)
            ),
          ],
        )
      )
    );
  }
}
