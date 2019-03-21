import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/artist_page.dart';
import 'package:artivation/ui/pages/cart_page.dart';
import 'package:artivation/ui/pages/login_page.dart';
import 'package:artivation/ui/pages/profile_page.dart';
import 'package:artivation/ui/pages/purchased_page.dart';
import 'package:artivation/ui/pages/settings_page.dart';
import 'package:artivation/ui/pages/terms_and_condition.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_image/network.dart';

const String _kAsset1 = 'assets/kalimwenjuma.jpg';
const String _kAsset2 = 'assets/robbyn.jpg';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(
        const SnackBar(content: Text("The drawer's items don't do anything")));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: UIData.primaryColor,
                ),
                accountName: Text(model.authenticatedUser.username),
                accountEmail: Text(model.authenticatedUser.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      NetworkImageWithRetry(model.authenticatedUser.photoUrl),
                ),
                otherAccountsPictures: <Widget>[
                  model.authenticatedUser1 != null
                      ? GestureDetector(
                          onTap: () {},
                          child: Semantics(
                            label: 'Switch to Account B',
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(_kAsset1),
                            ),
                          ),
                        )
                      : null,
                  model.authenticatedUser2 != null
                      ? GestureDetector(
                          onTap: () {},
                          child: Semantics(
                            label: 'Switch to Account C',
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(_kAsset2),
                            ),
                          ),
                        )
                      : null,
                ],
                margin: EdgeInsets.zero,
                onDetailsPressed: () {
                  _showDrawerContents = !_showDrawerContents;
                  if (_showDrawerContents)
                    _controller.reverse();
                  else
                    _controller.forward();
                },
              ),
              MediaQuery.removePadding(
                context: context,
                // DrawerHeader consumes top MediaQuery padding.
                removeTop: true,
                child: Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 8.0),
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          // The initial contents of the drawer.
                          FadeTransition(
                            opacity: _drawerContentsOpacity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(FontAwesomeIcons.home,
                                      color: UIData.primaryColor),
                                  title: Text('Home'),
                                  onTap: () {
                                    // Update the state of the app
                                    // ...
                                    // Then close the drawer
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                      FontAwesomeIcons.userCircle,
                                      color: UIData.primaryColor),
                                  title: Text('Profile'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  model: model,
                                                )));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.business_center,
                                      color: UIData.primaryColor),
                                  title: Text('Purchased'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PurchasedGridList(
                                                  model: model,
                                                )));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.shopping_cart,
                                      color: UIData.primaryColor),
                                  title: Text('Cart'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShoppingCartPage()));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.favorite,
                                      color: UIData.primaryColor),
                                  title: Text('My Favorite'),
                                  onTap: () {
                                    model.filterFavorites();
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.people,
                                      color: UIData.primaryColor),
                                  title: Text('Artists'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ArtistPage(model)));
                                  },
                                ),
                                Divider(),
                                ListTile(
                                    title: Text(
                                  'Controls',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                                Divider(),
                                ListTile(
                                  leading: const Icon(Icons.settings,
                                      color: UIData.primaryColor),
                                  title: Text('settings'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsPage()));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.security,
                                      color: UIData.primaryColor),
                                  title: Text('Terms & Conditions'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TermsConditionsPage()));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.exit_to_app,
                                      color: UIData.primaryColor),
                                  title: Text('Logout'),
                                  onTap: () {
                                    model.logout();
                                    Navigator.pushReplacementNamed(
                                        context, '/');
                                  },
                                ),
                              ],
                            ),
                          ),
                          // The drawer's "details" view.
                          SlideTransition(
                            position: _drawerDetailsPosition,
                            child: FadeTransition(
                              opacity: ReverseAnimation(_drawerContentsOpacity),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.add,
                                        color: UIData.primaryColor),
                                    title: const Text('Add account'),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage(model: model)));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.settings,
                                        color: UIData.primaryColor),
                                    title: const Text('Manage accounts'),
                                    onTap: _showNotImplementedMessage,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
