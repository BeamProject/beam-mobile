import 'package:beam/common/di/config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(generateForDir: ['lib'])
void configureDependencies(String env) => $initGetIt(getIt, environment: env);
