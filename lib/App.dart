import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/menu_screen.dart';
import 'package:artivation/ui/pages/login_page.dart';
import 'package:artivation/ui/zoom_scafford.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class App extends StatefulWidget {
  @override
  AppState createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  final MainModel _model = MainModel();

  var selectedMenuItemId = 'restaurant';

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
          '/': (BuildContext context) => _model.isLoggedIn
              ? ZoomScaffold(
                  menuScreen: MenuScreen(
                    model: _model,
                  ),
                  model: _model,
                )
              : LoginPage()
        },
      ),
      model: _model,
    );
  }
}
