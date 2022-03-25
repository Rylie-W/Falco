import 'package:flutter/material.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'dart:async';

class Achievements extends StatelessWidget{
  static const Map<String,int> stateMap = {
  "initialization": 0,
  "encounter": 1,
  "mate": 2,
  "nest": 3,
  "hatch": 4,
  "learn": 5,
  "leavehome": 6,
  "snow owl":7,
  "tawny owl":8,
  "mystery 1":9,
  "mystery 2":10,
  "mystery 3":11,
  };

  static const List<String> imageList= [
    "assets/achievements/initialization.png",
    "assets/achievements/first_encounter.png",
    "assets/achievements/courtship.png",
    "assets/achievements/nesting.png",
    "assets/achievements/newborn.png",
    "assets/achievements/new_coming.png",
    "assets/achievements/snow_owl.png",
    "assets/achievements/tawny_owl.png",
    "assets/achievements/asio_owl.png",
    "assets/achievements/mystery.png",
    "assets/achievements/mystery.png",
    "assets/achievements/mystery.png",
    "assets/achievements/mystery.png",
  ];

  static const List<String> achievementNameList=[
    "Novice Breeder",
    "Arrival of the Kestrel",
    "Time for Love",
    "Nesting",
    "Apprentice Breeder",
    "Adept Breeder",
    "Arrival of the Snowl Owl",
    "Arrival of the Tawny Owl",
    "Arrival of the Asio Owl",
    "Mystery Bird",
    "Mystery Bird",
    "Mystery Bird",
    "Mystery Bird",
  ];//14

  DBHelper dbHelper=DBHelper();
  late double width;
  late double height;

  static const ColorFilter _greyscaleFilter = ColorFilter.matrix(
    <double>[
      0.2126,0.7152,0.0722,0,0,
      0.2126,0.7152,0.0722,0,0,
      0.2126,0.7152,0.0722,0,0,
      0,0,0,0.5,0,
    ]
  );

  Future<int> getIntSate() async{
    String primaryState = await getPrimaryState();
    return stateMap[primaryState]??0;
  }

  @override
  Widget build(BuildContext context){
    this.width = MediaQuery.of(context).size.width;
    this.height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: getIntSate(),
      builder: (BuildContext context, AsyncSnapshot<int> state){
        if (!state.hasData) return const Text('Loading...');
        if (state.hasError) return const Text('Something went wrong.');

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('My Achievements'),
          ),
          body: SingleChildScrollView(
            child:
            new Column(
              children: <Widget>[
                getFirstThreeAchievements(state.requireData),
                getRemainingAchievements(state.requireData)
              ],
            ),
          ),
        );
      });
  }
  
  Widget getRemainingAchievements(int state){
    List<int> states=[2,3,4,5,6,7,8,9,10,11];
    if (state>1&&state<11){
      states.removeAt(state-1);
    }
    else{
      states.removeAt(0);
    }
    return new Column(
      children: [
        new Row(
          children: [
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[0]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[0]])),),
                    Text(
                        achievementNameList[states[0]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[1]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[1]])),),
                    Text(
                        achievementNameList[states[1]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[2]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[2]])),),
                    Text(
                        achievementNameList[states[2]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
          ],
        ),
        new Row(
          children: [
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[3]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[3]])),),
                    Text(
                        achievementNameList[states[3]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[4]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[4]])),),
                    Text(
                        achievementNameList[states[4]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[5]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[5]])),),
                    Text(
                        achievementNameList[states[5]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
          ],
        ),
        new Row(
          children: [
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[6]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[6]])),),
                    Text(
                        achievementNameList[states[6]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[7]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[7]])),),
                    Text(
                        achievementNameList[states[7]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
            new Container(
                width: width/3,
                height: height/5,
                padding: const EdgeInsets.all(10.0),
                child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > states[8]-1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[states[8]])),),
                    Text(
                        achievementNameList[states[8]],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
          ],
        ),
      ],
    );
  }
  
  Widget getFirstThreeAchievements (int state){
    if (state > 0) {
      return  new Row(children: <Widget>[
          new Container(
            width: 2*width/3,
            height: 2*height/5-56,
            padding: const EdgeInsets.all(10.0),
            child:
              new Column(
                children: [
                  Expanded(child: ColorFiltered(colorFilter: state > state? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[state+1])),),
                  Text(
                      achievementNameList[state+1],
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              )
          ),
          new Column(children: <Widget>[
            new Container(
              width: width/3,
              height: height/5-28,
              padding: const EdgeInsets.all(10.0),
              child:
                new Column(
                  children: [
                    Expanded(child: ColorFiltered(colorFilter: state > -1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[0])),),
                    Text(
                        achievementNameList[0],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
            new Container(
              width: width/3,
              height: height/5-28,
              padding: const EdgeInsets.all(10.0),
              child:
              new Column(
                children: [
                  Expanded(child: ColorFiltered(colorFilter: state > 0? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[1])),),
                  Text(
                      achievementNameList[1],
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              )
            )
          ],)
        ],);
    }
    else{
      return  new Row(children: <Widget>[
        new Container(
          width: 2*width/3,
          height: 2*height/5-56,
          padding: const EdgeInsets.all(10.0),
          child:
            new Column(
              children: [
                Expanded(child: ColorFiltered(colorFilter: state > state? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[state+1])),),
                Text(
                    achievementNameList[state+1],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            )
        ),
        new Column(children: <Widget>[
          new Container(
            width: width/3,
            height: height/5-28,
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: [
                Expanded(child: ColorFiltered(colorFilter: state > -1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[0])),),
                Text(
                    achievementNameList[0],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            )
          ),
          new Container(
            width: width/3,
            height: height/5-28,
            padding: const EdgeInsets.all(10.0),
            child:
            new Column(
              children: [
                Expanded(child: ColorFiltered(colorFilter: state > 1? ColorFilter.mode(Colors.transparent, BlendMode.multiply): _greyscaleFilter,child: Image.asset(imageList[2])),),
                Text(
                    achievementNameList[2],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            )
          )
        ],)
      ],);
    }
  }
  

  Future<String> getPrimaryState() async{
    List userValues = await dbHelper.queryAll("users");
    String primaryState = userValues[0].primarystate;
    return primaryState;
  }

}
