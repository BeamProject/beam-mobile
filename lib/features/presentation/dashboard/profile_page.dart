import 'package:beam/common/di/config.dart';
import 'package:beam/features/presentation/dashboard/model/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<ProfileModel>(),
            child: ProfilePage(
              title: "Dashboard",
            )));
  }

  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Stack(children: [
                    Container(
                        decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("images/bg_gradient.png"),
                        fit: BoxFit.fill,
                      ),
                    )),
                    Positioned.fill(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Settings"),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Profile",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Logout",
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(12)),
                        Expanded(
                            flex: 1,
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                    decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage("images/earth.png"),
                                    fit: BoxFit.fitHeight,
                                  ),
                                )))),
                        Padding(padding: EdgeInsets.all(12)),
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(children: [
                                  Text(
                                    "Total steps today:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(padding: EdgeInsets.all(4)),
                                  Consumer<ProfileModel>(
                                      builder: (context, profile, _) {
                                    return Text(
                                      "${profile.steps}",
                                    );
                                  })
                                ])))
                      ],
                    ))
                  ])),
              Expanded(
                flex: 3,
                child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(12),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: Color(0xFFE8E8E8), width: 1),
                                    color: Color(0xFFF6F6F6)),
                                child: TabBar(
                                  labelColor: Theme.of(context).primaryColor,
                                  unselectedLabelColor: Color(0xFFBDBDBD),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white),
                                  tabs: [
                                    Tab(
                                      text: "Donations",
                                    ),
                                    Tab(
                                      text: "Goals",
                                    ),
                                  ],
                                ))),
                        Expanded(
                            child: TabBarView(
                          children: [
                            _getDonationsView(context),
                            Icon(Icons.directions_transit),
                          ],
                        ))
                      ],
                    )),
                // Consumer<DashboardModel>(
                //   builder: (context, dashboard, _) {
                //     return Column(children: <Widget>[
                //       Text(
                //           "Hello ${dashboard.user?.firstName ?? ""} ${dashboard.user?.lastName ?? ""}",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 25,
                //               color: Colors.white)),
                //       const Padding(padding: EdgeInsets.all(12)),
                //       Text("Steps ${dashboard.steps}",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 50,
                //               color: Colors.white)),
                //       const Padding(padding: EdgeInsets.all(12)),
                //       RaisedButton(
                //           child: Text(
                //               "${dashboard.stepTrackingButtonText}"),
                //           onPressed: () => Provider.of<DashboardModel>(
                //                   context,
                //                   listen: false)
                //               .onStepTrackingButtonPressed()),
                //     ]);
                //   },
                // ),
                // const Padding(padding: EdgeInsets.all(12)),
                // RaisedButton(
                //     child: const Text('My payments'),
                //     onPressed: () =>
                //         Navigator.push(context, PaymentsPage.route())),
                // const Padding(padding: EdgeInsets.all(12)),
                // RaisedButton(
                //     child: const Text('Logout'),
                //     onPressed: () =>
                //         context.bloc<AuthCubit>().onLogout())
              ),
            ])));
  }

  Widget _getDonationsView(BuildContext context) {
    return Column(children: [
      Padding(padding: EdgeInsets.all(12)),
      Text(
        "Your donations this month",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Padding(padding: EdgeInsets.all(12)),
      Expanded(
          child: AspectRatio(
              aspectRatio: 1,
              child: Consumer<ProfileModel>(builder: (context, profile, _) {
                return Stack(alignment: Alignment.center, children: [
                  Positioned.fill(
                      child: CircularProgressIndicator(
                    // We invert colors and value to make the progress bar go anti-clockwise
                    backgroundColor: Theme.of(context).primaryColor,
                    valueColor: AlwaysStoppedAnimation(Color(0xFFE8E8E8)),
                    value: 1 - (profile.monthlyDonationGoalPercentage / 100),
                    strokeWidth: 1,
                  )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$${profile.totalAmountOfPaymentsThisMonth}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 23),
                        ),
                        Text("${profile.monthlyDonationGoalPercentage}% spent",
                            style: TextStyle(
                                color: Color(0xFFBDBDBD), fontSize: 12)),
                      ])
                ]);
              }))),
      Padding(padding: EdgeInsets.all(20)),
    ]);
  }
}
