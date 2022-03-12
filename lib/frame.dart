import 'package:flutter/material.dart';
import 'components/animate_widget.dart';

class Frame extends StatelessWidget {
  bool b = false;
  //anime list
  final List<String> list = [
    'assets/images/fatchicken.png',
  ];

  final GlobalKey<FrameAnimationImageState> _key = new GlobalKey<FrameAnimationImageState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/backyard.png"), fit: BoxFit.cover,),
              ),
            ),
            new Center(
              child: GestureDetector(
                onTap: () {
                  if (b) {
                    _key.currentState?.reset();
                  } else {
                    _key.currentState?.start();
                  }
                  b = !b;
                },
                child: FrameAnimationImage(_key, list, width: 220, height: 200, interval: 50, start: false),
              ),
            )
          ],
        )
    );
  }
}