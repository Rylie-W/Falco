import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';



class SplashScreen extends StatefulWidget {
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  initState() {
    _check();
    super.initState();
  }

  void _check() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Image.asset("assets/graphics/logo.png", width: 140),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.secondary),
                      strokeWidth: 1)))
        ])));
  }
}
