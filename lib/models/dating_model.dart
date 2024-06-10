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
}
