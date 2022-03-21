import 'package:flutter/material.dart';
import 'package:less_waste/Pages/InputPage.dart';
import 'package:less_waste/components/achievements.dart';
import 'components/animate_widget.dart';
import 'components/bottomTopScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'package:rive/rive.dart';
import 'dart:convert';

import 'components/quantityDialog.dart';

class Frame extends StatefulWidget {
  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  bool b = false;

  //Create Databse Object
  DBHelper dbhelper = DBHelper();
<<<<<<< HEAD
  DateTime selectedDate = DateTime.now();
  int timeNow = DateTime.now().millisecondsSinceEpoch;
=======
>>>>>>> 813f98cbe716d784ea2f6fc8575d50e0be7302ad

  Future<void> insertItem() async {
    //Insert a new Food butter
    var butter = Food(
        id: 0,
        name: 'butter',
        category: 'MilkProduct',
        boughttime: 154893,
        expiretime: 156432,
        quantitytype: 'pieces',
        quantitynum: 3,
        consumestate: 0.50,
        state: 'good');
    await dbhelper.insertFood(butter);
    var egg = Food(
        id: 1,
        name: 'eggs',
        category: 'Meat',
        boughttime: 134554,
        expiretime: 1654757,
        quantitytype: 'number',
        quantitynum: 4,
        consumestate: 0,
        state: 'good');
    await dbhelper.insertFood(egg);

         //Insert a new UserValue instance
      var user1 = UserValue(name: "user1", negative: 0, positive: 0, primarystate: "initial", secondarystate: "satisfied", secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 0, fatherstate: "single", motherstate: "single", time: timeNow);
      await dbhelper.insertUser(user1);
      print(await dbhelper.queryAll("users"));
    //await dbhelper.testDB();

    //print('###################################third##################################');
    //print(await dbhelper.queryAll("foods"));
  }

  //anime list
  final List<String> list = [
    'assets/images/fatchicken.png',
  ];
  XFile? image;

  // XFile? image = await picker.pickImage(source: ImageSource.camera);
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemp = XFile(image.path);
    setState(() => this.image = imageTemp);
  }

  final GlobalKey<FrameAnimationImageState> _key =
      new GlobalKey<FrameAnimationImageState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    insertItem();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => BottomTopScreen());
                    // pickImage();
                  },
                  icon: Icon(Icons.home)),
              //SizedBox(),
              IconButton(
                  onPressed: () {
                    insertItem();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => InputPage());
                  },
                  icon: Icon(Icons.business)),
              IconButton(
                  onPressed: () {
                    insertItem();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => Achievements());
                  },
                  icon: Icon(Icons.school)),
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
            insertItem();
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
                image: new DecorationImage(
                  image: new AssetImage("assets/images/backyard.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new Center(
              child: RiveAnimation.asset('assets/anime/normal_bird_male.riv'),
            )
          ],
        ));
  }
}
