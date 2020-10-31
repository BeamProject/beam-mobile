import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentsPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (_) => PaymentsPage(title: "Payments"));
  }

  PaymentsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Color(0xFF2C2D2D),
        body: Center(child: Text("Payments")));
  }
}
