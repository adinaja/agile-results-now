import 'package:flutter/material.dart';
import '../model/goal.dart';
import '../data/repository.dart';

class GoalCard extends StatefulWidget {
  final DateTime date;
  final Goal goal;

  GoalCard({
      @required this.goal,
      @required this.date
  });

  @override
  createState() => new GoalCardState();
}

class GoalCardState extends State<GoalCard> {

  @override
  Widget build(BuildContext context) {

    return new Card(
      child: new Padding (
        padding: const EdgeInsets.only(
          left: 14.0
        ),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(widget.goal.text)
            ),
            new Checkbox(
              value: widget.goal.done,
              onChanged: (bool val) {
                setState(() {
                  widget.goal.done = val;
                });

                Repository.get().toggleGoal(widget.date, widget.goal);
                
              })
          ],
        )
      )
    );
  }
}
