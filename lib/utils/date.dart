class Helper {

  static int getWeekNumberFromDate(DateTime date){
    int weekDay = date.weekday;

    var dayNr = (weekDay + 6) % 7;

    var monday = date.subtract(new Duration(days:(dayNr)));
    var thursday = monday.add(new Duration(days:3));

    var firstThursday = new DateTime(date.year, DateTime.january, 1);

    if(firstThursday.weekday != (DateTime.thursday))
    {
        firstThursday = new DateTime(date.year, DateTime.january, 1 + ((4 - firstThursday.weekday) + 7) % 7);
    }

    var x = thursday.millisecondsSinceEpoch - firstThursday.millisecondsSinceEpoch;
    var weekNumber = x.ceil() / 604800000;
    return weekNumber.round();
  }

  static String getText(DateTime date){
    int weekDay = date.weekday;
    
    switch(weekDay){
      case DateTime.sunday:
        return "Sunday";
        break;
      case DateTime.monday:
        return "Monday";
        break;
      case DateTime.tuesday:
        return "Tuesday";
        break;
      case DateTime.wednesday:
        return "Wednesday";
        break;
      case DateTime.thursday:
        return "Thursday";
      break;
      case DateTime.friday:
        return "Friday";
      break;
      case DateTime.saturday:
        return "Saturday";
      break;
    }

    return "Sunday";
  }
}
