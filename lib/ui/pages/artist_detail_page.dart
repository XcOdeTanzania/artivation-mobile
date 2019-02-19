import 'package:artivation/models/artist.dart';
import 'package:artivation/ui/widgets/artist/artist_stack.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

class ArtistDetail extends StatelessWidget {
  final Artist artist;

  const ArtistDetail({Key key, this.artist}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Artist Detail',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: "WorkSansSemiBold")),
          backgroundColor: UIData.primaryColor,
        ),
        body: stackView(context, artist));
  }
}
