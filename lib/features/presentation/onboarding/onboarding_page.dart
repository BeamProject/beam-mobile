import 'package:flutter/cupertino.dart';

class OnboardingPage extends StatelessWidget {
  final String _assetPath;
  final String _text;
  final TextStyle _textStyle;
  final double _imageHeight;

  OnboardingPage(this._assetPath, this._text, this._textStyle,
      {double imageHeight = 200})
      : _imageHeight = imageHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Container(
              width: double.infinity,
              height: _imageHeight,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(_assetPath),
                  fit: BoxFit.fitHeight,
                ),
              )),
          const Padding(padding: EdgeInsets.all(12)),
          Text(_text, textAlign: TextAlign.center, style: _textStyle)
        ]));
  }
}
