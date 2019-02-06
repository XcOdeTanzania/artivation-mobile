import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/menu/ios/menu_ios.dart';
import 'package:flutter/material.dart';

Widget bodyDataIOS(MainModel model, BuildContext context) => SliverList(
        delegate: SliverChildListDelegate(
            model.allMenus.map((menu) => menuIOS(menu,MediaQuery.of(context).size, context)).toList()),
      );
