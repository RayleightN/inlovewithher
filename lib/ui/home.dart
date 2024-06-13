import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inlovewithher/colors.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/ui/components.dart';
import '../models/image_picker_model.dart';
import '../models/person_model.dart';
import '../route_generator.dart';
import '../screen_utils.dart';
import '../utils.dart';
import 'anniversary_page.dart';
import 'display_image.dart';
import 'edit_profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();
  late final MainCubit mainCubit;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    mainCubit = context.read<MainCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          SystemNavigator.pop();
        }
      },
      canPop: false,
      child: AnnotatedRegion(
        value: lightStatusBar,
        child: Scaffold(
          body: BlocBuilder<MainCubit, MainState>(
            builder: (context, state) {
              var data = mainCubit.datingData;
              if (data == null) {
                return const SizedBox();
              }
              var childrenPage = List.generate((data.listAnniversary ?? []).length, (page) {
                return AnniversaryPage(
                  page: page,
                );
              }).toList();
              List<PersonModel> people = data.listPeople ?? [];
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  childrenPage.isNotEmpty
                      ? PageView(
                          onPageChanged: (page) {
                            mainCubit.updateAnniversaryPage(page);
                          },
                          controller: controller,
                          children: childrenPage,
                        )
                      : Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0xFFFFF2F9), Color(0xFFFDF3E8)],
                            ),
                          ),
                        ),
                  SafeArea(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                var index = mainCubit.anniversaryPage;
                                if (data.listAnniversary!.length == 1) {
                                  index = 0;
                                }
                                mainCubit.editAnniversary(context,
                                    anniversary: ((data.listAnniversary ?? []).isNotEmpty)
                                        ? data.listAnniversary![index]
                                        : null);
                              },
                              child: buildIcon(Icons.edit),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await mainCubit.changeAnniversaryBackground(context);
                              },
                              child: buildIcon(Icons.camera_alt),
                            ),
                          ],
                        )),
                  ),
                  buildRowPeople(people),
                  Container(
                    margin: EdgeInsets.only(bottom: ScreenUtils().pdBot + 84),
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      "assets/gif/heart.gif",
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool _onPopInvoked() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast("Nhấn lần nữa để thoát");
      return true;
    }
    return false;
  }

  Widget buildRowPeople(List<PersonModel> people) {
    if (people.length < 2) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        goRouter.pushNamed(EditProfileScreen.router);
      },
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: buildInformation(people.first)),
              Expanded(
                child: buildInformation(people.last),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInformation(PersonModel person) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildAvatar(imageUrl: person.avatar),
        const SizedBox(height: 4),
        Text(
          "${person.name}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAgeZodiac(
                bgColor: Colors.orange, text: calculateAge(person.dateOfBirth).toString(), icon: person.getIconSex()),
            const SizedBox(width: 8),
            buildAgeZodiac(
              bgColor: mainColor,
              text: getZodiac(person.dateOfBirth).name,
              iconPath: getZodiac(person.dateOfBirth).imagePath,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAvatar({String? imageUrl}) {
    const double size = 80;
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: DisplayImage(
        fit: BoxFit.fill,
        height: size,
        width: size,
        image: ImagesPickerModel(url: imageUrl),
      ),
    );
  }

  Widget buildAgeZodiac({required Color bgColor, String? text, IconData? icon, String? iconPath}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ],
          if (iconPath != null) ...[
            Image.asset(iconPath, fit: BoxFit.fill, width: 20, height: 20),
            const SizedBox(width: 4),
          ],
          Text(
            "$text",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildIcon(IconData icon) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.3),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ));
  }
}
