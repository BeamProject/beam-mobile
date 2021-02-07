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

  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
              )
            ],
          );
        }));
  }
}
