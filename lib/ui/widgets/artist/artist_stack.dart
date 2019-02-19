import 'package:artivation/models/artist.dart';
import 'package:artivation/ui/widgets/profile/profile.dart';
import 'package:artivation/ui/widgets/profile/profile_tile.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

Widget stackView(BuildContext context, Artist artist){
return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Profile(artist: artist,),
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
                          subtitle: artist.numberOfPieces.toString(),
                          iconColor: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: ProfileTile(
                          title: 'Bought',
                          subtitle: artist.numberOfPiecesBought.toString(),
                          iconColor: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: ProfileTile(
                          title: 'Likes',
                          subtitle: artist.numberOfLikes.toString(),
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