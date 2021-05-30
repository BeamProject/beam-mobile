import 'package:beam/features/presentation/payments/model/payments_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/di/config.dart';

class PaymentsPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<PaymentsModel>(),
            child: PaymentsPage(title: "Payments")));
  }

  PaymentsPage({Key? key, required this.title}) : super(key: key);

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
        body: Center(child: Consumer<PaymentsModel>(
          builder: (context, model, _) {
            final payments = model.payments;
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Container(
                      height: 50,
                      color: Colors.white,
                      child: Center(child: Text('Entry ${payment.id} -> ${payment.amount}')));
                });
          },
        )));
  }
}
