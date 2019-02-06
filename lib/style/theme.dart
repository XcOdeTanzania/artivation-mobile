import 'dart:ui';
import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  static const prmaryGradient = const LinearGradient(
      colors: const [loginGradientStart, loginGradientEnd],
      stops: const [0.0, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
      );
}
