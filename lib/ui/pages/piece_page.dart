import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/cart_page.dart';
import 'package:artivation/ui/pages/drawer_page.dart';
import 'package:artivation/ui/widgets/category/menu_controller.dart';
import 'package:artivation/ui/widgets/piece/art_piece.dart';

import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:badges/badges.dart';

class PiecePage extends StatefulWidget {
  const PiecePage({Key key, this.model, this.menuController}) : super(key: key);
  final MainModel model;
  final MenuController menuController;
  @override
  PiecePageState createState() {
    return new PiecePageState(model, menuController);
  }
}

class PiecePageState extends State<PiecePage> {
  final MainModel _model;
  final MenuController _menuController;
  PiecePageState(this._model, this._menuController);
  @override
  void initState() {
    _model.fetchPieces();
    _model.loadArtists();
    super.initState();
  }

  ShapeBorder _shape;

  @override
  Widget build(BuildContext context) {
    Future<Null> _handleRefresh() async {
      _model.fetchPieces();
      print(_model.getPieces().length);
    }

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: UIData.primaryColor,
            title: Text('Artivation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold")),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  print('searching');
                },
              ),
              BadgeIconButton(
                  itemCount: model.totalCartQuantity, // required
                  icon: Icon(Icons.shopping_cart), // required
                  badgeColor: Colors.red, // default: Colors.red
                  badgeTextColor: Colors.white, // default: Colors.white
                  hideZeroCount: true, // default: true
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShoppingCartPage()));
                  }),
              model.isFavorite
                  ? IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        model.filterFavorites();
                      },
                    )
                  : Container()
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.center,
                  height: 48.0,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                print('open categories');
                                _menuController.toggle();
                              },
                              icon: Icon(
                                Icons.category,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'CATEGORIES',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        onTap: () {
                          print('open categories');
                          _menuController.toggle();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 20),
                      ),
                      Center(
                        child: Text(
                          model.selectedCategory
                              .toString()
                              .replaceAll('Category.', '')
                              .toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: UIData.primaryColor,
            showChildOpacityTransition: false,
            child: ListView.builder(
              itemCount: model.getPieces().length,
              itemExtent: PieceItem.height,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: PieceItem(
                    piece: model.getPieces()[index],
                    shape: _shape,
                  ),
                );
              },
            ), // scroll view
          ),
          drawer: DrawerPage(),
        );
      },
    );
  }
}
