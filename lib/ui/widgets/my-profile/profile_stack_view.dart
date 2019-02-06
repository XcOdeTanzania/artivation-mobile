import 'package:artivation/ui/widgets/my-profile/profile_detail.dart';

import 'package:artivation/ui/widgets/profile/profile_tile.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

Widget profileStackView(BuildContext context){
return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ProfileDetail(),
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
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: ProfileTile(
                          title: 'favorites',
                          subtitle: "18",
                          iconColor: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: ProfileTile(
                          title: 'cart',
                          subtitle: "5",
                          iconColor: Colors.white,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                )),
          ],
        );
}