import 'package:cloud_firestore/cloud_firestore.dart';

class AnniversaryModel {
  AnniversaryModel({
    this.bgImage,
    this.title,
    this.type,
    this.dateTimeStamp,
    this.id,
  });
  AnniversaryModel copyWith({
    final String? bgImage,
    final DateTime? dateTimeStamp,
    final String? title,
    final String? type,
    final String? id,
  }) {
    return AnniversaryModel(
      bgImage: bgImage ?? this.bgImage,
      dateTimeStamp: dateTimeStamp ?? this.dateTimeStamp,
      title: title ?? this.title,
      type: type ?? this.type,
      id: id ?? this.id,
    );
  }

  final DateTime? dateTimeStamp;
  final String? title;
  final String? type;
  final String? id;
  final String? bgImage;

  factory AnniversaryModel.fromJson(Map<String, dynamic> map) {
    return AnniversaryModel(
      bgImage: map['backgroundImage'],
      title: map['title'],
      type: map['type'],
      dateTimeStamp: (map['dateTimeStamp'] != null && map['dateTimeStamp'] is Timestamp)
          ? (map['dateTimeStamp'] as Timestamp).toDate()
          : null,
      id: map['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "backgroundImage": bgImage,
      "title": title,
      "type": type,
      "dateTimeStamp": dateTimeStamp != null ? Timestamp.fromDate(dateTimeStamp!) : null,
    };
  }

  Map<Object, Object?> toParam() {
    return {
      "backgroundImage": bgImage,
      "title": title,
      "type": type,
      "dateTimeStamp": dateTimeStamp != null ? Timestamp.fromDate(dateTimeStamp!) : null,
    };
  }
}
