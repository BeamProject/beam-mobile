import 'package:beam/common/di/config.dart';
import 'package:beam/features/presentation/auth/auth_bloc.dart';
import 'package:beam/features/presentation/profile/goals_subpage.dart';
import 'package:beam/features/presentation/profile/model/profile_model.dart';
import 'package:beam/features/presentation/settings/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

TextStyle style = TextStyle(fontSize: 20.0);

class ProfilePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<ProfileModel>(),
            child: ProfilePage(
              title: "Dashboard",
            )));
  }

  ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final riveFileName = 'images/planet.riv';
  Artboard? _artboard;
  late final SimpleAnimation _rivePlanetAnimationController;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  _loadRiveFile() async {
    final file = RiveFile.import(await rootBundle.load(riveFileName));

    setState(() => _artboard = file.mainArtboard
      ..addController(
          _rivePlanetAnimationController = SimpleAnimation('Rotate Head')
            ..isActiveChanged.addListener(() {
              if (_rivePlanetAnimationController.isActive) {
                _rivePlanetAnimationController.instance?.animation.loop =
                    Loop.oneShot;
              }
            })));
  }

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
                        top: 13,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    splashColor: Colors.black,
                                    onTap: () {
                                      Navigator.push(
                                          context, SettingsPage.route());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Settings',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    splashColor: Colors.black,
                                    onTap: () =>
                                        context.read<AuthCubit>().onLogout(),
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Logout',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(6)),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    child: _artboard != null
                                        ? Rive(
                                            artboard: _artboard!,
                                            fit: BoxFit.fitHeight,
                                          )
                                        : const SizedBox())),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 12, right: 12),
                                    child: Row(children: [
                                      Text(
                                        "Total steps today:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Padding(padding: EdgeInsets.all(4)),
                                      Consumer<ProfileModel>(
                                          builder: (context, profile, _) {
                                        return Text(
                                          "${profile.steps}",
                                          style: TextStyle(fontSize: 20),
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
                            GoalsSubPage()
                          ],
                        ))
                      ],
                    )),
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
                        Text("Goal: \$${profile.monthlyDonationGoal}",
                            style: TextStyle(
                                color: Color(0xFFBDBDBD), fontSize: 12)),
                      ])
                ]);
              }))),
      Padding(padding: EdgeInsets.all(20)),
      Container(
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Theme.of(context).primaryColor,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {},
                child: Text(AppLocalizations.of(context)!.makePayment,
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )))
    ]);
  }
}
