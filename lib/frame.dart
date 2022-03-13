import 'package:flutter/material.dart';
import 'components/animate_widget.dart';
import 'components/bottomTopScreen.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => BottomTopScreen());
        },
      ),
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