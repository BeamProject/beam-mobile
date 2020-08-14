import 'package:beam/features/data/local/storage.dart';
import 'package:beam/features/data/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'features/data/beam/beam_auth_endpoint.dart';
import 'features/domain/usecases/auto_log_in.dart';
import 'features/domain/usecases/get_current_user.dart';
import 'features/domain/usecases/log_in.dart';
import 'features/domain/usecases/log_out.dart';
import 'features/presentation/bloc/auth_bloc.dart';
import 'features/presentation/bloc/auth_event.dart';
import 'features/presentation/bloc/auth_state.dart';
import 'features/presentation/login/bloc/login_bloc.dart';
import 'features/presentation/login/page/login_page.dart';

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
        navigatorKey: _navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthenticationState>(
              listener: (context, state) {
                print('auth status: ' + state.user.toString());
                if (state.user != null) {
                  _navigator.pushAndRemoveUntil<void>(
                      MyHomePage.route(), (route) => false);
                } else {
                  _navigator.pushAndRemoveUntil<void>(
                      LoginPage.route(), (route) => false);
                }
              },
              child: child);
        },
        onGenerateRoute: (_) => LoginPage.route());
  }
}

class MyHomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => MyHomePage(
              title: "Beam",
            ));
  }

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
