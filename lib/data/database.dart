import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/week.dart';
import '../model/vision.dart';
import '../model/goal.dart';
import '../utils/date.dart';

class ResultDatabase {
  static final ResultDatabase _resultDatabase = new ResultDatabase._internal();

  Database db;

  bool initialized = false;

  static ResultDatabase get() {
    return _resultDatabase;
  }

  ResultDatabase._internal();

  Future<Database> _getDb() async{
    if(!initialized) await _init();
    return db;
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "agileresult.db");

    db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {

            await db.execute("""
            CREATE TABLE week (
              id_week INTEGER PRIMARY KEY,
              week_number INTEGER NOT NULL,
              year INTEGER NOT NULL
            )""");

            await db.execute("""
            CREATE UNIQUE INDEX idx_weeknumberyear
            ON week (week_number, year)
            """);

            await db.execute("""
            CREATE TABLE vision (
              week_id INTEGER NOT NULL,
              text TEXT NULL,
              priority INTEGER NOT NULL,
              FOREIGN KEY (week_id) REFERENCES week(id_week)
            )""");

            await db.execute("""
            CREATE UNIQUE INDEX idx_visions
            ON vision (week_id, priority)
            """);

            await db.execute("""
            CREATE TABLE goal (
              week_id INTEGER NOT NULL,
              day INTEGER NOT NULL,
              text TEXT NULL,
              priority INTEGER NOT NULL,
              done INTEGER NOT NULL,
              FOREIGN KEY (week_id) REFERENCES week(id_week)
            )""");

            await db.execute("""
            CREATE UNIQUE INDEX idx_goals
            ON goal (day, priority)
            """);
          }
        );
    initialized = true;
  }

   Future close() async {
    var db = await _getDb();
    return db.close();
  }

  Future writeGoals(int weekId, int weekday, List<Goal> goals) async {
    for (var g in goals) {
      await db.rawInsert( 
        'INSERT OR REPLACE INTO '
            'goal(week_id, day, text, priority, done)'
            ' VALUES(?, ?, ?, ?, ?)',
        [weekId, weekday, g.text, g.priority, g.done]);
    }
  }

  Future _writeVisions(int weekId, List<Vision> visions) async {
    for (var v in visions){
      await db.rawInsert(
        'INSERT OR REPLACE INTO '
            'vision(week_id, text, priority)'
            ' VALUES(?, ?, ?)',
        [weekId, v.text, v.priority]);
    }
  }

  Future writeWeek(DateTime date, Week week) async{
    var db = await _getDb();

    var weekNum = Helper.getWeekNumberFromDate(date);
    var weekId = -1;
    //check if weekNum/year combination is already in DB
    var weekResult = await db.rawQuery('SELECT * FROM week WHERE year=${date.year} AND week_number = $weekNum');
    if(weekResult.length == 0){
      weekId = await db.rawInsert(
          'INSERT OR REPLACE INTO '
              'week(week_number, year)'
              ' VALUES(?, ?)',
          [weekNum, date.year]);
    }
    else{
      var week = new Week.fromMap(weekResult[0]);
      weekId = week.id;
    }
    _writeVisions(weekId, week.visions);
    writeGoals(weekId, date.weekday, week.goals);
  }

  Future<List<Goal>> _getGoals(int weekId, int weekDay) async {
    var db = await _getDb();

    var goalResult = await db.rawQuery('SELECT * FROM goal WHERE week_id=$weekId AND day=$weekDay ORDER BY priority');
    if(goalResult.length == 0){
      return [];
    }

    List<Goal> goals = [];
    for(Map<String,dynamic> map in goalResult) {
      goals.add(new Goal.fromMap(map));
    }

    return goals;
  }

  Future<List<Vision>> _getVisions(int weekNum, int weekId) async {
    var db = await _getDb();

    var visionResult = await db.rawQuery('SELECT * FROM vision WHERE week_id=$weekId ORDER BY priority');
    if(visionResult.length == 0){
      return [];
    }

    List<Vision> visions = [];
    for(Map<String,dynamic> map in visionResult) {
      visions.add(new Vision.fromMap(map));
    }

    return visions;
  }

  Future<Week> getWeek(DateTime date) async {
    var db = await _getDb();

    var weekNum = Helper.getWeekNumberFromDate(date);

    var weekResult = await db.rawQuery('SELECT * FROM week WHERE year=${date.year} AND week_number = $weekNum');
    if(weekResult.length == 0){
      return new Week(visions: [], goals: []);
    }

    var week = new Week.fromMap(weekResult[0]);
    week.visions = await _getVisions(weekNum, week.id);
    week.goals = await _getGoals(week.id, date.weekday);

    return week;
  }

  Future toggleGoal(DateTime date, Goal goal) async {
    var db = await _getDb();

    await db.rawInsert(
        'INSERT OR REPLACE INTO '
            'goal(week_id, day, text, priority, done)'
            ' VALUES(?, ?, ?, ?, ?)',
    [goal.weekId, date.weekday, goal.text, goal.priority, goal.done]);
  }
}
