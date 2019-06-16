import 'package:artivation/scoped-models/main.dart';
import 'package:flutter/material.dart';

import 'package:artivation/utils/ui_data.dart';
import 'package:flutter_image/network.dart';

class ProfileDetail extends StatelessWidget {
  final MainModel model;

  const ProfileDetail({Key key, this.model}) : super(key: key);
  Widget topHalf(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Container(
        color: UIData.secondaryColor,
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 8,
                backgroundImage:
                    NetworkImageWithRetry(model.authenticatedUser.photoUrl),
              ),
            ),
            Text(
              model.authenticatedUser.username,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomHalf(BuildContext context) {
    final List<Widget> tiles = <Widget>[
      const SizedBox(height: 8.0, width: 0.0),
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: ListTile(
          leading: Icon(
            Icons.person,
            color: UIData.primaryColor,
          ),
          title: Text(model.authenticatedUser.username),
          trailing: Icon(
            Icons.edit,
            color: UIData.primaryColor,
          ),
        ),
      ),
      Divider(),
      Padding(
        padding: EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(
            Icons.email,
            color: UIData.primaryColor,
          ),
          title: Text(model.authenticatedUser.email),
          trailing: Icon(
            Icons.edit,
            color: UIData.primaryColor,
          ),
        ),
      ),
      Divider(),
      Padding(
        padding: EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(
            Icons.phone,
            color: UIData.primaryColor,
          ),
          title: Text(model.authenticatedUser.phone != null ? model.authenticatedUser.phone: 'Insert Phone number'),
          trailing: Icon(
            Icons.edit,
            color: UIData.primaryColor,
          ),
        ),
      ),
      Divider(),
      Padding(
        padding: EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(
            Icons.people_outline,
            color: UIData.primaryColor,
          ),
          title: Text(model.authenticatedUser.sex != null ? model.authenticatedUser.sex : 'Set your sex'),
          trailing: Icon(
            Icons.edit,
            color: UIData.primaryColor,
          ),
        ),
      ),
    ];

    return Flexible(
      flex: 4,
      child: Container(
        color: Colors.white,
        child: ListView(padding: EdgeInsets.only(top: 20), children: tiles),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[topHalf(context), bottomHalf(context)],
    );
  }
}
