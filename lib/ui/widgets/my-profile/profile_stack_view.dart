import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/cart_page.dart';
import 'package:artivation/ui/pages/purchased_page.dart';
import 'package:artivation/ui/widgets/my-profile/profile_detail.dart';

import 'package:artivation/ui/widgets/profile/profile_tile.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

Widget profileStackView(BuildContext context, MainModel model) {
  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      ProfileDetail(
        model: model,
      ),
      Card(
          elevation: 4.0,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.23,
              bottom: MediaQuery.of(context).size.height * 0.56,
              left: 20,
              right: 20),
          color: UIData.primaryColor,
          child: SizedBox(
            height: 100.0,
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: ProfileTile(
                    title: 'Purchased',
                    subtitle: "4",
                    iconColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchasedGridList(
                                  model: model,
                                )));
                  },
                ),
                FlatButton(
                  child: ProfileTile(
                    title: 'favorites',
                    subtitle: "18",
                    iconColor: Colors.white,
                  ),
                  onPressed: () {
                    model.filterFavorites();
                    
                  },
                ),
                FlatButton(
                  child: ProfileTile(
                    title: 'cart',
                    subtitle: "5",
                    iconColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShoppingCartPage()));
                  },
                )
              ],
            ),
          )),
    ],
  );
}
