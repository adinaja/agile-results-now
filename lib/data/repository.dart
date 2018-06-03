import 'database.dart';
import 'dart:async';
import '../model/week.dart';
import '../model/vision.dart';
import '../model/goal.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  ResultDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = ResultDatabase.get();
  }

  Future<Week> writeWeek(DateTime date, List<Vision> visions, List<Goal> goals){
    return database.writeWeek(date, visions, goals);
  }

  Future<Week> getWeek(DateTime date)  {
    return database.getWeek(date);
  }

  Future toggleGoal(DateTime date, Goal goal){
    return database.toggleGoal(date, goal);
  }

  Future<Week> writeGoalsQueryWeek(int weekId, DateTime date, List<Goal> goals){
    database.writeGoals(weekId, date.weekday, goals);
    return database.getWeek(date);
  }
}
