import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(AppLocalizations.of(context).onboardingCustomizeSchedule,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)));
  }
}
