import 'package:flutter/material.dart';

final _scaffoldState = GlobalKey<ScaffoldState>();
Widget homeScaffold(BuildContext context) => Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: Scaffold(key: _scaffoldState, body: Container()),
    );
