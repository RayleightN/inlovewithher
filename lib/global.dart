import 'package:flutter/material.dart';

class Keys {
  static final navKey = GlobalKey<NavigatorState>();

  static BuildContext getContext() {
    return navKey.currentContext!;
  }
}

Future<void> hideKeyboard(BuildContext context) async {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

BuildContext get globalContext => Keys.getContext();
