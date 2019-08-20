import 'dart:async';

import 'package:artivation/models/piece.dart';
import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/cart/shopping_cart_row.dart';
import 'package:artivation/ui/widgets/cart/shopping_cart_summary.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import 'package:artivation/api/api.dart';
import 'dart:convert';
import '../pages/pay_with_pesapal_page.dart';

const double _leftColumnWidth = 60.0;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}
final GlobalKey<ScaffoldState> _cartScaffoldKey = GlobalKey<ScaffoldState>();
class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Widget> _createShoppingCartRows(MainModel model) {
//    return model.piecesInCart.keys
//        .map(
//          (int id) => ShoppingCartRow(
//                piece: model.getPieces()[id],
//                quantity: model.piecesInCart[id],
//                onPressed: () {
//                  //  model.removeItemFromCart( model.getPieces()[id].id);
//                  model.updateCart(model.authenticatedUser.id,
//                      model.getPieces()[id].id, true);
//                },
//              ),
//        )
//        .toList();
    return model.cartPieces
        .map(
          (Piece piece) => ShoppingCartRow(
            piece: piece,
            quantity: 1,
            onPressed: () {
              //  model.removeItemFromCart( model.getPieces()[id].id);
              model.updateCart(model.authenticatedUser.id, piece.id, true);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);
    return Scaffold(
      key: _cartScaffoldKey,
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
                        //initializePayment(2).then((String response){
//                          String url = '${responseMap['scheme']}://${responseMap['host']}${responseMap['path']}?${responseMap['query']}';
//                          print('Scheme: ${responseMap['scheme']}');
//                          print('Host: ${responseMap['host']}');
//                          print('Path: ${responseMap['path']}');
//                          print('Query: ${responseMap['query']}');
                        // print('Complete Url: $response');
                        //  });
                        if(model.cartPieces.length <= 0){
                          _showSnackBar('Your cart is Empty');
                          return;
                        }
                        model.authenticatedUser.phone != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PesaPalPage(
                                    userId: model.authenticatedUser.id,
                                  ),
                                ),
                              )
                            : _showDialog(model);
                        //model.clearCart();
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

  void _showDialog(MainModel model) {
    // flutter defined function
    GlobalKey<FormState> updatePhoneFormKey = GlobalKey();
    Locale myLocale = Localizations.localeOf(context);
    bool _isLoading = false;
    String _message = '';
    // myLocale
    TextEditingController _phoneNumberTextEditingController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, _setDialogState) {
          return AlertDialog(
            title: Text("Enter Phone Number"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Your phone number is required"),
                  Form(
                    key: updatePhoneFormKey,
                    child: TextFormField(
                      controller: _phoneNumberTextEditingController,
                      validator: (String value) {
                        // \+?([0-9]{2})-?([0-9]{3})-?([0-9]{6,7})
                        if (!RegExp(r'\+?([0-9]{2})-?([0-9]{3})-?([0-9]{6,7})')
                            .hasMatch(value)) return 'Invalid phone Number';

                        return null;
                      },
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      _message != null
                          ? Text(
                              _message,
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: _isLoading ? 
                        CircularProgressIndicator() 
                            : Container(),
                      ),
                      SizedBox(height: 70.0,)
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  if (updatePhoneFormKey.currentState.validate()) {
                    _setDialogState(() {
                      _isLoading = true;
                      _message = '';
                    });
                    model
                        .updateUserProfile(
                            phone: _phoneNumberTextEditingController.text)
                        .then((Map<String, dynamic> response) {
                      _setDialogState(() {
                        _message = response['message'];
                        _isLoading = false;
                      });
                      print(response.toString());
                      if (response['success']) Navigator.of(context).pop();
                      //else {}
                    });
                  } else {
                    _setDialogState(() {
                      _message = 'Invalid Phone number';
                    });
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showSnackBar(String value) {
    _cartScaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0), child: Icon(Icons.info_outline,color: Colors.red,)),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "WorkSansSemiBold"),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      duration: Duration(seconds: 3),
    ));
  }
}
