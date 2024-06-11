import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:inlovewithher/utils.dart';
import 'package:intl/intl.dart';

import 'models/image_picker_model.dart';

class FireStorageApi {
  static final FireStorageApi _instance = FireStorageApi._internal();

  FireStorageApi._internal();

  factory FireStorageApi() {
    return _instance;
  }

  Future<List<String>?> putFileToFireStorage(
    List<ImagesPickerModel>? images, {
    required String storagePath,
  }) async {
    if (images == null) return null;
    var response = await Future.wait(
      images.where((e) => (e.media ?? "").isNotEmpty).map((item) {
        return uploadFileToStorage(item, storagePath: storagePath);
      }).toList(),
    );
    return response.map((e) => e.url ?? "").toList();
  }

  Future<ImagesPickerModel> uploadFileToStorage(
    ImagesPickerModel platformFile, {
    required String storagePath,
  }) async {
    int time = DateTime.now().hashCode;
    String dateTime = DateFormat('yyyy/MM/dd').format(DateTime.now());
    String path = platformFile.media ?? "";

    String rawPath = '$time.${path.split('/').last.split('.')[1]}';
    firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child(storagePath).child(dateTime).child(rawPath);

    uploadTask = storageReference.putFile(File(path));
    await uploadTask.whenComplete(() async {
      platformFile.url = await uploadTask.snapshot.ref.getDownloadURL();
    });
    await uploadTask.onError((error, stackTrace) {
      showToast(error.toString());
      return uploadTask;
    });
    return Future.value(platformFile);
  }
}
