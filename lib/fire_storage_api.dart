import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:inlovewithher/utils.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
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
        return uploadFileToStorage(item.media, storagePath: storagePath);
      }).toList(),
    );
    return response.map((e) => e ?? "").toList();
  }

  Future<ImagesPickerModel> uploadImage(
    ImageUploadModel image, {
    required String storagePath,
  }) async {
    if (image.url.isNotEmpty) {
      await deleteFile(image.url);
    }
    String urlNew = await uploadFileToStorage(image.media, storagePath: storagePath) ?? "";
    return ImagesPickerModel(
      url: urlNew,
      media: image.media,
    );
  }

  Future<String?> uploadFileToStorage(
    String? filePath, {
    required String storagePath,
  }) async {
    String? imageUrl;
    String dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String path = filePath ?? "";
    File file = File(path);
    if (!file.existsSync()) {
      return null;
    }
    String fileName = basename(file.path);
    UploadTask uploadTask;
    Reference reference = storageReference.child(storagePath).child(dateTime).child(fileName);

    uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() async {
      imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
    });
    await uploadTask.onError((error, stackTrace) {
      showToast(error.toString());
      return uploadTask;
    });
    return Future.value(imageUrl);
  }

  Future<void> deleteFile(String? url) async {
    if ((url ?? "").isEmpty) {
      return;
    }
    await FirebaseStorage.instance.refFromURL(url!).delete();
  }
}
