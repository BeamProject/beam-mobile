import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 120.0,
        child: Image.asset(
          "images/beam_logo.png",
          fit: BoxFit.contain,
        ),
      ),
      const Padding(padding: EdgeInsets.all(12)),
      Text(AppLocalizations.of(context)?.appTitle ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50))
    ]));
  }
}
