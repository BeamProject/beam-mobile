import 'package:beam/common/di/config.dart';
import 'package:beam/features/presentation/settings/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<SettingsModel>(),
            child: SettingsPage(
              title: "Settings",
            )));
  }

  SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

enum DialogResult { OK, CANCEL }

class _SettingsPageState extends State<SettingsPage> {
  int? _dialogDonationGoalValue;
  int? _dialogStepsGoalValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Consumer<SettingsModel>(builder: (context, settings, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                title: const Text("Track steps"),
                value: settings.isStepTrackerRunning,
                onChanged: (newValue) {
                  settings.onStepCounterServiceStatusChanged(newValue);
                },
              ),
              ListTile(
                  title: const Text("Set monthly donation goal"),
                  trailing: Text("\$ ${settings.monthlyDonationGoal}"),
                  onTap: () async {
                    if (await _showNumberFieldDialog(
                            "\$",
                            "${settings.monthlyDonationGoal}",
                            'Set monthly donation goal',
                            (value) =>
                                _dialogDonationGoalValue = int.parse(value)) ==
                        DialogResult.OK) {
                      final dialogDonationGoalValue = _dialogDonationGoalValue;
                      if (dialogDonationGoalValue != null) {
                        settings.onMonthlyDonationGoalChanged(
                            dialogDonationGoalValue);
                      }
                    }
                  }),
              ListTile(
                  title: const Text("Set steps goal"),
                  trailing: Text("${settings.dailyStepsGoal}"),
                  onTap: () async {
                    if (await _showNumberFieldDialog(
                            "",
                            "${settings.dailyStepsGoal}",
                            'Set daily steps goal',
                            (value) =>
                                _dialogStepsGoalValue = int.parse(value)) ==
                        DialogResult.OK) {
                      final dialogStepsGoalValue = _dialogStepsGoalValue;
                      if (dialogStepsGoalValue != null) {
                        settings.onStepsGoalChanged(dialogStepsGoalValue);
                      }
                    }
                  })
            ],
          );
        }));
  }

  Future<DialogResult?> _showNumberFieldDialog(String prefixText,
      String hintText, String labelText, Function(String) onChanged) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(top: 32, left: 32, right: 32),
              content: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixText: prefixText,
                    labelText: labelText,
                    hintText: hintText),
                onChanged: onChanged,
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, DialogResult.CANCEL);
                    }),
                TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context, DialogResult.OK);
                    })
              ],
            ));
  }
}
