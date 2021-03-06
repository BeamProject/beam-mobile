import 'package:beam/features/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';

import 'common/di/config.dart';
import 'features/presentation/auth/auth_bloc.dart';
import 'features/presentation/auth/auth_state.dart';
import 'features/presentation/profile/profile_page.dart';
import 'features/presentation/onboarding/onboarding_screen.dart';


void main() {
  configureDependencies(Environment.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AuthCubit>(), child: AppScreen());
  }
}

class AppScreen extends StatefulWidget {
  
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthCubit>(context);
    authBloc.onAutoLogIn();
    return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorKey: _navigatorKey,
        title: 'Beam Project',
        theme: ThemeData(
          primarySwatch: Colors.green,
          backgroundColor: Colors.white,
          hintColor: Colors.grey,
          disabledColor: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Inter',
        ),
        builder: (context, child) {
          return BlocListener<AuthCubit, AuthenticationState>(
              listener: (context, state) {
                if (state.user != null) {
                  _navigator?.pushAndRemoveUntil<void>(
                      ProfilePage.route(), (route) => false);
                } else {
                  _navigator?.pushAndRemoveUntil<void>(
                      OnboardingScreen.route(), (route) => false);
                }
              },
              child: child);
        },
        onGenerateRoute: (_) => SplashPage.route());
  }
}
