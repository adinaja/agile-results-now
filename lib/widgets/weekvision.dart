import 'package:flutter/material.dart';
import '../model/vision.dart';
import 'visioncard.dart';

class WeekVision extends StatelessWidget {
  final List<Vision> visions;

  const WeekVision({Key key, @required this.visions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.add(new Text(
                  "Your week vision", 
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    fontSize: 20.0
                  ),
              ));

    for(var vision in visions){
      widgets.add(new VisionCard(vision: vision));
    }

    return new ListView(
      children: widgets
    );
  }
}
