import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIData.primaryColor,
            title: Text('Settings',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold"))
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.accessibility,
            color: UIData.primaryColor,),
            title: Text('Account'),
          ),
          Divider(),
           ListTile(
            leading: Icon(Icons.notifications,
            color: UIData.primaryColor,),
            title: Text('Notifications',
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people,
            color: UIData.primaryColor,),
            title: Text('Invite a friend',
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help,
            color: UIData.primaryColor,),
            title: Text('Help',
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}