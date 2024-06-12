import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/global.dart';
import 'package:inlovewithher/models/anniversary_model.dart';
import 'package:inlovewithher/route_generator.dart';
import 'package:inlovewithher/ui/edit_anniversary.dart';
import 'package:inlovewithher/ui/edit_profile_screen.dart';

import 'colors.dart';
import 'dialog_utils.dart';
import 'firestore_api.dart';
import 'models/dating_model.dart';

final bottomSheet = BottomSheet();

class BottomSheet {
  /// content flexible height
  Future<dynamic> show(
    BuildContext context, {
    Widget? child,
    Color? barrierColor,
    double borderRadius = 16,
  }) async {
    return await showModalBottomSheet(
      context: context,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.7),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Container(
              alignment: Alignment.center,
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                color: const Color(0xffD2D1D1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
              ),
              child: child,
            ),
          ],
        );
      },
    );
  }
}

class EditBottomSheet extends StatelessWidget {
  const EditBottomSheet({
    Key? key,
    this.anniversary,
  }) : super(key: key);

  final AnniversaryModel? anniversary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: const Text(
            "Tình cảm của bạn và người ấy.",
            style: TextStyle(color: grayTextColor3),
          ),
        ),
        const SizedBox(height: 12),
        if (anniversary != null) ...[
          _buildRow(
            title: "Ngày kỷ niệm hiện tại.",
            content: "Chỉnh sửa thông tin ngày kỷ niệm hiện tại.",
            iconBg: Colors.orange,
            icon: Icons.edit_calendar,
            onTap: () {
              goRouter.pop(context);
              context.pushNamed(EditAnniversary.router, extra: anniversary);
            },
          ),
          const SizedBox(height: 12),
        ],
        _buildRow(
          title: "Thêm ngày kỷ niệm mới.",
          content: "Có ngày kỷ niệm mới? Thêm ngay nào!",
          iconBg: Colors.blue,
          icon: Icons.add_card_sharp,
          onTap: () {
            goRouter.pop(context);
            context.pushNamed(EditAnniversary.router);
          },
        ),
        const SizedBox(height: 12),
        _buildRow(
          title: "Cập nhật hồ sơ.",
          content: "Chỉnh sửa thông tin của bạn và người ấy.",
          iconBg: Colors.pinkAccent,
          icon: Icons.people,
          onTap: () {
            goRouter.pop(context);
            context.pushNamed(EditProfileScreen.router);
          },
        ),
        const SizedBox(height: 12),
        if (anniversary != null) ...[
          _buildRow(
            title: "Xóa kỷ niệm",
            content: "Xóa kỷ niệm này",
            iconBg: Colors.grey,
            icon: Icons.delete,
            onTap: () async {
              goRouter.pop(context);
              bool? delete = await bottomSheet.show(context,
                  child: const ConfirmBottomSheet(
                    title: "Bạn chắc chưa",
                    content: "Xóa làm gì để rồi phải tạo lại",
                    buttonLeftLabel: "Thôi",
                    buttonRightLabel: "Xóa",
                  ));
              if (delete ?? false) {
                var mainCubit = globalContext.read<MainCubit>();
                Loading().show();
                // xóa bản ghi ở bảng "AnniversaryDay";
                await FireStoreApi(collection: 'AnniversaryDay').delete(anniversary?.id);
                DatingModel? datingData = mainCubit.datingData;
                List<String> listAnniversary = datingData?.anniversaryDay ?? [];
                listAnniversary.removeWhere((e) => e == anniversary?.id);
                // update list anniversaryId trong bảng "Dating".
                await FireStoreApi(collection: 'Dating')
                    .updateData(datingData?.id, data: datingData?.copyWith(anniversaryDay: listAnniversary).toParam());
                await mainCubit.getDataDating();
                Loading().dismiss();
              }
            },
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildRow({
    required String title,
    required String content,
    required Function onTap,
    required Color iconBg,
    required IconData icon,
    Color? contentColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: blackTextColor,
                      fontSize: 14,
                      fontFamily: 'SVN-Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  if (content.isNotEmpty)
                    Text(
                      content,
                      style: TextStyle(
                        color: contentColor ?? grayTextColor3,
                        fontSize: 12,
                        fontFamily: 'SVN-Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmBottomSheet extends StatelessWidget {
  const ConfirmBottomSheet({this.title, this.content, this.buttonLeftLabel, this.buttonRightLabel, Key? key})
      : super(key: key);
  final String? title;
  final String? content;
  final String? buttonLeftLabel;
  final String? buttonRightLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Image.asset("assets/images/thinking_emoji.png", height: 64, width: 64),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: blackTextColor, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          if ((content ?? "").isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  content ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: grayTextColor3, fontSize: 13),
                )),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                    title: buttonLeftLabel ?? "Bỏ qua",
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    textColor: mainColor,
                    color: greyBackgroundColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildButton(
                    title: buttonRightLabel ?? "Đồng ý",
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    textColor: Colors.white,
                    color: mainColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildButton({Color? color, Color? textColor, required Function onTap, required String title}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(title, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
