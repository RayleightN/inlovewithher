import 'package:inlovewithher/models/person_model.dart';

import 'anniversary_model.dart';

class DatingModel {
  DatingModel({this.anniversaryDay, this.people});
  final List<String>? anniversaryDay;
  final List<String>? people;

  factory DatingModel.fromJson(Map<String, dynamic> map) {
    return DatingModel(
      anniversaryDay:
          (map['anniversaryDay'] is List) ? (map['anniversaryDay'] as List).map((e) => e.toString()).toList() : null,
      people: (map['people'] is List) ? (map['people'] as List).map((e) => e.toString()).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anniversaryDay': anniversaryDay,
      'people': people,
    };
  }

  List<AnniversaryModel>? _listAnniversary;

  List<AnniversaryModel>? get listAnniversary => _listAnniversary;

  set listAnniversary(List<AnniversaryModel>? value) {
    _listAnniversary = value;
  }

  List<PersonModel>? _listPeople;

  List<PersonModel>? get listPeople => _listPeople;

  set listPeople(List<PersonModel>? value) {
    _listPeople = value;
  }
}
