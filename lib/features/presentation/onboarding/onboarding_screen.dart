import 'package:beam/features/presentation/login/page/login_page.dart';
import 'package:beam/features/presentation/onboarding/beam_page.dart';
import 'package:beam/features/presentation/onboarding/donations_page.dart';
import 'package:beam/features/presentation/onboarding/habits_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OnboardingScreen());
  }

  @override
  State<StatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _pagesCount = 3;
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  List<Widget> buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pagesCount; i++) {
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
      backgroundColor: Color(0xFF2C2D2D),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              Container(
                child: BeamPage(),
              ),
              Container(
                child: HabitsPage(),
              ),
              Container(
                child: DonationsPage(),
              )
            ],
            onPageChanged: onPageChanged,
          ),
          Positioned.fill(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: buildIndicators(),
                      )))),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonTheme(
                      minWidth: 100.0,
                      child: RaisedButton(
                          color: Color(0xFF6EC496),
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () => onLoginPressed(context)))))
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
        color: _isActive ? Color(0xFF6EC496) : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
