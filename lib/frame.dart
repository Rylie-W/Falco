import 'package:flutter/material.dart';
import 'components/animate_widget.dart';
import 'components/bottomTopScreen.dart';
import 'package:image_picker/image_picker.dart';

class Frame extends StatefulWidget {
  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  bool b = false;
  //anime list
  final List<String> list = [
    'assets/images/fatchicken.png',
  ];
  XFile? image;
  // XFile? image = await picker.pickImage(source: ImageSource.camera);
  Future pickImage() async {
    final image =  await ImagePicker().pickImage(source: ImageSource.camera);
    if(image  == null) return;
    final imageTemp = XFile(image.path);
    setState(() => this.image = imageTemp);
  }


  final GlobalKey<FrameAnimationImageState> _key = new GlobalKey<FrameAnimationImageState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) => BottomTopScreen());
          // pickImage();
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