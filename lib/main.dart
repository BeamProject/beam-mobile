import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_service.dart';
import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/local/user_storage.dart';
import 'package:beam/features/data/payment_repository_impl.dart';
import 'package:beam/features/data/user_repository_impl.dart';
import 'package:beam/features/domain/usecases/make_delayed_payment.dart';
import 'package:beam/features/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:beam/features/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/data/beam/beam_payment_repository.dart';
import 'features/data/beam/beam_user_repository.dart';
import 'features/domain/usecases/auto_log_in.dart';
import 'features/domain/usecases/get_current_user.dart';
import 'features/domain/usecases/log_in.dart';
import 'features/domain/usecases/log_out.dart';
import 'features/presentation/auth/auth_bloc.dart';
import 'features/presentation/auth/auth_event.dart';
import 'features/presentation/auth/auth_state.dart';
import 'features/presentation/dashboard/dashboard_page.dart';
import 'features/presentation/login/bloc/login_bloc.dart';
import 'features/presentation/onboarding/onboarding_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  final secureStorage = FlutterSecureStorage();
  final userStorage = UserStorage(secureStorage);
  final authStorage = AuthStorage(secureStorage);
  final beamService = BeamService();
  final authTokenManager = AuthTokenManager(authStorage);
  final beamServiceAuthWrapper =
      BeamServiceAuthWrapper(authTokenManager, beamService);
  final beamUserRepository =
      BeamUserRepository(beamServiceAuthWrapper, beamService, authTokenManager);
  final userRepository = UserRepositoryImpl(userStorage, beamUserRepository);
  final beamPaymentRepository = BeamPaymentRepository(beamServiceAuthWrapper);
  final paymentRepository = PaymentRepositoryImpl(beamPaymentRepository);
  final makeDelayedPayment = MakeDelayedPayment(paymentRepository, userRepository);

  final logIn = LogIn(userRepository);
  final observeUser = ObserveUser(userRepository);
  final logOut = LogOut(userRepository);
  final autoLogIn = AutoLogIn(userRepository);
  runApp(MultiProvider(providers: [
    BlocProvider(
      create: (_) => AuthBloc(
          getCurrentUser: observeUser, logOut: logOut, autoLogIn: autoLogIn),
    ),
    BlocProvider(
      create: (_) => LoginBloc(logIn),
    ),
    BlocProvider(create: (_) => DashboardBloc(observeUser))
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
        supportedLocales: [
          const Locale('en', '')
        ],
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
