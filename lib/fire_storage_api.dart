import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:inlovewithher/utils.dart';
import 'package:intl/intl.dart';

import 'models/image_picker_model.dart';

class FireStorageApi {
  static final FireStorageApi _instance = FireStorageApi._internal();

  FireStorageApi._internal();

  factory FireStorageApi() {
    return _instance;
  }

  var storageReference = FirebaseStorage.instance.ref();

  Future<List<String>?> putListFileToFireStorage(
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
    String dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String second = formatDateTime(DateTime.now(), formatter: 'HH:mm:ss');
    String path = platformFile.media ?? "";
    File file = File(path);
    if (!file.existsSync()) {
      return Future.value(platformFile);
    }
    UploadTask uploadTask;
    Reference reference = storageReference.child(storagePath).child(dateTime).child(second);

    uploadTask = reference.putFile(file);
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
