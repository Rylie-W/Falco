import 'package:flutter/material.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'dart:async';

class Achievements extends StatelessWidget{
  final Map<String,int> _stateMap = {
  "initialization": 0,
  "first encounter": 1,
  "courtship": 2,
  "nesting": 3,
  "incubation": 4,
  "growing up": 5,
  "leaving home": 6
  };

  DBHelper dbHelper=DBHelper();

  static const ColorFilter _greyscaleFilter = ColorFilter.matrix(
    <double>[
      0.2126,0.7152,0.0722,0,0,
      0.2126,0.7152,0.0722,0,0,
      0.2126,0.7152,0.0722,0,0,
      0,0,0,0.5,0,
    ]
  );

  @override
  Widget build(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    int? state=_stateMap[getPrimaryState()];
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Achievements'),
      ),
      body: Column(
        children: [
          new Column(
            children: <Widget>[
              new Row(children: <Widget>[
                new Container(
                  width: 2*width/3,
                  height: 2*width/3,
                  padding: const EdgeInsets.all(10.0),
                  child: ColorFiltered(colorFilter: state! > 5? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset("assets/achievements/new_coming.png")),
                ),
                new Column(children: <Widget>[
                  new Container(
                    width: width/3,
                    height: width/3,
                    padding: const EdgeInsets.all(10.0),
                    child: ColorFiltered(colorFilter: state! > 4? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset("assets/achievements/assets/achievements/newborn.png")),
                  ),
                  new Container(
                    width: width/3,
                    height: width/3,
                    padding: const EdgeInsets.all(10.0),
                    child: ColorFiltered(colorFilter: state! > 3? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset("assets/achievements/assets/achievements/nesting.png")),
                  )
                ],)
              ],),
              new Row(children: <Widget>[
                new Container(
                  width: width/3,
                  height: width/3,
                  padding: const EdgeInsets.all(10.0),
                  child: ColorFiltered(colorFilter: state! > 4? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset("assets/achievements/assets/achievements/courtship.png")),
                ),
                new Container(
                  width: width/3,
                  height: width/3,
                  padding: const EdgeInsets.all(10.0),
                  child: ColorFiltered(colorFilter: state! > 4? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset("assets/achievements/assets/achievements/first_encounter.png")),
                ),
                new Container(
                  width: width/3,
                  height: width/3,
                  padding: const EdgeInsets.all(10.0),
                  child: ColorFiltered(colorFilter: state! > 4? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset("assets/achievements/assets/achievements/newborn.png")),
                ),
              ],)
            ],
          ),
          // Row(
          //   children: [ColorFiltered(colorFilter: state! > -1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: ,)],
          // ),
        ],
      ),
    );
  }

  Future<String> getPrimaryState() async{
    List userValues = await dbHelper.queryAll("users");
    String primaryState=userValues.last['primarystate'];
    return primaryState;
  }

}
