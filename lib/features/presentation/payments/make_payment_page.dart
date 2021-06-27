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
                      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: TextField(
                              readOnly:
                                  model.paymentStatus == PaymentStatus.DEFAULT
                                      ? false
                                      : true,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 48),
                              decoration: InputDecoration(
                                  prefixText: "\$",
                                  hintText: "0",
                                  labelText: "Make a donation",
                                  labelStyle: TextStyle(
                                      fontSize: 32,
                                      color: Theme.of(context).hintColor)),
                              onChanged: (value) {
                                model.onTextFieldChanged(value);
                              }))),
                  Expanded(
                      child: Container(
                    child: getPaymentStatusWidget(model),
                    alignment: Alignment.center,
                  )),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 15.0),
                      child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: model.paymentStatus == PaymentStatus.DEFAULT && !model.isTextFieldEmpty
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed:
                                model.paymentStatus == PaymentStatus.DEFAULT && !model.isTextFieldEmpty
                                    ? () => model.makePayment(model.paymentAmount)
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

  Widget getPaymentStatusWidget(PaymentsModel model) {
    switch (model.paymentStatus) {
      case PaymentStatus.DEFAULT:
        return Container();
      case PaymentStatus.SUCCESS:
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                width: double.infinity,
                height: 100,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("images/tick.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(12)),
              Text(
                "Payment successful",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              )
            ]));
      case PaymentStatus.FAILURE:
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                width: double.infinity,
                height: 100,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("images/cross.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(12)),
              Text(
                "Something went wrong",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              )
            ]));
      case PaymentStatus.IN_PROGRESS:
        return CircularProgressIndicator(
            value: null, semanticsLabel: 'Payment in progress');
    }
  }
}
