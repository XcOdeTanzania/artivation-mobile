import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: UIData.primaryColor,
            title: Text("Help Desk",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold")),
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              ListTile(
                  leading: const Icon(Icons.call, color: UIData.primaryColor),
                  title: Text('Call Us'),
                  onTap: () {
                    print('Call Us');
                    _launchURL("tel:+255756210703");
                  }),
              Divider(),
              ListTile(
                leading:
                    const Icon(Icons.mail_outline, color: UIData.primaryColor),
                title: Text('Message us'),
                onTap: () {
                  print('Message');
                  _launchURL("sms:+255756210703");
                },
              ),
              Divider(),
              ListTile(
                  leading: const Icon(Icons.email, color: UIData.primaryColor),
                  title: Text(' Email us'),
                  onTap: () {
                    print('Email us');
                    _launchURL(
                        "mailto:artivation18@gmail.com?subject=Hello&body=Sir/Madam");
                  }),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  void _launchURL(String uri) async {
    String url = uri;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not launch';
    }
  }
}
