import 'package:artivation/ui/widgets/artist/artist_stack.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

class ArtistDetail extends StatelessWidget {
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
        body: stackView(context));
  }
}
