import 'dart:ffi';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Pages/AchievementPage.dart';
import '../Pages/InputPage.dart';
import 'dialog.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'datePicker.dart';
import 'dart:async';


class BottomTopScreen extends StatefulWidget {
  @override
  _BottomTopScreenState createState() => _BottomTopScreenState();
}

class _BottomTopScreenState extends State<BottomTopScreen> with TickerProviderStateMixin{
  TextEditingController nameController = TextEditingController();
  TextEditingController expireTimeController = TextEditingController();
  TextEditingController boughtTimeController = TextEditingController();
  TextEditingController quanTypeController = TextEditingController();
  TextEditingController quanNumController = TextEditingController();
  TextEditingController quanNumAndTypeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void dispose(){
    //Clean up all controllers when the widget is disposed
    nameController.dispose();
    expireTimeController.dispose();
    boughtTimeController.dispose();
    quanNumController.dispose();
    quanTypeController.dispose();
    categoryController.dispose();
    super.dispose();
  }
  
  //FocusNode focusNode1 = FocusNode();
  //FocusNode focusNode2 = FocusNode();
  //FocusScopeNode? focusScopeNode;

  Map<String, String> GlobalCateIconMap = {
    "seafood": "assets/category/seafood.png",
    "Meat": "assets/category/meat.png",
    "Milk": "assets/category/milk.png",
    "Milk Product": "assets/category/cheese.png",
    "Fruit": "assets/category/fruits.png",
    "Egg": "assets/category/egg.png",
    "Vegetable": "assets/category/vegetable.png",
    "Others": "assets/category/others.png"
  };

  String foodName = '';
  bool showSuggestList = false;
  List<String> items = [];
  List<String> itemsWaste = [];
  //List<String> items = ['eggs','milk','butter];
  DateTime timeNowDate = new DateTime.now();
  int timeNow = DateTime.now().millisecondsSinceEpoch;

  //Create Databse Object
  DBHelper dbhelper = DBHelper();
  List food = ['name', '', -1, -1, '', -1, -1.0, ''];

  //check the primary state of uservalue should be updated or not; if so, update to the latest
  Future<void> updateStates() async{
    var user1 = await dbhelper.queryAll('users');
    int value = user1[0].positive - user1[0].negative;
    String primaryState;
    String check = checkIfPrimaryStateChanged(value);
    String secondaryState = user1[0].secondarystate;

    if (value < 2){
      primaryState='initialization';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if (value <= 6){
      //judge the primary state
      primaryState='encounter';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 6 && value <= 14){
      primaryState='mate';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 14 && value <= 30){
      primaryState='nest';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 30 && value <= 46){
      primaryState='hatch';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 46 && value <= 78){
      primaryState='learn';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 78 && value <= 82){
      primaryState='leavehome';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 82 && value <= 91) {
      primaryState = 'snow owl';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 91 && value <= 100){
      primaryState='tawny owl';
      await dbhelper.updateUserPrimary(primaryState);
    }

    if (secondaryState=="true"&&check!="None"){
        await dbhelper.updateUserSecondary("false");
    }
  }
  
  Future<void> insertItem() async{
       //Insert a new Food butter
      var butter = Food(name: 'butter', category: 'cheese', boughttime: 154893, expiretime: 156432, quantitytype: 'Piece', quantitynum: 3, consumestate: 0.50, state: 'good');
      await dbhelper.insertFood(butter);
      var egg = Food(name: 'eggs', category: 'Egg', boughttime: 134554, expiretime: 1654757, quantitytype: 'Number', quantitynum: 4, consumestate: 0, state: 'good');
      await dbhelper.insertFood(egg);

      //await dbhelper.testDB();

      //print('###################################third##################################');
      //print(await dbhelper.queryAll("foods"));
  }


  Future<void> insertDB(List _food) async{

    //var maxId = await dbhelper.getMaxId();
    //print('##########################MaxID = $maxId###############################');
    //maxId = maxId + 1;
    var newFood = Food(name: _food[0], category: _food[1], boughttime: _food[2], expiretime: _food[3], quantitytype: _food[4], quantitynum: _food[5], consumestate: _food[6], state: _food[7]);
    print(newFood);

    await dbhelper.insertFood(newFood);
    print(await dbhelper.queryAll('foods'));

  }

   Future<List<dynamic>> getAllItems(String dbname) async {
    //await insertItem();

    //get all foods name as a list of string
    List<dynamic> items = await dbhelper.queryAll(dbname);
    //print('##################################first######################################');
    //print(items);

    return items;
  }

  Future<List<String>> getItemName() async {
    //await insertItem();

    //get all foods name as a list of string
    List<String> items = await dbhelper.getAllUncosumedFoodStringValues('name');
    //print('##################################first######################################');
    //print(items);

    return items;
  }

  Future<List<String>> getItemCategory() async {
    //await insertItem();

    //get all foods name as a list of string
    List<String> category = await dbhelper.getAllUncosumedFoodStringValues('category');
    //print('##################################first######################################');
    //print(items);

    return category;
  }


  Future<List<int>> getItemQuanNum() async{
    //get all foods quantity number as a list of integers
    List<int> num = await dbhelper.getAllUncosumedFoodIntValues('quantitynum');

    return num;
  }

   Future<List<String>> getItemQuanType() async{
    //get all foods quantity number as a list of integers
    List<String> type = await dbhelper.getAllUncosumedFoodStringValues('quantitytype');

    return type;
  }

   Future<List<DateTime>> getItemExpiringTime() async{
    List<int> expire = await dbhelper.getAllUncosumedFoodIntValues('expiretime') ;
    var expireDate = List<DateTime>.generate(expire.length, (i) => DateTime.fromMillisecondsSinceEpoch(expire[i]));
    return expireDate;
  }

  Future<List<DateTime>> getItemBoughtTime() async{
    List<int> boughttime = await dbhelper.getAllUncosumedFoodIntValues('boughttime') ;
    var boughtDate = List<DateTime>.generate(boughttime.length, (i) => DateTime.fromMillisecondsSinceEpoch(boughttime[i]));
    return boughtDate;
  }

  Future<void> addItemName(value) async {
  
    List<String> items = await dbhelper.getAllUncosumedFoodStringValues('name');
    //items = await getItemName();
    //print(items);
      
    setState(() {    
      items.add(value);
    });
  }

  Future<void> addItemExpi(value) async {

    List<int> expires = await dbhelper.getAllUncosumedFoodIntValues('expiretime');
    print(expires);

      
    setState(() {
      
      expires.add(value);
    });
  }

  Future<void> editItem(index, value) async{
      items = await getItemName();
    setState(() async{
      items[index] = value;
    });
  }

  Future<void> deleteItem(String value) async{
      //items = await getItemName();
      await dbhelper.deleteFood(value);

  }


  Future<void> updateFoodState(String name, String attribute) async{
     var updatedFood = await dbhelper.queryOne('foods', name);
     print(updatedFood);
     if(attribute == 'consumed'){
     //var consumedFoodUpdate = Food(id: id, name: name, category: updatedFood[0].category, boughttime: updatedFood[0].boughttime, expiretime: updatedFood[0].expiretime, quantitytype: updatedFood[0].quantitytype, quantitynum: 0, consumestate: 1.0, state: 'consumed');
      await dbhelper.updateFoodConsumed(name, 'consumed');
      print(await dbhelper.queryAll('foods'));
     }
     else{
      //var wastedFoodUpdate = Food(id: id, name: name, category: updatedFood[0].category, boughttime: updatedFood[0].boughttime, expiretime: updatedFood[0].expiretime, quantitytype: updatedFood[0].quantitytype, quantitynum: updatedFood[0].quantitynum, consumestate: 1.0, state: 'wasted');
      await dbhelper.updateFoodWaste(name);
      print(await dbhelper.queryAll('foods'));
     }
  }

  //edit the state to 'consumed' and consumestate to 1, and user positive data adds 1
  //the arugument should be 'positive'(which means positive + 1) or 'negative'(which means negative + 1)
  Future<void> updateUserValue(String state) async{
    var user1 = await dbhelper.queryAll('users');
    //int value = user1[0]['positive'] - user1[0]['negative'];
    print('================= user =================');
    print(user1);

    if(state == 'positive'){
      //judge the primary state
      var uservalue = UserValue(name: user1[0].name, negative: user1[0].negative, positive: user1[0].positive + 1, primarystate: user1[0].primarystate, secondarystate: 'true', secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 0, fatherstate: "single", motherstate: "single", time: timeNow);
      await dbhelper.updateUser(uservalue);
      await updateStates();
      print(await dbhelper.queryAll("users"));
      }
    else{
      var uservalue = UserValue(name: user1[0].name, negative: user1[0].negative + 1, positive: user1[0].positive, primarystate: user1[0].primarystate, secondarystate: 'true', secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 0, fatherstate: "single", motherstate: "single", time: timeNow);
      await dbhelper.updateUser(uservalue);
      await updateStates();
      print(await dbhelper.queryAll("users"));
    }

  }

  String checkIfPrimaryStateChanged(int value){
    if (value==0){
      return Achievements.stateList[0];
    }
    else if (value==2){
      return Achievements.stateList[1];
    }
    else if (value==7){
      return Achievements.stateList[2];
    }
    else if (value==15){
      return Achievements.stateList[3];
    }
    else if (value==31){
      return Achievements.stateList[4];
    }
    else if (value==47){
      return Achievements.stateList[5];
    }
    else if (value==79){
      return Achievements.stateList[6];
    }
    else if (value==83){
      return Achievements.stateList[7];
    }
    else if (value==92){
      return Achievements.stateList[8];
    }
    else{
      return "None";
    }
  }

  var txt = TextEditingController();
  late TooltipBehavior _tooltipBehavior;
  //late bool _isLoading;
  late TabController _tabController;

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    //_controller = TabController(length: 3, vsync: this);
    //Future.delayed(Duration(seconds: 3)).then((value) {
      //setState(() {
        //_isLoading = false;
      //});
    //});
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    DateTime dateToday = new DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    Color color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.storefront), text: "Current"),
            Tab(icon: Icon(Icons.restore_from_trash_sharp), text: "Wasted"),
            Tab(icon: Icon(Icons.business), text: "Plan"),
          ],
        ),
        title: Text("Item List", style: new TextStyle(color: Colors.white),),
        toolbarHeight: 20,
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              TextField(
                style: new TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: "SegoeUI",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0
                ),
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    hintStyle: TextStyle(fontWeight: FontWeight.w300),
                    hintText: "Search"
                ),
              ),
              Expanded(
                child: FutureBuilder(
        future: Future.wait([
          getItemName(),
          getItemExpiringTime(),
          getItemQuanNum(),
          getItemQuanType(),
          getItemCategory(),
          getItemBoughtTime(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

          if (!snapshot.hasData)
            return const Text('Loading...'); // still loading
          // alternatively use snapshot.connectionState != ConnectionState.done
          if (snapshot.hasError) return const Text('Something went wrong.');
          List<String> items = snapshot.requireData[0];
          print('#################$items#########################');
          if (items.length < 1) {
          return Center(
              child: Text("Nothing yet...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
          //sort by remaining expiring time
          snapshot.requireData.add(
              getRemainingExpiringTime(snapshot.requireData[1]));
          List<dynamic> foodItems = getFoodItems(snapshot.requireData);


          // snapshot.requireData.add(value);
          items = List<String>.from(foodItems[0]);
          print('###################################$items#################################');
          final List<DateTime> expires = List<DateTime>.from(foodItems[1]);
          final List<int> num = List<int>.from(foodItems[2]);
          final List<String> type = List<String>.from(foodItems[3]);
          final List<String> categoryies = List<String>.from(foodItems[4]);
          final List<DateTime> boughtTime = List<DateTime>.from(foodItems[5]);
          final List<Duration> remainingTime = List<Duration>.from(foodItems[6]);
          return ListTileTheme(
              contentPadding: EdgeInsets.all(15),
              textColor: Colors.black54,
              style: ListTileStyle.list,
              dense: true,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    //how to show the quantity tyoe and quantity number?

                    //var expires = getItemExpiringTime();
                    //how to show the listsby sequence of expire time?
                    var remainDays = remainingTime[index].inDays;
                    var progressPercentage = remainDays / (expires[index].difference(boughtTime[index])
                        .inDays);
                    var foodNum = num[index];
                    var foodType = type[index];

                    var category = categoryies[index];

                    return buildItem(
                        item,
                        remainDays,
                        foodNum,
                        foodType,
                        index,
                        category,
                        progressPercentage
                    );
                  }
            )
          );
        }
      )
                ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                child: GestureDetector(
                  child: RiveAnimation.asset(
                    'assets/anime/wasted.riv',
                  ),
                ),
              ),       
             Expanded(
               child: FutureBuilder(
        future: Future.wait([
          getWasteItemString('name'),
        
          //getWasteItemInt('expiretime'),
          getWasteItemInt('quantitynum'),
          getWasteItemString('quantitytype'),
          getWasteItemString('category'),
          //getWasteItemInt('boughttime'),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

          if (!snapshot.hasData)
            return const Text('Loading...'); // still loading
          // alternatively use snapshot.connectionState != ConnectionState.done
          if (snapshot.hasError) return const Text('Something went wrong.');
          List<String> itemsWaste = snapshot.requireData[0];
          print('#####################3${snapshot.requireData}##########################');
          if (itemsWaste.length < 1) {
            return Center(
              child: Text("Nothing yet...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
      
          //List<dynamic> foodItems = getFoodItems(snapshot.requireData);

          //final List<DateTime> expires = List<DateTime>.from(foodItems[1]);
          List<int> num = snapshot.requireData[1];
          List<String> type = snapshot.requireData[2];
          List<String> categoryies = snapshot.requireData[3];

          return ListTileTheme(
              contentPadding: EdgeInsets.all(15),
              textColor: Colors.black54,
              style: ListTileStyle.list,
              dense: true,
              child: ListView.builder(
                
                  itemCount: itemsWaste.length,
                  itemBuilder: (context, index) {
                    var item = itemsWaste[index];
                    //how to show the quantity tyoe and quantity number?

                    //var expires = getItemExpiringTime();
                    //how to show the listsby sequence of expire time?
                    //var remainDays = remainingTime[index].inDays;
                    //var progressPercentage = remainDays / (expires[index].difference(boughtTime[index]).inDays);
                    var foodNum = num[index];
                    var foodType = type[index];

                    var category = categoryies[index];

                    return buildWasteItem(
                        item,
                        //remainDays,
                        foodNum,
                        foodType,
                    
                        category);
                        //progressPercentage);
                  }
              )
          );
        }
    )
               ),       
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    child: RiveAnimation.asset(
                    'assets/anime/noWasted.riv',
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'No wasted now, keep it!',
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],

                    totalRepeatCount: 4,
                    pause: const Duration(milliseconds: 100000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
            ],
          ),
         
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        tooltip: "Add item",
        onPressed: () {
          // clear out txt buffer before entering new screen
          txt.value = new TextEditingValue();
          //pushAddItemPage();
          pushAddItemScreen();
        },
      ),
    );
    }


  Future<List<String>> getWasteItemString(String value) async{
    List<Map<String, dynamic>> items = await dbhelper.getAllWastedFoodList();
    print('#################################$items############################');
    List<String> WasteName = List<String>.generate(items.length, (i) => items[i][value]);
    return WasteName;
  }

   Future<List<int>> getWasteItemInt(String value) async{
    List<Map<String, dynamic>> items = await dbhelper.getAllWastedFoodList();
    List<int> WasteName = List<int>.generate(items.length, (i) => items[i][value]);
    return WasteName;
  }

  Widget buildWasteList() {
    return FutureBuilder(
        future: Future.wait([
          getWasteItemString('name'),
          //getWasteItemInt('expiretime'),
          getWasteItemInt('quantitynum'),
          getWasteItemString('quantitytype'),
          getWasteItemString('category'),
          //getWasteItemInt('boughttime'),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData)
            return const Text('Loading...'); // still loading
          // alternatively use snapshot.connectionState != ConnectionState.done
          if (snapshot.hasError) return const Text('Something went wrong.');
          List<String> itemsWaste = snapshot.requireData[0];
          if (itemsWaste.length < 1) {
            return Center(
              child: Text("Nothing yet...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
      
          //List<dynamic> foodItems = getFoodItems(snapshot.requireData);

          //final List<DateTime> expires = List<DateTime>.from(foodItems[1]);
          List<int> num = snapshot.requireData[1];
          List<String> type = snapshot.requireData[2];
          List<String> categoryies = snapshot.requireData[3];
          print('###################$Category##############$num#####################3$type#######################$itemsWaste##################');

          return ListTileTheme(
              contentPadding: EdgeInsets.all(15),
              textColor: Colors.black54,
              style: ListTileStyle.list,
              dense: true,
              child: ListView.builder(              
                  itemCount: itemsWaste.length,
                  itemBuilder: (context, index) {
                    var item = itemsWaste[index];
                    //how to show the quantity tyoe and quantity number?

                    //var expires = getItemExpiringTime();
                    //how to show the listsby sequence of expire time?
                    //var remainDays = remainingTime[index].inDays;
                    //var progressPercentage = remainDays / (expires[index].difference(boughtTime[index]).inDays);
                    var foodNum = num[index];
                    var foodType = type[index];

                    var category = categoryies[index];

                    return buildWasteItem(
                        item,
                        //remainDays,
                        foodNum,
                        foodType,
                        category);
                        //progressPercentage);
                  }
              )
          );
        }
    );
  }

  Widget buildWasteItem(String item, int num, String type, String category ) {
    var categoryIconImagePath = null;
    var progressColor = null;
    if(GlobalCateIconMap[category] == null) {
      categoryIconImagePath = GlobalCateIconMap["Others"];
    } else {
      categoryIconImagePath = GlobalCateIconMap[category];
    };
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10.0),
      child: Column(
      children:[
        Flexible(
                flex: 1,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Oh No! You have wasted $num $type $item already...',
                      textStyle: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 100000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
        ),
      Flexible(
                flex: 1,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Image(
                          image: AssetImage(categoryIconImagePath),
                          width: 32,
                          height: 32,
                        ),
                      ),
                      title: Text(item, style: TextStyle( fontSize: 25), ),
                      // subtitle: Text("Expired in $expire days", style: TextStyle(fontStyle: FontStyle.italic),),
                      trailing: Text("$num $type", style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 24,
                      )),
                    ),
                  ],
                )
      ),
      ]
    ),
    );
  }
  

  Widget buildList() {
    //items = await getItemName();
    return FutureBuilder(
        future: Future.wait([
          getItemName(),
          getItemExpiringTime(),
          getItemQuanNum(),
          getItemQuanType(),
          getItemCategory(),
          getItemBoughtTime(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData)
            return const Text('Loading...'); // still loading
          // alternatively use snapshot.connectionState != ConnectionState.done
          if (snapshot.hasError) return const Text('Something went wrong.');
          List<String> items = snapshot.requireData[0];
          if (items.length < 1) {
            return Center(
              child: Text("Nothing yet...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
          //sort by remaining expiring time
          snapshot.requireData.add(
              getRemainingExpiringTime(snapshot.requireData[1]));
          List<dynamic> foodItems = getFoodItems(snapshot.requireData);


          // snapshot.requireData.add(value);
          items = List<String>.from(foodItems[0]);
          final List<DateTime> expires = List<DateTime>.from(foodItems[1]);
          final List<int> num = List<int>.from(foodItems[2]);
          final List<String> type = List<String>.from(foodItems[3]);
          final List<String> categoryies = List<String>.from(foodItems[4]);
          final List<DateTime> boughtTime = List<DateTime>.from(foodItems[5]);
          final List<Duration> remainingTime = List<Duration>.from(
              foodItems[6]);
          return ListTileTheme(
              contentPadding: EdgeInsets.all(15),
              textColor: Colors.black54,
              style: ListTileStyle.list,
              dense: true,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    //how to show the quantity tyoe and quantity number?

                    //var expires = getItemExpiringTime();
                    //how to show the listsby sequence of expire time?
                    var remainDays = remainingTime[index].inDays;
                    var progressPercentage = remainDays / (expires[index]
                        .difference(boughtTime[index])
                        .inDays);
                    var foodNum = num[index];
                    var foodType = type[index];

                    var category = categoryies[index];

                    return buildItem(
                        item,
                        remainDays,
                        foodNum,
                        foodType,
                        index,
                        category,
                        progressPercentage);
                  }
              )
          );
        }
    );
  }

  Widget buildItem(String text, int expire, int foodNum, String foodType, int index, String category, double progressPercentage ) {
    var categoryIconImagePath = null;
    var progressColor = null;
    if(GlobalCateIconMap[category] == null) {
      categoryIconImagePath = GlobalCateIconMap["Others"];
    } else {
      categoryIconImagePath = GlobalCateIconMap[category];
    };
    if(progressPercentage > 0 && progressPercentage < 49) {
      progressColor = Colors.green;
    } else if (progressPercentage >= 49 && progressPercentage < 66) {
      progressColor = Colors.yellow;
    } else if (progressPercentage >= 49 && progressPercentage < 66) {
      progressColor = Colors.red;
    } else {
      progressColor = Colors.black;
    };
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      color: expire>3?Colors.white:Color.fromRGBO(238, 162, 164, 0.8),
      child:
      Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {
            setState(() async{
              await updateFoodState(text, 'wasted');
              await updateUserValue('negative');
              items.removeAt(index);
            });
          }),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (BuildContext context) async {
                await updateFoodState( text, 'wasted');
                await updateUserValue('negative');
                //items.removeAt(index);
                // ignore: list_remove_unrelated_type
                //items is supposed to be [] right?
                items.remove(text);
                //await Provider.of<BottomTopScreen>(context, listen: false).remove(items[0]);

                //print(await getAllItems('foods'));
                // print('#########${user1[0].primarystate}#############');
;              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Wasted',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            setState(() async{
              await updateFoodState(text, 'consumed');
              await updateUserValue('positive');
              items.removeAt(index);
            });
          }),
          children: [
            SlidableAction (
              // An action can be bigger than the others.
              flex: 2,
              onPressed: (BuildContext context) async{
                await updateFoodState( text, 'consumed');
                await updateUserValue('positive');
                //print(await getAllItems('foods'));
                //items.removeAt(0);
                items.remove(text);
                //buildList();
              },
              backgroundColor: progressColor,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Comsumed',
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0))),
            child: Image(
              image: AssetImage("$categoryIconImagePath"),
              width: 32,
              height: 32,
            ),
          ),
          title: Text(text, style: TextStyle( fontSize: 25), ),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: progressPercentage,
                        valueColor: AlwaysStoppedAnimation(expire>3?Colors.green:Colors.red)),
                  )
              ),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("$expire Days Left",
                        style: TextStyle(color: expire>3?Colors.orange:Colors.black))),
              )
            ],
          ),
          // subtitle: Text("Expired in $expire days", style: TextStyle(fontStyle: FontStyle.italic),),
          trailing: Text("$foodNum $foodType", style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
          )),
          onTap: () {
            //edit one specific card ---------???????????????????????????
            //txt.value = new TextEditingController.fromValue(new TextEditingValue(text: items[index])).value;
            //transport the index or name of the tapped food card to itemDetailPage

            //builder: (BuildContext index) => itemDetailPage();
            pushItemDetailScreen(index, text);
          },
          onLongPress: () async {
            //??????????????????
            await deleteItem(text);
            items.removeAt(index);
            print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%${await getAllItems('foods')}%%%%%%%%%%%%%%%%%%%%%%%%');
          },
        ),
      ),

    );
  }

  void pushItemDetailScreen(int index, String text) async{
    String quantype = await dbhelper.getOneFoodValue(text, 'quantitytype');
    int quannum = await dbhelper.getOneFoodIntValue(text, 'quantitynum');
    int expitime = await dbhelper.getOneFoodIntValue(text, 'expiretime');
    var expireDate =DateTime.fromMillisecondsSinceEpoch(expitime);
    var remainDays = expireDate.difference(timeNowDate).inDays;

    String category = await dbhelper.getOneFoodValue(text, 'category');
    double consumeprogress = await dbhelper.getOneFoodDoubleValue(text, 'consumestate');

     Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(title: Text('Detail Page')),

                  body: Column(
                    children: <Widget>[
                      TextButton(
                        child: Text('Edit'),
                        onPressed: () {
                          //var qnum = dbhelper.getOneFoodValue(index, "quantitynum");
                          Navigator.pop(context);
                        },
                      ),
                      //name
                      //quantity number and quantity type
                      Title( color: Colors.blue,
                        title: text,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget> [
                                Text('Storage Now: $quannum $quantype'),
                                //Text(quantype),
                              ],
                            ),
                            Row(
                              children: <Widget> [
                                Text('Category: $category')
                              ]
                            ),
                            Row(
                              children: <Widget> [
                                Text('Expires in: $remainDays')
                              ]
                            ),
                          ],
                        ),
                      //progress bar of cosume state
                      ),
                      SizedBox(
                        height: 5,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          value: consumeprogress,
                        ),
                      ),
                    ]
                  ),
                );
              },
            ));
  }

  Widget getTextWidgets(List<String> strings)
  {
    return new Row(children: strings.map((item) => new Text(item)).toList());
  }
  Widget heightSpacer(double myHeight) => SizedBox(height: myHeight);
  /// opens add new item screen
  void pushAddItemScreen() {
    //String date = dateToday.toString().substring(0, 10);
    Color color = Theme.of(context).primaryColor;
    const double padding = 15;

    final category = ["Vegetable", "Meat", "Fruit", "Milk Product", "Milk", "Sea Food", "Egg", "Others"];
    List<Widget> categortyList = new List<Widget>.generate(8, (index) => new Text(category[index]));
    final quanTypes = ["g", "kg", "piece", "bag", "bottle", "num"];
    List<Widget> quanTypeList = new List<Widget>.generate(6, (index) => new Text(quanTypes[index]));
    final nums = List.generate(10, (index) => index);
    List<Widget> numList = List.generate(10, (index) => new Text("$index"));
    int quanNum = 0;
    int quanSmallNum = 0;
    var quanType = "";
    DateTime selectedDate = DateTime.now();
    int expireTimeStamp = 0;
    Color textFieldColor = Color.fromRGBO(178,207, 135, 0.8);
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text('Add an item', style: TextStyle(color: Colors.white),),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView(
                    children: <Widget>[
                      TextField(
                        style: new TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "SegoeUI",
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textFieldColor),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          prefixIcon: Icon(
                            Icons.fastfood,
                            color: textFieldColor,
                          ),
                          hintText: 'e.g. Eggs',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        autofocus: true,
                        controller: nameController,
                        onSubmitted:(value){},
                      ),
                      heightSpacer(5),
                      TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "SegoeUI",
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textFieldColor),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          prefixIcon: Icon(
                            Icons.food_bank,
                            color: textFieldColor,
                          ),
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(child:
                                        CupertinoPicker(
                                          itemExtent: 24.0,
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              categoryController.text = category[value];
                                            });
                                          },
                                          children: categortyList,
                                        ),
                                        )
                                      ],
                                    )
                                );
                              }
                          );
                        },
                        controller: categoryController,
                      ),
                      heightSpacer(5),
                      TextField(
                        style: new TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "SegoeUI",
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textFieldColor),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          prefixIcon: Icon(
                            Icons.shopping_bag,
                            color: textFieldColor,
                          ),
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child:
                                          CupertinoPicker(
                                            itemExtent: 24.0,
                                            onSelectedItemChanged: (value) {
                                              setState(() {
                                                quanNum = nums[value];
                                                quanNumController.text = "$quanNum.$quanSmallNum";
                                                quanNumAndTypeController.text = "$quanNum.$quanSmallNum $quanType";
                                              });
                                            },
                                            children: numList,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child:
                                          CupertinoPicker(
                                            itemExtent: 24.0,
                                            onSelectedItemChanged: (value) {
                                              setState(() {
                                                quanSmallNum = nums[value];
                                                quanNumController.text = "$quanNum.$quanSmallNum";
                                                quanNumAndTypeController.text = "$quanNum.$quanSmallNum $quanType";
                                              });
                                            },
                                            children: numList,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child:
                                          CupertinoPicker(
                                            itemExtent: 24.0,
                                            onSelectedItemChanged: (value) {
                                              setState(() {
                                                quanTypeController.text = quanTypes[value];
                                                quanType = quanTypes[value];
                                                quanNumAndTypeController.text = "$quanNum.$quanSmallNum $quanType";
                                              });
                                            },
                                            children: quanTypeList,
                                          ),
                                        )
                                      ],
                                    )
                                );
                              }
                          );
                        },
                        controller: quanNumAndTypeController,
                      ),
                      heightSpacer(5),
                      TextField(
                        style: new TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "SegoeUI",
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textFieldColor),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: textFieldColor,
                          ),
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(child:
                                        Container(
                                          height: MediaQuery.of(context).copyWith().size.height * 0.25,
                                          color: Colors.white,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.date,
                                            onDateTimeChanged: (value) {

                                              if (value != null && value != selectedDate) {
                                                setState(() {
                                                  selectedDate = value;
                                                  int year = selectedDate.year;
                                                  int month = selectedDate.month;
                                                  int day = selectedDate.day;
                                                  int timestamp = selectedDate.millisecondsSinceEpoch;
                                                  print("timestamp$timestamp");
                                                  expireTimeStamp = timestamp;
                                                  food[3] = expireTimeStamp;
                                                  expireTimeController.text = "$year-$month-$day";
                                                  // Navigator.pop(context)
                                                  //?????????????????????????????? ------> ???????????????
                                                }
                                                );
                                              }
                                            },

                                            initialDateTime: DateTime.now(),
                                            minimumYear: 2000,
                                            maximumYear: 2023,
                                          ),

                                        )
                                        )
                                      ],
                                    )
                                );
                              }
                          );
                        },
                        controller: expireTimeController,
                      ),
                      heightSpacer(5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Expiration date ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //???????????????????????????????????????
                              _buildButtonColumn1(color, 1),
                              _buildButtonColumn1(color, 4),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildButtonColumn1(color, 7),
                              _buildButtonColumn1(color, 14),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: ()  async{
                          try{
                              food[0] = nameController.text;
                              food[1] = categoryController.text;
                              food[2] = timeNow;
                              //food[3] = expireTimeStamp;
                              food[4] = quanTypeController.text;
                              food[5] = quanNum;
                              food[6] = 0.0;
                              food[7] = 'good';
                              print(food);
                              //var quantityNum = int.parse(quanNumController.text);
                              //??????InputPage???DateTime???????????????????????????timestamp???????????????
                              //var expiretime = int.parse(expireTimeController.text);

                            //food[3]?????????????????????????????????int timestamp
                            DateTime expireDays = DateTime.fromMillisecondsSinceEpoch(food[3]);
                            var remainExpireDays = expireDays.difference(timeNowDate).inDays;
                            addItemExpi(remainExpireDays);
                            addItemName(food[0]);
                            print(food);

                            //Calculate the current state of the new food
                            //well actually i should assume the state of a new food should always be good, unless the user is an idiot
                            //But i'm going to do the calculation anyway

                            //insert new data into database
                            insertDB(food);
                            print('#################################${dbhelper.queryAll('foods')}#####################');

                            //user positive value add 1
                            //var user1 = dbhelper.queryAll('users');
                            updateUserValue('positive');

                            } on FormatException{
                              print('Format Error!');
                            }

                        // close route
                        // when push is used, it pushes new item on stack of navigator
                        // simply pop off stack and it goes back
                        Navigator.pop(context);

                      },
                      tooltip: 'Add food',
                      child: const Icon(Icons.add,color: Colors.white),
                    ),
                  );
            }
        )
    );
  }

  // button list for expiring date (only button)
  ElevatedButton _buildButtonColumn1(Color color, int value) {
    return ElevatedButton.icon(
        onPressed: () {
          //record new expire time ----> value
          var later = timeNowDate.add(Duration(days: value));
          food[3] = later.millisecondsSinceEpoch;
          int year = later.year;
          int month = later.month;
          int day = later.day;
          expireTimeController.text = "$year-$month-$day";
        },
        icon: Icon(Icons.calendar_today, size: 18,color: Colors.white),
        label: Text("+ ${value} days", style: TextStyle(color: Colors.white),),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)))));
  }


  /// opens edit item screen
  void pushEditItemScreen (index) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Edit item..'),
                ),

                body: TextField(
                  autofocus: true,

                  decoration: InputDecoration(
                      hintText: 'e.g. Eggs',
                      contentPadding: EdgeInsets.all(16)
                  ),

                  controller: txt,

                  onSubmitted: (value) {
                    editItem(index, value);

                    Navigator.pop(context);
                    buildList();
                  },
                ),
              );
            }
        )
    );
  }

  // input textfield
  Widget customizedTextField(controller, hint) {
      return Padding(
          padding: const EdgeInsets.only(
          left: 16, right: 16, top: 4, bottom: 4),
      child: TextField(
      onChanged: (String txt) {},
      style: const TextStyle(
      fontSize: 20,
      ),
      // cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            labelText: hint,
            prefixIcon: Icon(Icons.food_bank)
        ),
        controller: quanTypeController,
      )
    );
  }

  List<dynamic> getFoodItems(List<dynamic> snapshot){
    List<dynamic> converted = convertSnapshot(snapshot);
    converted.sort((a,b){return a[a.length-1].compareTo(b[a.length-1]);});
    List<dynamic> res = [];
    for (var i=0;i<converted[0].length;i++){
      List<dynamic> item=[];
      for (var j=0;j<converted.length;j++){
        item.add(converted[j][i]);
      }
      res.add(item);
    }
    return res;
  }

  List<dynamic> convertSnapshot(List<dynamic> snapshot){
    List<dynamic> res=[];
    for (var i=0;i<snapshot[0].length;i++){
      List<dynamic> item=[];
      for (var j=0;j<snapshot.length;j++){
        item.add(snapshot[j][i]);
      }
      res.add(item);
    }
    return res;
  }

  List<Duration> getRemainingExpiringTime(List<DateTime> expiringTime){
    List<Duration> remainingTime=[];
    for(var i=0;i<expiringTime.length;i++){
      remainingTime.add(expiringTime[i].difference(timeNowDate));
    }
    return remainingTime;
  }
}