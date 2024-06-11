class CalendarHelper {
  static final CalendarHelper _instance = CalendarHelper._internal();

  CalendarHelper._internal();

  factory CalendarHelper() {
    return _instance;
  }
}
