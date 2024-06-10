import 'package:inlovewithher/models/person_model.dart';

import 'firestore_api.dart';
import 'models/anniversary_model.dart';
import 'models/dating_model.dart';

class HomeRepository {
  Future<DatingModel?> getDatingData() async {
    try {
      final response = await FireStoreApi(collection: 'Dating').getAllDocuments();
      final list = response.map((e) => DatingModel.fromJson(e)).toList();
      if (list.isNotEmpty) {
        return list.first;
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<AnniversaryModel?> getAnniversaryData(String id) async {
    try {
      final response = await FireStoreApi(collection: "AnniversaryDay").getById(id);
      if (response != null) {
        return AnniversaryModel.fromJson(response);
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<PersonModel?> getPersonData(String id) async {
    try {
      final response = await FireStoreApi(collection: "Person").getById(id);
      if (response != null) {
        return PersonModel.fromJson(response);
      }
      return null;
    } catch (err) {
      return null;
    }
  }
}
