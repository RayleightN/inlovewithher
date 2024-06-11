import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreApi {
  String collection;
  FireStoreApi({required this.collection});
  CollectionReference get collectionRef => FirebaseFirestore.instance.collection(collection);

  Future<List<dynamic>> getAllDocuments() async {
    var snap = await collectionRef.get();
    return snap.docs.where((e) => e.exists).map((e) {
      Map<String, dynamic> map = e.data() as Map<String, dynamic>;
      map['id'] = e.id;
      return map;
    }).toList();
  }

  Future<DocumentReference<dynamic>> add({required Map<String, dynamic> data}) async {
    return await collectionRef.add(data);
  }

  Future<List<dynamic>> getByQuery({
    required String fieldName,
    required String key,
  }) async {
    var snap = await collectionRef.where(fieldName, isEqualTo: key).get();
    return snap.docs.where((e) => e.exists).map((e) {
      var map = e.data() as Map<String, dynamic>;
      map['id'] = e.id;
      return map;
    }).toList();
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    var document = await collectionRef.doc(id).get();
    if (document.exists) {
      Map<String, dynamic> map = document.data() as Map<String, dynamic>;
      map['id'] = document.id;
      return map;
    }
    return null;
  }
}
