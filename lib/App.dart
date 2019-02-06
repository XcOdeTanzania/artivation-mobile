import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/login_page.dart';
import 'package:artivation/ui/pages/piece_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class App extends StatelessWidget {
  final MainModel _model = MainModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      child: MaterialApp(
        title: 'Artivation',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
       
        routes: {
          '/':(BuildContext context)=> _model.isLoggedIn ? PiecePage(): LoginPage()
        },
      ),
      model: _model,
    );
  }
}
