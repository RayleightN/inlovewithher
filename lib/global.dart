import 'package:flutter/material.dart';

class Keys {
  static final navKey = GlobalKey<NavigatorState>();

  static BuildContext getContext() {
    return navKey.currentContext!;
  }
}

BuildContext get globalContext => Keys.getContext();
