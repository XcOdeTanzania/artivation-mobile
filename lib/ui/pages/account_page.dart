import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _value2 = false;
  void _onChanged2(bool value) {
    setState(() => _value2 = value);
    print(_value2);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: UIData.primaryColor,
            title: Text("Account Seetings",
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
                leading: const Icon(Icons.lock, color: UIData.primaryColor),
                title: Text('Reset Password'),
              ),
              Divider(),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Account'),
                onTap: () {
                  _showDialog(model);
                },
              ),
              Divider(),
              SwitchListTile(
                value: _value2,
                onChanged: _onChanged2,
                title: new Text('Deactivate Account',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  void _showDialog(model) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Delete Account?"),
          content: Text("This will permanently delete your acount"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                model.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }
}
