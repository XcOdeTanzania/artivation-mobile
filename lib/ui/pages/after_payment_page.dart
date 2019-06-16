import 'package:flutter/material.dart';
import '../../utils/ui_data.dart';

class AfterPaymentPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Artivation'),
      ),
      body: Center(
        child: Text('Thank You !!',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: UIData.primaryColor),),
      )
    );
  }

}