import 'package:flutter/material.dart';
import 'package:less_waste/Pages/homePage.dart';
import 'package:less_waste/components/achievements.dart';
import 'components/bottomTopScreen.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class Frame extends StatefulWidget {
  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  bool b = false;

  //Create Databse Object
  DBHelper dbhelper = DBHelper();
  DateTime selectedDate = DateTime.now();
  int timeNow = DateTime.now().millisecondsSinceEpoch;
  // navigationbar related
  AnimationController? animationController;

  
  Future<void> insertItem() async {
    //Insert a new Food butter
    var butter = Food(id: 0,
        name: 'butter',
        category: 'MilkProduct',
        boughttime: timeNow,
        expiretime: 156432,
        quantitytype: 'pieces',
        quantitynum: 3,
        consumestate: 0.50,
        state: 'good');
    await dbhelper.insertFood(butter);
    var egg = Food(id: 1,
        name: 'eggs',
        category: 'Meat',
        boughttime: timeNow,
        expiretime: 1654757,
        quantitytype: 'number',
        quantitynum: 4,
        consumestate: 0,
        state: 'good');
    await dbhelper.insertFood(egg);

    //Insert a new UserValue instance
    var user1 = UserValue(name: "user1",
        negative: 0,
        positive: 0,
        primarystate: "initial",
        secondarystate: "satisfied",
        secondaryevent: "single",
        thirdstate: "move",
        species: "folca",
        childrennum: 0,
        fatherstate: "single",
        motherstate: "single",
        time: timeNow);
    await dbhelper.insertUser(user1);
    print(await dbhelper.queryAll("users"));

    //await dbhelper.testDB();
  }
  Future<void> insertItem_withoutUser() async {
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


  //bottom navigation

  int currentPage = 1;
  GlobalKey bottomNavigationKey = GlobalKey();
  _getPage(int page) {
    switch (page) {
      case 0:
        return BottomTopScreen();
      case 1:
        return HomePage();
      default:
      return Achievements();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.book, title: "List"),
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.flag, title: "Achievement")
        ],
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
            // insertItem();
          });
        },
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
    );

  }
}


