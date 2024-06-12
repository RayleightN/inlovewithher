import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:inlovewithher/calendar_helper.dart';
import 'package:inlovewithher/colors.dart';
import 'package:inlovewithher/constants.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/dialog_utils.dart';
import 'package:inlovewithher/models/anniversary_model.dart';
import 'package:inlovewithher/models/dating_model.dart';
import 'package:inlovewithher/route_generator.dart';
import 'package:inlovewithher/screen_utils.dart';
import 'package:inlovewithher/ui/display_image.dart';
import 'package:inlovewithher/ui/top_bar_scroll.dart';
import 'package:inlovewithher/utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../camera_helper.dart';
import '../fire_storage_api.dart';
import '../firestore_api.dart';
import '../global.dart';
import '../models/image_picker_model.dart';
import 'button.dart';
import 'components.dart';

class EditAnniversary extends StatefulWidget {
  const EditAnniversary({Key? key, this.anniversary}) : super(key: key);
  static const router = "edit_anniversary";
  final AnniversaryModel? anniversary;

  @override
  State<EditAnniversary> createState() => _EditAnniversaryState();
}

class _EditAnniversaryState extends State<EditAnniversary> {
  ScrollController controller = ScrollController();
  AnniversaryModel? data;
  int? selectedIndex;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focus = FocusNode();
  bool get emptyDescription => textEditingController.text.trim().isEmpty;
  bool showEditDescription = false;
  late final MainCubit mainCubit;

  @override
  void initState() {
    data = widget.anniversary ?? AnniversaryModel();
    mainCubit = context.read<MainCubit>();
    textEditingController.text = data?.title ?? "";
    super.initState();
  }

  bool emptyImage(AnniversaryModel? data) => (data?.bgImage ?? "").isEmpty && (data?.fileBgImage ?? "").isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: darkStatusBar,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  SizedBox(height: ScreenUtils().pdTop + 46),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: controller,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildDescriptionLayout(),
                          const SizedBox(height: 16),
                          _buildDate(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  KeyboardVisibilityBuilder(builder: (context, keyboardVisible) {
                    if (keyboardVisible) {
                      return const SizedBox();
                    }
                    return FooterButton(
                      isEnabled: true,
                      btnColor: mainColor,
                      title: "Lưu kỷ niệm",
                      onTap: () async {
                        Loading().show();
                        ImagesPickerModel currentImage =
                            ImagesPickerModel(url: data?.bgImage, media: data?.fileBgImage);
                        currentImage =
                            await FireStorageApi().uploadFileToStorage(currentImage, storagePath: "background_image");
                        data = data?.copyWith(bgImage: currentImage.url);
                        if (widget.anniversary == null) {
                          // thêm bản ghi mới vào bảng "AnniversaryDay";
                          var doc = await FireStoreApi(collection: 'AnniversaryDay').add(data: data?.toJson());
                          if (doc == null) {
                            return;
                          }
                          DatingModel? datingData = mainCubit.datingData;
                          List<String> listAnniversary = datingData?.anniversaryDay ?? [];
                          listAnniversary = [doc.id, ...listAnniversary];
                          // update list anniversaryId trong bảng "Dating".
                          await FireStoreApi(collection: 'Dating').updateData(datingData?.id,
                              data: datingData?.copyWith(anniversaryDay: listAnniversary).toParam());
                        } else {
                          await FireStoreApi(collection: 'AnniversaryDay').updateData(data!.id!, data: data?.toParam());
                        }
                        await mainCubit.getDataDating();
                        Loading().dismiss();
                        goRouter.pop();
                      },
                    );
                  }),
                ],
              ),
              _buildTabBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Stack(
      children: [
        BackgroundBarScroll(
          scrollController: controller,
          colorEnd: Colors.white,
          heightTrigger: ScreenUtils().pdTop,
          colorBegin: Colors.white,
          heightAppBar: ScreenUtils().pdTop + 46,
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenUtils().pdTop + 12, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  goRouter.pop();
                },
                child: platformIconBack(Colors.black),
              ),
              const Text(
                'Ngày kỷ niệm',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              platformIconBack(Colors.transparent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          DateTime? date = await CalendarHelper().chooseDate(context, lastDate: DateTime.now());
          if (date == null) return;
          data = data?.copyWith(dateTimeStamp: date);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: grayColor2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 20, color: Colors.brown.withOpacity(0.7)),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Text(
                    "Chọn ngày kỷ niệm",
                    style: TextStyle(color: blackTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                  )),
                  Text(formatDateTime(data?.dateTimeStamp), style: const TextStyle(color: blackTextColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionLayout() {
    double height = 450;
    return GestureDetector(
      onTap: () {
        listenFocusDescription(true);
        if (!focus.hasFocus) {
          focus.requestFocus();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFFFFF2F9), Color(0xFFFDF3E8)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Image.asset("assets/images/icon_love.gif", width: 48, height: 48),
                  const SizedBox(height: 16),
                  if (emptyDescription && !showEditDescription) ...[
                    const Text("Nhập tên ngày kỷ niệm",
                        style: TextStyle(
                          color: Color(0xFF25282B),
                          fontSize: 24,
                          fontFamily: 'SVN-Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                        ),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                  ],
                  FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        listenFocusDescription(focus);
                      },
                      child: _buildDescriptionTextField(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buttonPickImage(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildListDefaultImage(),
          ],
        ),
      ),
    );
  }

  Widget _buildListDefaultImage() {
    if (listImageDefault.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 102,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          bool isSelected = selectedIndex == index;
          var item = listImageDefault[index];
          return GestureDetector(
            onTap: () {
              selectedIndex = index;
              hideKeyboard(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: index == 0 ? 12 : 0),
              alignment: Alignment.center,
              width: 76,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                border: Border.all(color: isSelected ? mainColor : Colors.transparent),
                color: isSelected ? Colors.white.withOpacity(0.6) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DisplayImage(
                image: ImagesPickerModel(url: item),
                height: 100,
                width: 76,
                placeHolder: const SizedBox.shrink(),
              ),
            ),
          );
        },
        itemCount: listImageDefault.length,
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    if (emptyDescription && !showEditDescription) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '........',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'SVN-Poppins',
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.edit_outlined,
            size: 20,
            color: grayTextColor2,
          ),
        ],
      );
    }
    var textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontFamily: 'SVN',
      fontWeight: FontWeight.w500,
      height: 1.33,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Tên ngày kỷ niệm",
            style: TextStyle(
              color: grayTextColor3,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.text,
            cursorWidth: 2,
            controller: textEditingController,
            // fullwidth: false,
            focusNode: focus,
            cursorColor: Colors.black,
            showCursor: true,
            // minFontSize: 24,
            onChanged: (text) {
              setState(() {
                data = data?.copyWith(title: text);
              });
            },
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              counterText: "",
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            // minWidth: 0,
            textAlign: TextAlign.center,
            // enableInteractiveSelection: false,
            style: textStyle,
            maxLength: 150,
            minLines: 1,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buttonPickImage() {
    return InkWell(
      onTap: () async {
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
        data = data?.copyWith(bgImage: image.url, fileBgImage: image.media);
        setState(() {});
      },
      child: emptyImage(data)
          ? Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image,
                size: 20,
                color: mainColor,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DisplayImage(
                image: ImagesPickerModel(media: data?.fileBgImage, url: data?.bgImage),
                width: 80,
                height: 80,
              ),
            ),
    );
  }

  void listenFocusDescription(bool focus) {
    setState(() {
      showEditDescription = focus;
    });
  }
}
