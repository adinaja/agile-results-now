import 'package:flutter/material.dart';
import '../model/week.dart';
import '../model/vision.dart';
import '../model/goal.dart';
import '../data/repository.dart';
import '../utils/date.dart';
import '../widgets/visioncard.dart';
import '../widgets/customtitle.dart';
import 'daily_check_page.dart';

class MondayVision extends StatefulWidget {
  final DateTime date;
  MondayVision({@required this.date});

  @override
  createState() => new MondayVisionState();
}

class MondayVisionState extends State<MondayVision>{

  final vision1Controller = new TextEditingController();
  final vision2Controller = new TextEditingController();
  final vision3Controller = new TextEditingController();
  final goal1Controller = new TextEditingController();
  final goal2Controller = new TextEditingController();
  final goal3Controller = new TextEditingController();

  void _saveWeek() async {

    if(vision1Controller.text == "" ||
    vision2Controller.text == "" || 
    vision3Controller.text == "" ||
    goal1Controller.text == "" ||
    goal2Controller.text == "" ||
    goal3Controller.text == "")
    {
      var alert = new AlertDialog(
        title: new Text("Define your visions and goals first"),
        content: new Text("I need to know your visions and goals for this week/day in order to assist you in reaching your goals...")
      );

      showDialog(context: context, child: alert);
      return;
    }
    //Store in Sqlflite Database
    List<Vision> visions = [];
    visions.add(new Vision(text: vision1Controller.text, priority: 1));
    visions.add(new Vision(text: vision2Controller.text, priority: 2));
    visions.add(new Vision(text: vision3Controller.text, priority: 3));

    List<Goal> goals = [];
    goals.add(new Goal(text:goal1Controller.text, priority: 1, done: false));
    goals.add(new Goal(text: goal2Controller.text, priority: 2, done: false));
    goals.add(new Goal(text: goal3Controller.text, priority: 3, done: false));

    Week week = await Repository.get().writeWeek(widget.date, visions, goals);

    Navigator.push(context, 
      new MaterialPageRoute(builder: (context) => 
        new Scaffold(
          appBar: new AppBar(
            title: new Text("Agile Results NOW"),
          ),
          body: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new DailyCheck(week: week, date: widget.date,),
          )
        )
      ),
    );
  }

  void _saveDay(int weekId) async {
    //Validate all input fields
    if(goal1Controller.text == "" ||
    goal2Controller.text == "" ||
    goal3Controller.text == "")
    {
      var alert = new AlertDialog(
        title: new Text("Define your goals for today first"),
        content: new Text("I need to know your goals for this day in order to assist you in reaching your visions...")
      );

      showDialog(context: context, child: alert);
      return;
    }

    List<Goal> goals = [];
    goals.add(new Goal(weekId: weekId, text: goal1Controller.text, priority: 1, done: false));
    goals.add(new Goal(weekId: weekId, text: goal2Controller.text, priority: 2, done: false));
    goals.add(new Goal(weekId: weekId, text: goal3Controller.text, priority: 3, done: false));

    Week week = await Repository.get().writeGoalsQueryWeek(weekId, widget.date, goals);

    Navigator.push(context, 
      new MaterialPageRoute(builder: (context) => 
        new Scaffold(
          appBar: new AppBar(
            title: new Text("Agile Results NOW"),
          ),
          body: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new DailyCheck(week: week, date: widget.date),
          )
        )
      ),
    );
  }

  Widget _getTextField(TextEditingController controller, IconData icon, String hintText){
    return new ListTile(
      leading: new Icon(icon),
      title: new TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              hintText: hintText,
            ),
        ),
    );
  }

  List<Widget> _getVisionEdits(Week week){
    
    vision1Controller.text = week.visions.length >= 1 ? week.visions[0].text : '';
    vision2Controller.text = week.visions.length >= 2 ? week.visions[1].text : '';
    vision3Controller.text = week.visions.length >= 3 ? week.visions[2].text : '';

    return <Widget>[
                new CustomTitle(
                  text: "Week vision"
                ),
                _getTextField(vision1Controller, Icons.explore, 'What is the first thing you need to do this week?'),
                _getTextField(vision2Controller, Icons.explore, 'What is the second thing you need to do this week?'),
                _getTextField(vision3Controller, Icons.explore, 'What is the third thing you need to do this week?')
            ];
  }

  List<Widget> _getGoalEdits(Week week) {
    goal1Controller.text = week.goals.length >= 1 ? week.goals[0].text : '';
    goal2Controller.text = week.goals.length >= 2 ? week.goals[1].text : '';
    goal3Controller.text = week.goals.length >= 3 ? week.goals[2].text : '';

    return <Widget>[
                new CustomTitle(
                  text: "Outcomes ${Helper.getText(widget.date)}"
                ),
                _getTextField(goal1Controller, Icons.star, 'Your goal 1 for today'),
                _getTextField(goal2Controller, Icons.star, 'Your goal 2 for today'),
                _getTextField(goal3Controller, Icons.star, 'Your goal 3 for today')
            ];
  }

  List<Widget> _getVisionCards(Week week){
    var visions = week.visions;

    List<Widget> widgets = [];
    widgets.add(new CustomTitle(
                  text: "Your week vision"
                ));

    for(var vision in visions){
      widgets.add(new VisionCard(vision: vision));
    }

    return widgets;
  }

  Widget drawHome() { 

    return new FutureBuilder<Week>(
      future: Repository.get().getWeek(widget.date),
      builder: (BuildContext context, AsyncSnapshot<Week> snapshot) {
        Week week = new Week(visions: [], goals: []);
        print("drawHomeScreen");
        if(snapshot.data != null){
          week = snapshot.data;
        }
        
        if(week.visions.length < 3 && week.goals.length < 3){
          List<Widget> list = _getVisionEdits(week);
          list.add(new Divider());
          list.addAll(_getGoalEdits(week));
          list.add(
            new Align(
              alignment: Alignment.centerRight,
              child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: new Text('Done'),
                  color: Colors.blueAccent,
                  onPressed: () {
                    _saveWeek();
                  }
                )
              )
            )
          );

          return new ListView(
            children: list,
          );
        }
        else if(week.visions.length == 3 && week.goals.length < 3){
          //the vision is defined... but the goals haven't yet been defined
          List<Widget> list = _getGoalEdits(week);
          list.add(
            new Align(
              alignment: Alignment.centerRight,
              child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: new Text('Done'),
                  color: Colors.blueAccent,
                  onPressed: () {
                    _saveDay(week.id);
                  }
                )
              )
            )
          );
          list.addAll(_getVisionCards(week));
          
          return new ListView(
            children: list,
          );
        }
        else{
          return new Container(
            child: new DailyCheck(week: week, date: widget.date)
          );
        }
      },
    );
  }


  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    vision1Controller.dispose();
    vision2Controller.dispose();
    vision3Controller.dispose();
    goal1Controller.dispose();
    goal2Controller.dispose();
    goal3Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new Container(
      child: drawHome());
  }
}
