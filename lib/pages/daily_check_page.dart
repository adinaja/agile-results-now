import 'package:flutter/material.dart';
import '../data/repository.dart';
import '../model/week.dart';
import '../model/goal.dart';
import '../model/vision.dart';
import '../widgets/goalcard.dart';
import '../widgets/visioncard.dart';
import '../widgets/customtitle.dart';
import '../utils/date.dart';

class DailyCheck extends StatefulWidget {
  DailyCheck({Key key, @required this.week, @required this.date}) : super(key: key);

  final Week week;
  final DateTime date;

   @override
  _DailyCheckState createState() => new _DailyCheckState();
}


class _DailyCheckState extends State<DailyCheck>{

  void _handleGoalChanged(Goal g, bool done) async{
    setState(() {
      g.done = done;
    });
    await Repository.get().toggleGoal(widget.date, g);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = [];
    widgets.add(new CustomTitle(
                  text: "Outcomes ${Helper.getText(widget.date)}"
              ));

    widgets.addAll(widget.week.goals.map((Goal goal){
      return new GoalCard(
        goal: goal,
        onGoalChanged: _handleGoalChanged
      );
    }).toList());

    widgets.add(new Divider());
    widgets.add(new CustomTitle(
                  text: "Your week vision"
                ));

    widgets.addAll(widget.week.visions.map((Vision vision){
      return new VisionCard(
        vision: vision
      );
    }).toList());

    //Add Reflection button
    if(widget.date.weekday == DateTime.friday){
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
