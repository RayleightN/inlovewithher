import 'package:flutter/material.dart';
import 'package:inlovewithher/global.dart';

class ScreenUtils {
  double get height => MediaQuery.of(globalContext).size.height;
  double get width => MediaQuery.of(globalContext).size.width;
  double get pdTop => MediaQuery.of(globalContext).padding.top;
  double get pdBot => MediaQuery.of(globalContext).padding.bottom;
}
