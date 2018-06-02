import 'vision.dart';
import 'goal.dart';

class Week {
  int id;
  List<Vision> visions = [];

  List<Goal> goals = [];

  Week({
    this.id,
    this.visions,
    this.goals
  });

  Week.fromMap(Map<String, dynamic> map): this(
    id: map["id_week"]
  );
}
