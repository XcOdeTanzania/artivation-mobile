import 'package:artivation/ui/widgets/my-profile/profile_stack_view.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: "WorkSansSemiBold")),
          backgroundColor: UIData.primaryColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                print('Edit');
              },
            )
          ],
        ),
        body: profileStackView(context));
  }
}
