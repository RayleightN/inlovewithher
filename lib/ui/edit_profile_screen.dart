import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:inlovewithher/calendar_helper.dart';
import 'package:inlovewithher/colors.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/dialog_utils.dart';
import 'package:inlovewithher/fire_storage_api.dart';
import 'package:inlovewithher/models/person_model.dart';
import 'package:inlovewithher/route_generator.dart';
import 'package:inlovewithher/screen_utils.dart';
import 'package:inlovewithher/ui/top_bar_scroll.dart';
import 'package:inlovewithher/utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../camera_helper.dart';
import '../firestore_api.dart';
import '../models/image_picker_model.dart';
import 'button.dart';
import 'components.dart';
import 'display_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const String router = "edit_profile_screen";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ScrollController controller = ScrollController();
  late final MainCubit mainCubit;
  List<PersonModel> listPeople = [];

  @override
  void initState() {
    super.initState();
    mainCubit = context.read<MainCubit>();
    listPeople = mainCubit.datingData?.listPeople ?? [];
  }

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
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: BlocBuilder<MainCubit, MainState>(
                          builder: (context, state) {
                            if (listPeople.isEmpty) {
                              return const SizedBox();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                ...List.generate(listPeople.length, (index) {
                                  var person = listPeople[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8, top: 8),
                                    child: FormEditProfile(
                                      icon: Icon(person.getIcon(), color: person.getIconColor()),
                                      nameController: TextEditingController(),
                                      birthdayController: TextEditingController(),
                                      updatePerson: (person) {
                                        if (person == null) return;
                                        listPeople[index] = person.copyWith();
                                        setState(() {});
                                      },
                                      person: listPeople[index],
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  KeyboardVisibilityBuilder(
                      builder: (context, keyboardVisible) {
                        if (!keyboardVisible) {
                          return FooterButton(
                            isEnabled: true,
                            title: "Xác nhận",
                            onTap: () async {
                              Loading().show();
                              var listImage = listPeople
                                  .map((p) => ImagesPickerModel(
                                        media: p.avatarFile,
                                      ))
                                  .toList();
                              int i = 0;
                              await Future.forEach<ImagesPickerModel>(listImage, (item) async {
                                if ((item.media ?? "").isNotEmpty) {
                                  var res = await FireStorageApi().uploadFileToStorage(item, storagePath: "avatar");
                                  listPeople[i] = listPeople[i].copyWith(avatar: res.url);
                                  i++;
                                }
                              });
                              await Future.wait(listPeople
                                  .map((p) =>
                                      FireStoreApi(collection: 'Person').updateData(p.id ?? "", data: p.toParam()))
                                  .toList());
                              await mainCubit.getDataDating();
                              Loading().dismiss();
                              goRouter.pop();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      controller: KeyboardVisibilityController()),
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
                'Chỉnh sửa hồ sơ',
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
}

class FormEditProfile extends StatefulWidget {
  const FormEditProfile({
    Key? key,
    this.icon,
    required this.nameController,
    required this.birthdayController,
    this.updatePerson,
    this.person,
  }) : super(key: key);
  final Widget? icon;
  final TextEditingController nameController;
  final TextEditingController birthdayController;
  final Function(PersonModel?)? updatePerson;
  final PersonModel? person;

  @override
  State<FormEditProfile> createState() => _FormEditProfileState();
}

class _FormEditProfileState extends State<FormEditProfile> {
  final FocusNode nameFocus = FocusNode();
  final FocusNode birthdayFocus = FocusNode();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormEditProfile oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    var formatter = "dd-MM-yyyy";
    widget.nameController.text = widget.person?.name ?? "";
    widget.birthdayController.text = formatDateTime(widget.person?.dateOfBirth, formatter: formatter);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(color: grayColor4, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextFormField(
                focusNode: nameFocus,
                cursorColor: Colors.black,
                controller: widget.nameController,
                maxLength: 100,
                decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: dividerColor),
                  ),
                  helperText: "",
                  icon: widget.icon,
                  labelText: 'Name',
                  labelStyle: const TextStyle(
                    color: grayColor5,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
                onChanged: (text) {
                  widget.updatePerson?.call(widget.person?.copyWith(name: text));
                },
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  var date = await CalendarHelper().chooseDate(context, initialDate: widget.person?.dateOfBirth);
                  widget.birthdayController.text = formatDateTime(date);
                  widget.updatePerson?.call(widget.person?.copyWith(dateOfBirth: date));
                },
                child: TextFormField(
                  enabled: false,
                  focusNode: birthdayFocus,
                  cursorColor: Colors.black,
                  controller: widget.birthdayController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: "",
                    icon: Icon(Icons.calendar_month, color: Colors.grey),
                    labelText: 'Birthday',
                    labelStyle: TextStyle(
                      color: grayColor5,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            var images = await CameraHelper().pickMedia(
              context,
              enabledRecording: false,
              showCamera: true,
              maxAssetSelect: 1,
              requestType: RequestType.image,
            );
            if (images.isNotEmpty) {
              var avatarFile = images[0].media;
              widget.updatePerson?.call(widget.person?.copyWith(avatarFile: avatarFile));
            }
          },
          child: _buildAvatar(),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    const double size = 80;
    var placeHolder = Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: defaultAvatar,
      ),
      child: const Icon(
        Icons.person,
        color: grayTextColor3,
        size: 50,
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: DisplayImage(
        fit: BoxFit.fill,
        height: size,
        width: size,
        image: ImagesPickerModel(url: widget.person?.avatar, media: widget.person?.avatarFile),
        placeHolder: placeHolder,
      ),
    );
  }
}
