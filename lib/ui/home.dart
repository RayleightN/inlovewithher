import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'anniversary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController();
  late final MainCubit mainCubit;

  @override
  void initState() {
    mainCubit = context.read<MainCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (_) {
          var data = mainCubit.datingData;
          if (data != null) {
            var children = List.generate((data.listAnniversary ?? []).length, (page) {
              return AnniversaryPage(
                page: page,
              );
            }).toList();
            if (children.isEmpty) {
              return const SizedBox();
            }
            return Stack(
              children: [
                PageView(
                  onPageChanged: (page) {
                    mainCubit.updateAnniversaryPage(page);
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
                            onTap: () {
                              mainCubit.editAnniversary(context);
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
              ],
            );
          }
          return const SizedBox();
        },
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
