import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: UIData.primaryColor,
            title: Text("Notications",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold")),
          ),
          body: Container(
            child: Center(
              child: Text(
                'No notifications for you',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}
