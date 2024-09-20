import 'package:flutter/material.dart';

class ThemeColors {
  final BuildContext context;

  ThemeColors.of(this.context);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get color => isDark ? Colors.white : Colors.black;
}
