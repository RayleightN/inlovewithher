import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inlovewithher/camera_helper.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/database_helper.dart';
import 'package:inlovewithher/dialog_utils.dart';
import 'package:inlovewithher/fire_storage_api.dart';
import 'package:inlovewithher/firestore_api.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'anniversary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();
  int currentPage = 0;
  late final MainCubit mainCubit;
  @override
  void initState() {
    mainCubit = context.read<MainCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (_) {
        var data = mainCubit.datingData;
        if (data != null) {
          var children =
              (data.listAnniversary ?? []).map((e) => AnniversaryPage(data: e, people: data.listPeople)).toList();
          return Stack(
            children: [
              PageView(
                onPageChanged: (page) {
                  currentPage = page;
                },
                controller: controller,
                children: children,
              ),
              SafeArea(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(Icons.create_outlined, color: Colors.white, size: 30),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await onOpenCamera(context);
                          },
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                        ),
                      ],
                    )),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    ));
  }

  Future<void> onOpenCamera(BuildContext context) async {
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
    Loading().show();
    List<String> imageUrls = await FireStorageApi().putFileToFireStorage(images, storagePath: "background_image") ?? [];
    if (imageUrls.isEmpty) {
      return;
    }
    var currentAnniversaryId = (mainCubit.datingData?.anniversaryDay ?? [])[currentPage];
    var currentAnniversaryModel =
        (mainCubit.datingData?.listAnniversary ?? [])[currentPage].copyWith(bgImage: imageUrls.first);
    await FireStoreApi(collection: 'AnniversaryDay')
        .updateData(currentAnniversaryId, data: currentAnniversaryModel.toParam());
    Loading().dismiss();
  }
}
