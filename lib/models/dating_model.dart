import 'package:equatable/equatable.dart';
import 'package:inlovewithher/models/person_model.dart';

import 'anniversary_model.dart';

class DatingModel {
  const DatingModel({this.anniversaryDay, this.people, this.listPeople, this.listAnniversary, this.id});
  final List<String>? anniversaryDay;
  final List<String>? people;
  final List<AnniversaryModel>? listAnniversary;
  final List<PersonModel>? listPeople;
  final String? id;

  DatingModel copyWith({
    final List<String>? anniversaryDay,
    final List<String>? people,
    final List<AnniversaryModel>? listAnniversary,
    final List<PersonModel>? listPeople,
    String? id,
  }) {
    return DatingModel(
      anniversaryDay: anniversaryDay ?? this.anniversaryDay,
      people: people ?? this.people,
      listAnniversary: listAnniversary ?? this.listAnniversary,
      listPeople: listPeople ?? this.listPeople,
      id: id ?? this.id,
    );
  }

  factory DatingModel.fromJson(Map<String, dynamic> map) {
    return DatingModel(
      anniversaryDay:
          (map['anniversaryDay'] is List) ? (map['anniversaryDay'] as List).map((e) => e.toString()).toList() : null,
      people: (map['people'] is List) ? (map['people'] as List).map((e) => e.toString()).toList() : null,
      id: map['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anniversaryDay': anniversaryDay,
      'people': people,
    };
  }

  Map<Object, Object?> toParam() {
    return {
      'anniversaryDay': anniversaryDay,
      'people': people,
    };
  }
}
