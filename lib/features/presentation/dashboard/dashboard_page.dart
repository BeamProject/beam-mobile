import 'package:beam/common/di/config.dart';
import 'package:beam/features/presentation/auth/auth_bloc.dart';
import 'package:beam/features/presentation/dashboard/model/dashboard_model.dart';
import 'package:beam/features/presentation/payments/payments_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<DashboardModel>(),
            child: DashboardPage(
              title: "Dashboard",
            )));
  }

  DashboardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Color(0xFF2C2D2D),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Consumer<DashboardModel>(
                builder: (context, dashboard, _) {
                  return Text(
                      "Hello ${dashboard.user?.firstName ?? ""} ${dashboard.user?.lastName ?? ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.white));
                },
              ),
              const Padding(padding: EdgeInsets.all(12)),
              RaisedButton(
                  child: const Text('My payments'),
                  onPressed: () =>
                      Navigator.push(context, PaymentsPage.route())),
              const Padding(padding: EdgeInsets.all(12)),
              RaisedButton(
                  child: const Text('Logout'),
                  onPressed: () => context
                      .bloc<AuthCubit>()
                      .onLogout())
            ])));
  }
}
