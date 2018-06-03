import 'package:flutter/material.dart';
import '../model/week.dart';
import '../widgets/goalcard.dart';
import '../widgets/visioncard.dart';
import '../widgets/customtitle.dart';
import '../utils/date.dart';

class DailyCheck extends StatelessWidget {
  final Week week;
  final DateTime date;

  DailyCheck({Key key, @required this.week, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = [];
    widgets.add(new CustomTitle(
                  text: "Outcomes ${Helper.getText(date)}"
              ));
    
    for (var goal in week.goals) {
      widgets.add(new GoalCard(goal: goal, date: date,));
    }

    widgets.add(new Divider());
    widgets.add(new CustomTitle(
                  text: "Your week vision"
                  ),
              );

    for(var vision in week.visions){
      widgets.add(new VisionCard(vision: vision));
    }

    //Add Reflection button
    if(date.weekday == DateTime.friday){
      widgets.add(new Align(
        alignment: Alignment.centerRight,
        child: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new RaisedButton(
            child: new Text('Reflection'),
            color: Colors.blueAccent,
            onPressed: () {
              //TODO navigate to review page
            }
          )
        )
        ));
    }

    return new ListView(
          children: widgets
    );
  }
}
