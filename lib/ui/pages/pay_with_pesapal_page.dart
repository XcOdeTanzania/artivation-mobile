import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'after_payment_page.dart';
import '../../utils/ui_data.dart';

class PesaPalPage extends StatefulWidget {
  final int userId;

  const PesaPalPage({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PesaPalState();
  }
}

class _PesaPalState extends State<PesaPalPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains('pesapalCallback')) {
        print('Don\'t go to $url ');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AfterPaymentPage()));
      }
    });

    return WebviewScaffold(
      url:
          "https://artivation.co.tz/backend/api/pesapalIframe/${widget.userId}",
      withJavascript: true,
      appBar: AppBar(
        backgroundColor: UIData.primaryColor,
        title: Text('Pay with PesaPal'),
      ),
      initialChild: Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            semanticsLabel: 'Loading..',
            backgroundColor: UIData.primaryColor,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
