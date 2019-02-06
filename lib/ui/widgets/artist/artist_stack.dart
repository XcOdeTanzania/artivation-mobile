import 'package:artivation/ui/widgets/profile/profile.dart';
import 'package:artivation/ui/widgets/profile/profile_tile.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

Widget stackView(BuildContext context){
return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Profile(),
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
                          title: 'Pieces',
                          subtitle: "54",
                          iconColor: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: ProfileTile(
                          title: 'Bought',
                          subtitle: "18",
                          iconColor: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: ProfileTile(
                          title: 'Likes',
                          subtitle: "12",
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