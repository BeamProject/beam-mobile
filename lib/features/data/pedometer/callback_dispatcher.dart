import 'package:beam/common/di/config.dart';
import 'package:beam/features/domain/usecases/step_tracker_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

void callbackDispatcher() {
  const MethodChannel _backgroundChannel =
      MethodChannel('plugins.beam/step_counter_plugin_background');

  WidgetsFlutterBinding.ensureInitialized();

  // TODO: double check this is necessary and doesn't cause any issues.
  configureDependencies(Environment.prod);
  final stepTrackerInteractor = getIt<StepTrackerInteractor>();

  // TODO: this can race with the Android service sending the 'serviceStarted'
  // event. Consider adding an 'initialized' message, so that the service
  // only sends messages after this dispatcher sets appropriate callbacks.
  _backgroundChannel.setMethodCallHandler((call) async {
    if (call.method == 'serviceStarted') {
      await stepTrackerInteractor.observeStepEvents();
    } else if (call.method == 'serviceStopped') {
      stepTrackerInteractor.stopObservingStepEvents();
    }
  });
}
