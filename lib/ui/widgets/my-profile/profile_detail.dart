import 'package:flutter/material.dart';

import 'package:artivation/utils/ui_data.dart';

class ProfileDetail extends StatelessWidget {
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
                backgroundImage: AssetImage('assets/saida.jpg'),
              ),
            ),
            Text(
              'Sam Baseif',
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
          title: Text('Sam Baseif'),
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
          title: Text('sambaseif12@gmail.com'),
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
          title: Text('+255-715-785-672'),
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
          title: Text('Female'),
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
