import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonModel {
  PersonModel({
    this.name,
    this.dateOfBirth,
    this.sex,
    this.avatar,
  });
  final String? name;
  final DateTime? dateOfBirth;
  final String? sex;
  final String? avatar;

  factory PersonModel.fromJson(Map<String, dynamic> map) {
    return PersonModel(
      name: map['name'],
      dateOfBirth: (map['dateOfBirth'] != null && map['dateOfBirth'] is Timestamp)
          ? (map['dateOfBirth'] as Timestamp).toDate()
          : null,
      avatar: map['avatar'],
      sex: map['sex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'avatar': avatar,
      'sex': sex,
    };
  }

  IconData? getIconSex() {
    if (sex == "male") {
      return Icons.male;
    }
    return Icons.female;
  }
}
