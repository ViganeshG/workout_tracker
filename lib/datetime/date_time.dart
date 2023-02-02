//return  today date
String todaysDateDDMMYYYY() {
  //today
  var dateTimeobject = DateTime.now();

  //year in format yyyy
  String year = dateTimeobject.year.toString();

  //month in format mm
  String month = dateTimeobject.month.toString();
  if (month.length == 1) {
    month = "0$month";
  }
  //day in format dd
  String day = dateTimeobject.day.toString();
  if (day.length == 1) {
    day = "0$day";
  }

  //final format
  String ddmmyyyy = day + month + year;

  return ddmmyyyy;
}

//convert string to dateTime object
DateTime createDateTimeObject(String ddmmyyyy) {
  int dd = int.parse(ddmmyyyy.substring(6, 8));
  int mm = int.parse(ddmmyyyy.substring(4, 6));
  int yyyy = int.parse(ddmmyyyy.substring(0, 4));

  DateTime dateTimeObject = DateTime(dd, mm, yyyy);
  return dateTimeObject;
}

//convert dateTime object to string
String convertDateTimetoDDMMYYYY(DateTime dateTime) {
  //year in format yyyy
  String year = dateTime.year.toString();

  //month in format mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = "0$month";
  }
  //day in format dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = "0$day";
  }
  //final format
  String ddmmyyyy = day + month + year;

  return ddmmyyyy;
}
