import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/menu_screen.dart';
import 'package:artivation/ui/pages/login_page.dart';
import 'package:artivation/ui/zoom_scafford.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'ui/pages/pay_with_pesapal_page.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      child: MaterialApp(
        title: 'Artivation',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) => _isAuthenticated
              ? ZoomScaffold(
                  menuScreen: MenuScreen(
                    model: _model,
                  ),
                  model: _model,
                )
              : LoginPage(
                  model: _model,
                ),
          'payment': (BuildContext context) => PesaPalPage()
        },
      ),
      model: _model,
    );
  }
}
