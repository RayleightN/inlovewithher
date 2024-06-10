import 'package:cloud_firestore/cloud_firestore.dart';

class AnniversaryModel {
  AnniversaryModel({
    this.bgImage,
    this.title,
    this.type,
    this.dateTimeStamp,
  });
  final String? bgImage;
  final DateTime? dateTimeStamp;
  final String? title;
  final String? type;

  factory AnniversaryModel.fromJson(Map<String, dynamic> map) {
    return AnniversaryModel(
      bgImage: map['backgroundImage'],
      title: map['title'],
      type: map['type'],
      dateTimeStamp: (map['dateTimeStamp'] != null && map['dateTimeStamp'] is Timestamp)
          ? (map['dateTimeStamp'] as Timestamp).toDate()
          : null,
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
}
