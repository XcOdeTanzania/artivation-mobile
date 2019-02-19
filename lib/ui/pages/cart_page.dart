import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/cart/shopping_cart_row.dart';
import 'package:artivation/ui/widgets/cart/shopping_cart_summary.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

const double _leftColumnWidth = 60.0;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Widget> _createShoppingCartRows(MainModel model) {
    return model.piecesInCart.keys
        .map(
          (int id) => ShoppingCartRow(
                piece: model.getPieceById(id),
                quantity: model.piecesInCart[id],
                onPressed: () {
                  model.removeItemFromCart(id);
                },
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIData.primaryColor,
        title: Text('Cart'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: _leftColumnWidth,
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                            ),
                          ),
                          SizedBox(
                              width: _leftColumnWidth,
                              child: Text(
                                'CART',
                                style: localTheme.textTheme.subhead
                                    .copyWith(fontWeight: FontWeight.w600),
                              )),
                          const SizedBox(width: 16.0),
                          Text('${model.totalCartQuantity} ITEMS'),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: _createShoppingCartRows(model),
                      ),
                      ShoppingCartSummary(model: model),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: RaisedButton(
                      color: UIData.primaryColor,
                      splashColor: UIData.secondaryColor,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'CHECK OUT',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        model.clearCart();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
