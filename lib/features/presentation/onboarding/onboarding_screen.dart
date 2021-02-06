import 'package:beam/features/presentation/login/page/login_page.dart';
import 'package:beam/features/presentation/onboarding/beam_page.dart';
import 'package:beam/features/presentation/onboarding/goals_page.dart';
import 'package:beam/features/presentation/onboarding/help_startups_page.dart';
import 'package:beam/features/presentation/onboarding/schedule_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OnboardingScreen());
  }

  @override
  State<StatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = [
    Container(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: BeamPage(),
    )),
    Container(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: SchedulePage(),
    )),
    Container(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: GoalsPage(),
    )),
    Container(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: HelpStartupsPage(),
    ))
  ];
  final PageController _pageController = PageController(initialPage: 0);
  final TextStyle _textStyle = TextStyle(fontSize: 20.0);

  int _currentPage = 0;

  List<Widget> buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(Indicator(_currentPage == i));
    }
    return indicators;
  }

  void onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void onLoginPressed(BuildContext context) {
    Navigator.push(context, LoginPage.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.4,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff72ff86), Color(0x4946add5)])),
              )),
          PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: onPageChanged,
          ),
          Positioned.fill(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buildIndicators(),
                        ),
                        const Padding(padding: EdgeInsets.all(4)),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: ButtonTheme(
                                minWidth: 100.0,
                                child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Theme.of(context).primaryColor,
                                    child: MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      onPressed: () {
                                        onLoginPressed(context);
                                      },
                                      child: Text(AppLocalizations.of(context).getStarted,
                                          textAlign: TextAlign.center,
                                          style: _textStyle.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ))))
                      ]))))
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool _isActive;

  Indicator(this._isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8,
      width: _isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: _isActive ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
