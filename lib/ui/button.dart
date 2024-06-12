import 'package:flutter/material.dart';
import '../colors.dart';

class FooterButton extends StatelessWidget {
  const FooterButton({
    required this.title,
    required this.onTap,
    this.btnColor = mainColor,
    this.additionalWidget,
    this.isEnabled = true,
    this.topWidget,
    Key? key,
  }) : super(key: key);
  final String title;
  final Function? onTap;
  final Color btnColor;
  final Widget? additionalWidget;
  final bool isEnabled;
  final Widget? topWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          if (topWidget != null) ...[
            topWidget!,
            const SizedBox(height: 12),
          ],
          MyButton(
            isEnabled: isEnabled,
            border: 24,
            color: btnColor,
            isPadding: false,
            onPressed: () {
              if (onTap != null) onTap!();
            },
            title: title,
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  final bool isEnabled;
  final bool isPadding;
  final double height;
  final Color color;
  final Color textColor;
  final double border;
  final Color? borderColor;

  const MyButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.isPadding = true,
    this.height = 44,
    this.isEnabled = true,
    this.color = mainColor,
    this.border = 10.0,
    this.textColor = Colors.white,
    this.borderColor,
  }) : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isEnabled) {
          widget.onPressed();
        }
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.isPadding == true ? 16 : 0),
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          border: widget.borderColor != null ? Border.all(color: widget.borderColor!) : null,
          color: widget.isEnabled ? widget.color : grayTextColor2,
          borderRadius: BorderRadius.all(Radius.circular(widget.border)),
        ),
        child: Center(
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
