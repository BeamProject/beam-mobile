import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Image.asset(
            'images/beam_logo.png',
          ),
          SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.appTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Theme.of(context).primaryColor),
          )
        ])));
  }
}
