import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inlovewithher/show_bottomsheet.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../camera_helper.dart';
import '../dialog_utils.dart';
import '../fire_storage_api.dart';
import '../firestore_api.dart';
import '../models/anniversary_model.dart';
import '../models/dating_model.dart';
import '../models/image_picker_model.dart';
import '../models/person_model.dart';
import '../repositories/home_repository.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());
  final repo = HomeRepository();

  int anniversaryPage = 0;

  DatingModel? get datingData => state.datingData;

  Future<void> getDataDating() async {
    emit(state.loading());
    List<AnniversaryModel> listAnniversary = [];
    List<PersonModel> listPeople = [];
    DatingModel? datingModel = await repo.getDatingData();
    List<Future> listAnniversaryFuture =
        (datingModel?.anniversaryDay ?? []).map((anniversaryId) => repo.getAnniversaryData(anniversaryId)).toList();
    List<Future> listPeopleFuture =
        (datingModel?.people ?? []).map((personId) => repo.getPersonData(personId)).toList();
    var response = await Future.wait<dynamic>([
      ...listAnniversaryFuture,
      ...listPeopleFuture,
    ]);
    for (var element in response) {
      if (element is AnniversaryModel) {
        listAnniversary.add(element);
      }
      if (element is PersonModel) {
        listPeople.add(element);
      }
    }
    datingModel = datingModel?.copyWith(
      listAnniversary: listAnniversary,
      listPeople: listPeople,
    );
    emit(state.copyWith(datingData: datingModel));
  }

  Future<void> changeAnniversaryBackground(BuildContext context) async {
    var images = await CameraHelper().pickMedia(
      context,
      enabledRecording: false,
      showCamera: true,
      maxAssetSelect: 1,
      requestType: RequestType.image,
    );
    if (images.isEmpty) {
      return;
    }
    ImagesPickerModel image = images.first;
    Loading().show();
    image = await FireStorageApi().uploadFileToStorage(image, storagePath: "background_image");
    var currentAnniversaryId = (datingData?.anniversaryDay ?? [])[anniversaryPage];
    var currentAnniversaryModel = (datingData?.listAnniversary ?? [])[anniversaryPage].copyWith(bgImage: image.url);
    await FireStoreApi(collection: 'AnniversaryDay')
        .updateData(currentAnniversaryId, data: currentAnniversaryModel.toParam());
    await getDataDating();
    Loading().dismiss();
  }

  Future<void> editAnniversary(BuildContext context) async {
    await bottomSheet.show(context, child: const EditBottomSheet());
  }

  void updateAnniversaryPage(int page) {
    anniversaryPage = page;
  }
}
