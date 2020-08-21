import 'package:beam/features/data/local/storage.dart';
import 'package:beam/features/data/user_repository_impl.dart';
import 'package:beam/features/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:beam/features/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/data/beam/beam_auth_endpoint.dart';
import 'features/domain/usecases/auto_log_in.dart';
import 'features/domain/usecases/get_current_user.dart';
import 'features/domain/usecases/log_in.dart';
import 'features/domain/usecases/log_out.dart';
import 'features/presentation/auth/auth_bloc.dart';
import 'features/presentation/auth/auth_event.dart';
import 'features/presentation/auth/auth_state.dart';
import 'features/presentation/dashboard/dashboard_page.dart';
import 'features/presentation/login/bloc/login_bloc.dart';
import 'features/presentation/login/page/login_page.dart';
import 'features/presentation/onboarding/onboarding_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  final beamAuthEndpoint = BeamAuthEndpoint();
  final secureStorage = FlutterSecureStorage();
  final storage = Storage(secureStorage);
  final userRepository = UserRepositoryImpl(storage, beamAuthEndpoint);

  final logIn = LogIn(userRepository);
  final getCurrentUser = GetCurrentUser(userRepository);
  final logOut = LogOut(userRepository);
  final autoLogIn = AutoLogIn(userRepository);
  runApp(MultiProvider(providers: [
    BlocProvider(
      create: (_) => AuthBloc(
          getCurrentUser: getCurrentUser, logOut: logOut, autoLogIn: autoLogIn),
    ),
    BlocProvider(
      create: (_) => LoginBloc(logIn),
    ),
    BlocProvider(
      create: (_) => DashboardBloc(getCurrentUser)
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppView();
  }
}

class AppView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;
  
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(AuthenticationAutoLogInRequested());
    return MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('en', '')],
        navigatorKey: _navigatorKey,
        title: 'Beam Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthenticationState>(
              listener: (context, state) {
                if (state.user != null) {
                  _navigator.pushAndRemoveUntil<void>(
                      DashboardPage.route(), (route) => false);
                } else {
                  _navigator.pushAndRemoveUntil<void>(
                      OnboardingScreen.route(), (route) => false);
                }
              },
              child: child);
        },
        onGenerateRoute: (_) => SplashPage.route());
  }
}

