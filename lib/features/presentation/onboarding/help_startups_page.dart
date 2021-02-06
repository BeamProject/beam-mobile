import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpStartupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(AppLocalizations.of(context).onboardingHelpStartups,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)));
  }
}
