import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading {
  Timer _timer = Timer(const Duration(milliseconds: 1), () {});
  late int _start;

  static final _singleton = Loading._();

  Loading._();

  factory Loading() => _singleton;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _start = 60;
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        // print(_start.toString());
        if (_start <= 0) {
          timer.cancel();
          dismiss();
        } else {
          _start--;
        }
      },
    );
  }

  void show({bool ignoreContentClick = true}) {
    startTimer();
    BotToast.showCustomLoading(
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        align: Alignment.center,
        ignoreContentClick: ignoreContentClick,
        duration: const Duration(seconds: 60),
        toastBuilder: (cancel) {
          return PopScope(
            onPopInvoked: (_) async {
              return Future.value(!ignoreContentClick);
            },
            child: SpinKitThreeBounce(
              size: 30,
              color: Colors.blueAccent.withOpacity(0.8),
            ),
          );
        },
        backgroundColor: const Color(0xff73000000),
        backButtonBehavior: ignoreContentClick ? BackButtonBehavior.ignore : BackButtonBehavior.close,
        enableKeyboardSafeArea: true,
        crossPage: true);
  }

  void dismiss() {
    _timer.cancel();
    BotToast.closeAllLoading();
  }
}
