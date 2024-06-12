import 'package:flutter/material.dart';

class BackgroundBarScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double heightTrigger;
  final double? heightAppBar;
  final Color colorBegin;
  final Color colorEnd;
  final bool showBoxShadow;

  const BackgroundBarScroll(
      {super.key,
        required this.scrollController,
        this.heightTrigger = 150,
        this.heightAppBar,
        this.colorBegin = Colors.transparent,
        this.colorEnd = const Color(0xff327DBF),
        this.showBoxShadow = true});

  @override
  _BackgroundBarScrollState createState() => _BackgroundBarScrollState();
}

class _BackgroundBarScrollState extends State<BackgroundBarScroll> with TickerProviderStateMixin {
  late final Animation<Color?> _animation;
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 0));
    _animation = ColorTween(begin: widget.colorBegin, end: widget.colorEnd).animate(_animationController);
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    _animationController.animateTo(widget.scrollController.position.pixels / widget.heightTrigger);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _animation.value,
                boxShadow: widget.showBoxShadow
                    ? [
                  if (_animation.value != widget.colorBegin)
                    BoxShadow(color: Colors.black.withOpacity(0.3), offset: const Offset(0, 1), blurRadius: 4),
                ]
                    : null,
              ),
              height: widget.heightAppBar ?? MediaQuery.of(context).padding.top,
            ),
          ],
        );
      },
    );
  }
}
