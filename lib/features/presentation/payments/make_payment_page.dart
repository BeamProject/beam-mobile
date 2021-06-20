import 'package:beam/features/presentation/payments/model/payments_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/di/config.dart';

TextStyle style = TextStyle(fontSize: 20.0);

class MakePaymentPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<PaymentsModel>(),
            child: MakePaymentPage(title: "Make a donation")));
  }

  MakePaymentPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  int _paymentAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(child: Consumer<PaymentsModel>(
          builder: (context, model, _) {
            return Container(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 32),
                      child: Text(
                        "Make a donation",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 40),
                      )),
                  Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: getTextWidget(model))),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 15.0),
                      child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: model.paymentStatus == PaymentStatus.DEFAULT
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed:
                                model.paymentStatus == PaymentStatus.DEFAULT
                                    ? () => model.makePayment(_paymentAmount)
                                    : null,
                            child: Text(
                                AppLocalizations.of(context)!.makePayment,
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )))
                ],
              ),
            );
          },
        )));
  }

  Widget getTextWidget(PaymentsModel model) {
    switch (model.paymentStatus) {
      case PaymentStatus.DEFAULT:
        return Container(
            margin: const EdgeInsets.only(top: 25),
            child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 53),
                decoration: InputDecoration(prefixText: "\$", hintText: "0"),
                onChanged: (value) {
                  _paymentAmount = int.parse(value);
                }));
      case PaymentStatus.SUCCESS:
        return Center(
            child: Text("Success",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 50)));
      case PaymentStatus.FAILURE:
        return Center(
            child: Text(
          "Payment failed, something went wrong",
          style: TextStyle(fontSize: 50),
          textAlign: TextAlign.center,
        ));
      case PaymentStatus.IN_PROGRESS:
        return Center(
            child: Text("In progress", style: TextStyle(fontSize: 50)));
    }
  }
}
