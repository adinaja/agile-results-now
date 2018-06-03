import 'package:flutter/material.dart';
import '../model/goal.dart';

typedef void GoalChangedCallback(Goal goal, bool done);

class GoalCard extends StatelessWidget {
  GoalCard({
      @required this.goal, @required this.onGoalChanged
  }) : super(key: new ObjectKey(goal));

  final Goal goal;
  final GoalChangedCallback onGoalChanged;

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
              child: new Text(goal.text)
            ),
            new Checkbox(
              value: goal.done,
              onChanged: (bool val) {
                onGoalChanged(goal, val);
              })
          ],
        )
      )
    );
  }
}
