import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/home/ios/ios_body_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

Widget homeBodyIOS(BuildContext context) {
  return ScopedModelDescendant(
    builder: (BuildContext context, Widget child, MainModel model) {
      return model.allMenus.length > 0
          ? bodyDataIOS(model, context)
          : Center(
              child: CircularProgressIndicator(),
            );
    },
  );
}
