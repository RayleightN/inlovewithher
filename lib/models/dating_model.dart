import 'package:equatable/equatable.dart';
import 'package:inlovewithher/models/person_model.dart';

import 'anniversary_model.dart';

class DatingModel {
  const DatingModel({this.anniversaryDay, this.people, this.listPeople, this.listAnniversary});
  final List<String>? anniversaryDay;
  final List<String>? people;
  final List<AnniversaryModel>? listAnniversary;
  final List<PersonModel>? listPeople;

  DatingModel copyWith({
    final List<String>? anniversaryDay,
    final List<String>? people,
    final List<AnniversaryModel>? listAnniversary,
    final List<PersonModel>? listPeople,
  }) {
    return DatingModel(
      anniversaryDay: anniversaryDay ?? this.anniversaryDay,
      people: people ?? this.people,
      listAnniversary: listAnniversary ?? this.listAnniversary,
      listPeople: listPeople ?? this.listPeople,
    );
  }

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
}
