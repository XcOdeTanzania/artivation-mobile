import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final title;
  final subtitle;
  final textColor;
  final iconColor;
  ProfileTile(
      {this.title,
      this.subtitle,
      this.textColor = Colors.white,
      this.iconColor = Colors.blue});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title.toString(),
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold, color: textColor),
        ),
        Text(
          subtitle.toString(),
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.normal, color: textColor),
        )
      ],
    );
  }
}
