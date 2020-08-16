import 'package:beam/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(AppLocalizations.of(context).habitsContent,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white)));
  }
}
