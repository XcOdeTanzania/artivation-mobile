
import 'package:artivation/ui/widgets/home/android/home_android.dart';
import 'package:artivation/ui/widgets/home/ios/ios_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return defaultTargetPlatform == TargetPlatform.iOS ? homeIOS(context)
        : homeScaffold(context);
  }
}