import 'package:artivation/ui/pages/account_page.dart';
import 'package:artivation/ui/pages/help_page.dart';
import 'package:artivation/ui/pages/notification_page.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

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
                  fontFamily: "WorkSansSemiBold"))),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.accessibility,
              color: UIData.primaryColor,
            ),
            title: Text('Account'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: UIData.primaryColor,
            ),
            title: Text(
              'Notifications',
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.people,
              color: UIData.primaryColor,
            ),
            title: Text(
              'Invite a friend',
            ),
            onTap: () {
              Share.share(
                  'Join us at Artivation to buy portraits from professional Artists! check us out our website @ https://artivation.co.tz/ , or download our apps on iOS and android https://play.google.com/store/apps/details?id=com.qlicue.artivation');
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.help,
                color: UIData.primaryColor,
              ),
              title: Text(
                'Help',
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HelpPage()));
              }),
          Divider()
        ],
      ),
    );


  }
}
