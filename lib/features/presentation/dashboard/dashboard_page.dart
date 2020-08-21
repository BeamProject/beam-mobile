import 'package:beam/features/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:beam/features/presentation/dashboard/bloc/dashboard_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => DashboardPage(
              title: "Beam",
            ));
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
        body: Center(child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Text("Hello ${state.username}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white));
          },
        )));
  }
}