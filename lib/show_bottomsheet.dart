import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inlovewithher/ui/edit_profile_screen.dart';

import 'colors.dart';

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
  }) : super(key: key);

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
            "Cập nhật tình cảm của bạn và người ấy.",
            style: TextStyle(color: grayTextColor3),
          ),
        ),
        const SizedBox(height: 12),
        _buildRow(
          title: "Ngày kỷ niệm hiện tại.",
          content: "Chỉnh sửa thông tin ngày kỷ niệm hiện tại.",
          iconBg: Colors.orange,
          icon: Icons.edit_calendar,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildRow(
          title: "Thêm ngày kỷ niệm mới.",
          content: "Có ngày kỷ niệm mới? Thêm ngay nào!",
          iconBg: Colors.blue,
          icon: Icons.add_card_sharp,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildRow(
          title: "Cập nhật hồ sơ.",
          content: "Chỉnh sửa thông tin của bạn và người ấy.",
          iconBg: Colors.pinkAccent,
          icon: Icons.people,
          onTap: () {
            context.pushNamed(EditProfileScreen.router);
          },
        ),
        const SizedBox(height: 12),
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
