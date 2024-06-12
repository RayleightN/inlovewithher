import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inlovewithher/constants.dart';

class PersonModel {
  PersonModel({
    this.name,
    this.dateOfBirth,
    this.sex,
    this.avatar,
    this.id,
    this.nameController,
    this.birthdayController,
    this.avatarFile,
  });
  final String? name;
  final DateTime? dateOfBirth;
  final String? sex;
  final String? avatar;
  final String? id;
  final TextEditingController? nameController;
  final TextEditingController? birthdayController;
  final String? avatarFile;

  PersonModel copyWith({
    final String? name,
    final DateTime? dateOfBirth,
    final String? sex,
    final String? avatar,
    final String? id,
    TextEditingController? nameController,
    TextEditingController? birthdayController,
    String? avatarFile,
  }) {
    return PersonModel(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sex: sex ?? this.sex,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
      nameController: nameController ?? this.nameController,
      birthdayController: birthdayController ?? this.birthdayController,
      avatarFile: avatarFile ?? this.avatarFile,
    );
  }

  factory PersonModel.fromJson(Map<String, dynamic> map) {
    return PersonModel(
      name: map['name'],
      dateOfBirth: (map['dateOfBirth'] != null && map['dateOfBirth'] is Timestamp)
          ? (map['dateOfBirth'] as Timestamp).toDate()
          : null,
      avatar: map['avatar'],
      sex: map['sex'],
      id: map['id'],
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

  Map<Object, Object?> toParam() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'avatar': avatar,
      'sex': sex,
    };
  }

  IconData? getIconSex() {
    if (sex == Sex.male) {
      return Icons.male;
    }
    return Icons.female;
  }

  IconData getIcon() {
    if (sex == Sex.male) {
      return Icons.boy;
    }
    return Icons.girl;
  }

  Color getIconColor() {
    if (sex == Sex.male) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
