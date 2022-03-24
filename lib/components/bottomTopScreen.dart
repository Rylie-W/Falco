import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:less_waste/components/quantityDialog.dart';

import '../Pages/AchievementPage.dart';
import '../Pages/InputPage.dart';
import 'dialog.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'achievements.dart';
import 'datePicker.dart';
import 'dart:async';


class BottomTopScreen extends StatefulWidget {
  @override
  _BottomTopScreenState createState() => _BottomTopScreenState();
}

class _BottomTopScreenState extends State<BottomTopScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController expireTimeController = TextEditingController();
  TextEditingController boughtTimeController = TextEditingController();
  TextEditingController quanTypeController = TextEditingController();
  TextEditingController quanNumController = TextEditingController();
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
    "SeaFood": "assets/category/seafood.png",
    "Meat": "assets/category/meat.png",
    "Milk": "assets/category/seafood.png",
    "MilkProduct": "assets/category/seafood.png",
    "Fruits": "assets/category/fruits.png",
    "Vegetable": "assets/category/vegetable.png",
    "Others": "assets/category/meat.png"
  };

  String foodName = '';
  bool showSuggestList = false;
  List<String> items = [];
  //List<String> items = ['eggs','milk','butter];
  DateTime timeNowDate = new DateTime.now();
  int timeNow = DateTime.now().millisecondsSinceEpoch;

  //Create Databse Object
  DBHelper dbhelper = DBHelper();
  List food = ['', '', -1, -1, '', -1, -1.0, ''];

  
  
  Future<void> insertItem() async{
       //Insert a new Food butter
      var butter = Food(id: 0, name: 'butter', category: 'MilkProduct', boughttime: 154893, expiretime: 156432, quantitytype: 'pieces', quantitynum: 3, consumestate: 0.50, state: 'good'); 
      await dbhelper.insertFood(butter);
      var egg = Food(id: 1, name: 'eggs', category: 'Meat', boughttime: 134554, expiretime: 1654757, quantitytype: 'number', quantitynum: 4, consumestate: 0, state: 'good');
      await dbhelper.insertFood(egg);

      //await dbhelper.testDB();

      //print('###################################third##################################');
      //print(await dbhelper.queryAll("foods"));
  }


  Future<void> insertDB(List _food) async{

    var maxId = await dbhelper.getMaxId();
    print('##########################MaxID = $maxId###############################');
    maxId = maxId + 1;
    var newFood = Food(id: maxId, name: _food[0], category: _food[1], boughttime: _food[2], expiretime: _food[3], quantitytype: _food[4], quantitynum: _food[5], consumestate: _food[6], state: _food[7]);
    print(newFood);

    await dbhelper.insertFood(newFood);
    print(await dbhelper.queryAll('foods'));

  }




  Future<List<String>> getItemName() async {
    //await insertItem();

    //get all foods name as a list of string
    List<String> items = await dbhelper.getAllUncosumedFoodStringValues('name');
    //print('##################################first######################################');
    //print(items);

    return items;
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

   Future<List<DateTime>> getItemExpireingTime() async{
    //get all foods quantity number as a list of integers
    List<int> expire = await dbhelper.getAllUncosumedFoodIntValues('expiretime') ;
    var maxID = await dbhelper.getMaxId() + 1;

    //int index = 0;
    //Convert the List<int> into a List<DateTime>/ timestamp ----->  DateTime
    var expireDate = List<DateTime>.generate(maxID, (i) => DateTime.fromMillisecondsSinceEpoch(expire[i]));
    print('#########################$expireDate##################');
    //print('############################################second##########################');
    //print(expire);
    return expireDate;
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

  Future<void> deleteItem(index) async{
      //items = await getItemName();
      dbhelper.deleteFood(index);

  }


  Future<void> updateFoodState(int id, String name, String attribute) async{
     var updatedFood = await dbhelper.queryOne('foods', name);
     print(updatedFood);
     if(attribute == 'consumed'){
     //var consumedFoodUpdate = Food(id: id, name: name, category: updatedFood[0].category, boughttime: updatedFood[0].boughttime, expiretime: updatedFood[0].expiretime, quantitytype: updatedFood[0].quantitytype, quantitynum: 0, consumestate: 1.0, state: 'consumed');
      dbhelper.updateFoodConsumed(id);
     }
     else{
      //var wastedFoodUpdate = Food(id: id, name: name, category: updatedFood[0].category, boughttime: updatedFood[0].boughttime, expiretime: updatedFood[0].expiretime, quantitytype: updatedFood[0].quantitytype, quantitynum: updatedFood[0].quantitynum, consumestate: 1.0, state: 'wasted');
      dbhelper.updateFoodWaste(id);

     }
  }

  //when to call this function? At a certain time evey day.
  Future<void> autocheckWaste() async{
    //get every instance out of Foods table and compare its expiretime with current time
    int maxID = await dbhelper.getMaxId();
    for(int i = 0; i <= maxID ; i++ ){
      var expiretime = await dbhelper.getAllUncosumedFoodIntValues('expiretime');
      if(expiretime[i] < timeNow){
        dbhelper.updateFoodWaste(i);
      }
    }
  }

  //check the primary state of uservalue should be updated or not; if so, update to the latest
  Future<void> updatePrimaryState() async{
    var user1 = await dbhelper.queryAll('users');
    int value = user1[0].positive - user1[0].negative;
    String primaryState;

    if (value < 2){
      primaryState='initialization';
      await dbhelper.updateUserPrimary(primaryState);
    }
    if (value <= 6){
      //judge the primary state
      primaryState='encounter';
      await dbhelper.updateUserPrimary(primaryState);
    }
    if(value > 6 && value <= 14){
      primaryState='mate';
      await dbhelper.updateUserPrimary(primaryState);
    }
    if(value > 14 && value <= 30){
      primaryState='nest';
      await dbhelper.updateUserPrimary(primaryState);
    }
    if(value > 30 && value <= 46){
      primaryState='hatch';
      await dbhelper.updateUserPrimary(primaryState);
    }
    if(value > 46 && value <= 78){
      primaryState='learn';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 78 && value <= 82){
      primaryState='leavehome';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 82 && value <= 91){
      primaryState='snow owl';
      await dbhelper.updateUserPrimary(primaryState);
    }
    else if(value > 91 && value <= 100){
      primaryState='tawny owl';
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
      var uservalue = UserValue(name: user1[0].name, negative: user1[0].negative, positive: user1[0].positive + 1, primarystate: user1[0].primarystate, secondarystate: 'satisfied', secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 0, fatherstate: "single", motherstate: "single", time: timeNow);    
      await dbhelper.updateUser(uservalue);
      await updatePrimaryState();
      print(await dbhelper.queryAll("users"));

      }
    else{
      var uservalue = UserValue(name: user1[0].name, negative: user1[0].negative + 1, positive: user1[0].positive, primarystate: user1[0].primarystate, secondarystate: 'satisfied', secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 0, fatherstate: "single", motherstate: "single", time: timeNow);    
      await dbhelper.updateUser(uservalue);
      await updatePrimaryState();
    }

  }

  var txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime dateToday = new DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    Color color = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),

      body: Column(
        children: [
          TextButton.icon(
            onPressed: (){
              //order the ListView
            },
            icon: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.compare_arrows, size: 28,)
            ),
            label: Text(
              'Expire Remaining Time Ascending',
              style: TextStyle(fontSize: 6),
            ),
          ),

        Expanded(child: buildList()),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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

  void pushAddItemPage() {
    //String date = dateToday.toString().substring(0, 10);
    Color color = Theme.of(context).primaryColor;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => InputPage())
    );

  }

  Widget buildList() {
    //items = await getItemName();
    return FutureBuilder(
      future: getItemName(), 
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...'); // still loading
        // alternatively use snapshot.connectionState != ConnectionState.done
        if(snapshot.hasError) return const Text('Something went wrong.');
        final List<String> items = snapshot.requireData;

    
        return FutureBuilder(
          future: getItemExpireingTime() ,
          builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
          if (!snapshot.hasData) return const Text('Loading...'); // still loading
          // alternatively use snapshot.connectionState != ConnectionState.done
          if (snapshot.hasError) return const Text('Something went wrong.');
          final List<DateTime> expires = snapshot.requireData;
          print(expires);
          if (items.length < 1) {
            return Center(
              child: Text("Nothing yet...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }

          return FutureBuilder(future: getItemQuanNum(), builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
            if (!snapshot.hasData) return const Text('Loading...'); // still loading
            // alternatively use snapshot.connectionState != ConnectionState.done
            if (snapshot.hasError) return const Text('Something went wrong.');
            final List<int> num = snapshot.requireData;
            return FutureBuilder(future: getItemQuanType(), builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (!snapshot.hasData) return const Text('Loading...'); // still loading
              // alternatively use snapshot.connectionState != ConnectionState.done
              if (snapshot.hasError) return const Text('Something went wrong.');
              final List<String> type = snapshot.requireData;
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

                      //var expires = getItemExpireingTime();
                      var expire = expires[index];
                      //how to show the listsby sequence of expire time?
                      final sortedItems = expires.reversed.toList();
                      expire = sortedItems[index];
                      var remainDays = expires[index].difference(timeNowDate).inDays;

                      var foodNum = num[index];
                      var foodType = type[index];

                      return buildItem(item, expire, foodNum, foodType, index);
                    }
                )
            );
            });
          });


        });
      }
    );   
  }
  

  Widget buildItem(String text, DateTime expire, int foodNum, String foodType, int index) {
    var categoryIconImagePath = null;
    if(GlobalCateIconMap[text] == null) {
      categoryIconImagePath = GlobalCateIconMap["Others"];
    } else {
      print(GlobalCateIconMap.values);
      print(GlobalCateIconMap[text]);
      print(text);
      print("not null");
      categoryIconImagePath = GlobalCateIconMap[text];
      print("milk exception");
      print(categoryIconImagePath);
    };
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      child:
      Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {
            setState(() {
              items.removeAt(index);
            });
          }),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (BuildContext context) {
                updateFoodState(index, text, 'wasted');
                updateUserValue('negative');
              },
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
            setState(() {
              items.removeAt(index);
            });
          }),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 2,
              onPressed: (BuildContext context) {
                updateFoodState(index, text, 'consumed');
                updateUserValue('positive');
                buildList();
              },
              backgroundColor: Color(0xFF7BC043),
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
                        value: 0.44,
                        valueColor: AlwaysStoppedAnimation(Colors.green)),
                  )
              ),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("$expire days left",
                        style: TextStyle(color: Colors.orange))),
              )
            ],
          ),
          // subtitle: Text("Expired in $expire days", style: TextStyle(fontStyle: FontStyle.italic),),
          trailing: Text("$foodNum $foodType", style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
          )),
          onTap: () {
            //edit one specific card ---------直接跳去詳情頁面吧
            //txt.value = new TextEditingController.fromValue(new TextEditingValue(text: items[index])).value;
            //transport the index or name of the tapped food card to itemDetailPage

            //builder: (BuildContext index) => itemDetailPage();
            pushItemDetailScreen(index, text);
          },
          onLongPress: () {
            //長按卡片刪除
            deleteItem(index);
            buildList();
          },
        ),
      ),

    );
  }

  Future<void> pushItemDetailScreen(int index, String text) async{
    String quantype = await dbhelper.getOneFoodValue(index, 'quantitytype');
    int quannum = await dbhelper.getOneFoodIntValue(index, 'quantitynum');
    int expitime = await dbhelper.getOneFoodIntValue(index, 'expiretime');
    var expireDate =DateTime.fromMillisecondsSinceEpoch(expitime);
    var remainDays = expireDate.difference(timeNowDate).inDays;

    String category = await dbhelper.getOneFoodValue(index, 'category');
    double consumeprogress = await dbhelper.getOneFoodDoubleValue(index, 'consumestate');

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
                      Title( color: Colors.blue ,
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
  /// opens add new item screen
  void pushAddItemScreen() {
    //String date = dateToday.toString().substring(0, 10);
    Color color = Theme.of(context).primaryColor;
    const double padding = 15;

    final Category = ["Vegetable", "Meat", "Fruit", "Milk Product", "Milk"];
    List<Widget> categortyList = new List<Widget>.generate(5, (index) => new Text(Category[index]));
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Add an item'),
                ),
                body: ListView(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'e.g. Eggs',
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        border: UnderlineInputBorder(),
                      ),
                      controller: nameController,
                      onSubmitted:(value){},
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Select an expiration date",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            //需要添加只能選擇一個的判斷
                            _buildButtonColumn1(color, 3),
                            _buildButtonColumn1(color, 4),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButtonColumn2(context, color, 'No date'),
                            DataPicker(expiredate: food[3],),
                            //food[3] = DataPicker().expiredate,
                          ],
                        ),
                        ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Detail",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //quantity number + quantity type
                            _buildButtonColumn2(context, color, 'quantity number'),
                            _buildButtonColumn2(context, color, 'quantity type'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //category
                            _buildButtonColumn3(context, color),
                            //food[1] = BodyWidget().category,

                            _buildButtonColumn2(context, color, timeNowDate.toString().substring(0,10)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
            floatingActionButton: FloatingActionButton(
              //backgroundColor: const Color(0xff03dac6),
              //foregroundColor: Colors.black,
              onPressed: ()  async {
                // Respond to button press  -----> write in database
                //convert string to int
                      try{
                          //用戶不需要輸入購買時間，直接默認為用戶第一次添加事物的當前時間
                        // var boughttime = timeNow;
                          //food[1] = Category
                          food[0] = nameController.text;
                          food[1] = BodyWidget().category;
                          food[2] = timeNow;
                          //food[3] = DataPicker().expiredate;
                          food[4] = '';
                          food[5] = QuantityNumber().quantityNum;
                          food[6] = 0.0;
                          food[7] = 'good';
                          //var quantityNum = int.parse(quanNumController.text);

                          //接上InputPage裏DateTime時間組件，再轉化成timestamp存進數據庫
                          //var expiretime = int.parse(expireTimeController.text);

                        //food[3]是可以直接傳入數據庫的int timestamp
                        DateTime ExpireDays = DateTime.fromMillisecondsSinceEpoch(food[3]);
                        var remainExpireDays = ExpireDays.difference(timeNowDate).inDays;
                        addItemExpi(remainExpireDays);
                        addItemName(food[0]);
                        print(food);

                        //Calculate the current state of the new food
                        //well actually i should assume the state of a new food should always be good, unless the user is an idiot
                        //But i'm going to do the calculation anyway

                        //insert new data into database
                        insertDB(food);
                        print(dbhelper.queryAll('foods'));

                        //user positive value add 1
                        var user1 = await dbhelper.queryAll('users');
                        updateUserValue('positive');
                          String check = checkIfPrimaryStateChanged(user1[0].positive-user1[0].negative);
                          if (check!='None'){
                            showAchievementDialog(check);
                          }

                        } on FormatException{
                          print('Format Error!');
                        }

                        // close route
                        // when push is used, it pushes new item on stack of navigator
                        // simply pop off stack and it goes back
                        Navigator.pop(context);

              },
                  tooltip: 'Add food',
                  child: const Icon(Icons.add),
            ),
          );
        }
        )
    );
  }
  /*
            body: Column(children: <Widget> [
               TextField(
                  autofocus: false,
                  //focusNode: focusNode1,
                  decoration: InputDecoration(
                      hintText: 'e.g. Eggs',
                      contentPadding: EdgeInsets.all(16),
                      labelText: "Food Name",
                      prefixIcon: Icon(Icons.food_bank)
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: TextField(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 24,
                          ),
                          autofocus: false,
                          onTap: () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey,
                                    child: Row(
                                      children: [
                                        Expanded(child: CupertinoPicker(
                                            itemExtent: 32.0,
                                            onSelectedItemChanged: (value) {
                                              setState(() {
                                                categoryController.text = Category[value];
                                              });
                                            },
                                            children: categortyList
                                        ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                          //focusNode: focusNode2,
                          decoration: InputDecoration(
                              hintText: 'choose correspoding category...',
                              contentPadding: EdgeInsets.all(16),
                              labelText: "Category",
                              prefixIcon: Icon(Icons.food_bank)
                          ),
                          controller: categoryController,
                          obscureText: false
                      ),
                  ),

                TextField(
                  autofocus: true,
                  //focusNode: focusNode2,
                  decoration: InputDecoration(
                      hintText: 'add remaining expire time',
                      contentPadding: EdgeInsets.all(16),
                      labelText: "Expire On",
                      prefixIcon: Icon(Icons.food_bank)
                  ),
                  controller: expireTimeController,
                  obscureText: true
                ),
                TextField(
                  autofocus: true,
                  //focusNode: focusNode2,
                  decoration: InputDecoration(
                      hintText: 'Quantity',
                      contentPadding: EdgeInsets.all(16),
                      labelText: "Quantity Number",
                      prefixIcon: Icon(Icons.food_bank)
                  ),
                  controller: quanNumController,
                  obscureText: true
                ),
                TextField(
                  autofocus: true,
                  //focusNode: focusNode2,
                  decoration: InputDecoration(
                      hintText: 'Quantity',
                      contentPadding: EdgeInsets.all(16),
                      labelText: "Quantity Type",
                      prefixIcon: Icon(Icons.food_bank)
                  ),
                  controller: quanTypeController,
                  obscureText: true
                )
                FloatingActionButton(
                  //When the user press this button, add user inputs into the database 
                  //and add to the previous ListView
                  onPressed:() async {

                    //convert string to int
                    try{
                      //用戶不需要輸入購買時間，直接默認為用戶第一次添加事物的當前時間
                      var boughttime = timeNow;
                      var quantityNum = int.parse(quanNumController.text);

                      //接上InputPage裏DateTime時間組件，再轉化成timestamp存進數據庫
                      var expiretime = int.parse(expireTimeController.text);

                      //add item name and expiretime to show in the ListView
                    //and then
                    DateTime ExpireDays = DateTime.fromMillisecondsSinceEpoch(expiretime);
                    var remainExpireDays = ExpireDays.difference(timeNowDate).inDays;
                    addItemExpi(remainExpireDays);
                    addItemName(nameController.text);

                    //Calculate the current state of the new food
                    //well actually i should assume the state of a new food should always be good, unless the user is an idiot
                    //But i'm going to do the calculation anyway
                    
                    //insert new data into database
                    insertDB(nameController.text, categoryController.text, boughttime, expiretime, quanTypeController.text, quantityNum, 'good', 0.0);
                    print(dbhelper.queryAll('foods'));

                    //user positive value add 1
                    updateUserValue("positive");
                    var user1 = await dbhelper.queryAll('users');
                    String check = checkIfPrimaryStateChanged(user1[0].positive-user1[0].negative);
                    if (check!='None'){
                      showAchievementDialog(check);
                    }

                    } on FormatException{
                      print('Format Error!');
                    }

                     // close route
                    // when push is used, it pushes new item on stack of navigator
                     // simply pop off stack and it goes back
                    Navigator.pop(context);
                    buildList();
                  },
                  tooltip: 'Add food',
                  child: const Icon(Icons.add),
                ),
                ],

                )
              );          
            }
        )
    );
  }
*/

  String checkIfPrimaryStateChanged(int value){
    if (value==2){
      return Achievements.achievementNameList[1];
    }
    else if (value==7){
      return Achievements.achievementNameList[2];
    }
    else if (value==15){
      return Achievements.achievementNameList[3];
    }
    else if (value==31){
      return Achievements.achievementNameList[4];
    }
    else if (value==47){
      return Achievements.achievementNameList[5];
    }
    else if (value==79){
      return Achievements.achievementNameList[6];
    }
    else if (value==83){
      return Achievements.achievementNameList[7];
    }
    else if (value==92){
      return Achievements.achievementNameList[8];
    }
    else{
      return "None";
    }
  }

  // button list for expiring date (only button)
  ElevatedButton _buildButtonColumn1(Color color, int value) {
    return ElevatedButton.icon(
        onPressed: () {
          //record new expire time ----> value
          var later = timeNowDate.add(Duration(days: value));
          food[3] = later.millisecondsSinceEpoch;

        },
        icon: Icon(Icons.calendar_today, size: 18),
        label: Text("+ ${value} days"),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)))));
  }

  // button list for category(show category list)
  ElevatedButton _buildButtonColumn2(BuildContext context, Color color, String lable) {
    return ElevatedButton.icon(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Quantity Number'),
            content: QuantityNumber(),
          ),
        ),
        icon: Icon(Icons.calendar_today, size: 18),
        label: Text(lable),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.white)))));
  }
  ElevatedButton _buildButtonColumn3(BuildContext context, Color color) {
    return ElevatedButton.icon(

        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Category List'),
                content: BodyWidget(),

              ),
            ),

        icon: Icon(Icons.calendar_today, size: 18),
        label: Text('category'),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.white))))
    );
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

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.blue,
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }

  showAchievementDialog(String state){
    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;
    int stateIndex= Achievements.stateMap[state]??-1;
    AlertDialog dialog = AlertDialog(
      title: const Text("Congratulations!"),
      content:
      new Container(
        width: 3*width/5,
        height: height/3,
        padding: const EdgeInsets.all(10.0),
        child:
        new Column(
          children: [
            Expanded(child: stateIndex>-1? Image.asset(Achievements.imageList[stateIndex]):Image.asset(Achievements.imageList[12])),
            Text(
                stateIndex>-1?"You have made the achievement "+Achievements.achievementNameList[stateIndex]:"Something goes wrong. We are fixing it.",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return dialog;
    });
  }
}