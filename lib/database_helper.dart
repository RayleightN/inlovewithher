import 'models/dating_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatingModel? _datingData;

  DatingModel? get datingData => _datingData;

  set datingData(DatingModel? value) {
    _datingData = value;
  }
}
