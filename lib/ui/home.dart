import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inlovewithher/camera_helper.dart';
import 'package:inlovewithher/database_helper.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'anniversary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (_) {
      var data = DatabaseHelper().datingData;
      if (data != null) {
        var children =
            (data.listAnniversary ?? []).map((e) => AnniversaryPage(data: e, people: data.listPeople)).toList();
        return Stack(
          children: [
            PageView(
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
                          await onOpenCamera();
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
    }));
  }

  Future<void> onOpenCamera() async {
    var images = await CameraHelper().pickMedia(
      enabledRecording: false,
      showCamera: true,
      maxAssetSelect: 1,
      requestType: RequestType.image,
    );
  }
}
