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
      appBar: AppBar(actions: <Widget> [IconButton(icon: Icon(Icons.share), onPressed: () {}),],),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => BottomTopScreen());
                  // pickImage();
              }, 
              icon: Icon(Icons.home)),
            SizedBox(),
            IconButton(onPressed:() {
              
            },icon: Icon(Icons.business)),
            IconButton(onPressed: (){

            }, icon: Icon(Icons.school))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
      /*
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('Warehouse')),
          BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('Achivements')),
        ],
        //currentIndex: _,
        fixedColor: Colors.blue,
        onTap: ,
      ),
      */
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