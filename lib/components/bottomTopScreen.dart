import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Pages/InputPage.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'dart:convert';

import 'package:less_waste/components/itemDetailPage.dart';

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

  String foodName = '';
  bool showSuggestList = false;
  List<String> items = [];
  //List<String> items = ['eggs','milk','butter];
  DateTime dateToday = new DateTime.now();
  int timeNow = DateTime.now().millisecondsSinceEpoch;

  //Create Databse Object
  DBHelper dbhelper = DBHelper();

  
  
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

  Future<void> insertDB(String name, String category, int boughttime, int expiretime, String quantitytype, int quantitynum, String state, double consumestate) async{

    var maxId = await dbhelper.getMaxId();
    print('##########################MaxID = $maxId###############################');
    maxId = maxId + 1;
    var newFood = Food(id: maxId, name: name, category: category, boughttime: boughttime, expiretime: expiretime, quantitytype: quantitytype, quantitynum: quantitynum, consumestate: consumestate, state: state);
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

   Future<List<int>> getItemExpireingTime() async{
    //get all foods quantity number as a list of integers
    List<int> expire = await dbhelper.getAllUncosumedFoodIntValues('expiretime') ;
    //print('############################################second##########################');
    //print(expire);
    return expire;
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

    if(value > 0 && value <= 6){
      //judge the primary state
      await dbhelper.updateUserPrimary('encounter');
    }
    if(value > 6 && value <= 10){
      await dbhelper.updateUserPrimary('mate');
    }
    if(value > 10 && value <= 20){
      await dbhelper.updateUserPrimary('nest');
    }
    if(value > 20 && value <= 30){
      await dbhelper.updateUserPrimary('hatch');
    }
    if(value > 30 && value <= 40){
      await dbhelper.updateUserPrimary('learn');
    }
    else if(value > 40 && value <= 50){
       dbhelper.updateUserPrimary('leavehome'); 
    }
  }

  //edit the state to 'consumed' and consumestate to 1, and user positive data adds 1
  //the arugument should be 'positive'(which means positive + 1) or 'negative'(which means negative + 1)
  Future<void> updateUserValue(String state) async{
    var user1 = await dbhelper.queryAll('users');
    //int value = user1[0]['positive'] - user1[0]['negative'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),

      body: Column(
        children: [
          TextButton.icon(
            onPressed: (){

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
          pushAddItemScreen();
        },
      ),
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
        print(items);
        
    
        return FutureBuilder(future: getItemExpireingTime() , builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) return const Text('Loading...'); // still loading
          // alternatively use snapshot.connectionState != ConnectionState.done
          if (snapshot.hasError) return const Text('Something went wrong.');
          final List<int> expires = snapshot.requireData;
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

          return ListTileTheme(
              contentPadding: EdgeInsets.all(15),
              textColor: Colors.black54,
              style: ListTileStyle.list,
              dense: true,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    //how to show the quantity type and quantity number?

                    //var expires = getItemExpireingTime();
                    var expire = expires[index];
                    //how to show the listsby sequence of expire time?
                    final sortedItems = expires.reversed.toList();
                    expire = sortedItems[index];

                    return buildItem(item, expire, index);   
                  }
              )
          );
        });
      }
    );   
  }
  

  Widget buildItem(String text, int expire, int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text(text, style: TextStyle( fontSize: 25), ),
          subtitle: Text("Expired in $expire days", style: TextStyle(fontStyle: FontStyle.italic),),

          trailing: FittedBox(
            fit: BoxFit.fill,
            child: Column( 
              children: <Widget>[
                Row (
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        //User click to mean he has wasted the correspoding food in database
                        //remove it from the ListView ------------> how?????????
                        //edit the state to 'wasted' and consumestate stays the same, and user negative data adds 1
                      print('##################################$text#############$index######################');
                      updateFoodState(index, text, 'wasted');
                      updateUserValue('negative');
                      buildList();
                      },
                    ),
                    Text('wasted'),
                  ],
                ),
                Row(
                  children: <Widget>[
                
                    IconButton(
                      icon: Icon(Icons.backpack),
                      onPressed: () {
                        //User click to mean consume the correspoding food in database
                        //remove it from the ListView ------------> how?????????
                        //edit the state to 'consumed' and consumestate to 1, and user positive data adds 1
                      print('##################################$text#############$index######################');
                      updateFoodState(index, text, 'consumed');
                      updateUserValue('positive');
                      buildList();
                      },
                    ),
                    Text("consumed")
                  ],
                ),
              ],
            ),
          ),
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
        )
    );
  }

  void pushItemDetailScreen(int index, String text) async{
    String quantype = await dbhelper.getOneFoodValue(index, 'quantitytype');
    int quannum = await dbhelper.getOneFoodIntValue(index, 'quantitynum');
    int expitime = await dbhelper.getOneFoodIntValue(index, 'expiretime');
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
                                Text('Storage Now:$quannum $quantype'),
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
                                Text('Expires in: $expitime')
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

  /// opens add new item screen
  void pushAddItemScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Add an item'),
                ),
                
                body: Column(children: <Widget> [TextField(
                  autofocus: false,
                  //focusNode: focusNode1,
                  decoration: InputDecoration(
                      hintText: 'e.g. Eggs',
                      contentPadding: EdgeInsets.all(16),
                      labelText: "Food Name",
                      prefixIcon: Icon(Icons.food_bank)
                  ),
                  controller: nameController,
                  onSubmitted: (value) {},
                ),
                TextField(
                  autofocus: true,
                  //focusNode: focusNode2,
                  decoration: InputDecoration(
                      hintText: 'choose correspoding category...',
                      contentPadding: EdgeInsets.all(16),
                      labelText: "Category",
                      prefixIcon: Icon(Icons.food_bank)
                  ),
                  controller: categoryController,
                  obscureText: true
                ),
                TextField(
                  autofocus: true,
                  //focusNode: focusNode2,
                  decoration: InputDecoration(
                      hintText: 'You bought it on...',
                      contentPadding: EdgeInsets.all(16),
                      labelText: "Bought Date",
                      prefixIcon: Icon(Icons.food_bank)
                  ),
                  controller: boughtTimeController,
                  obscureText: true
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
                ),
                FloatingActionButton(
                  //When the user press this button, add user inputs into the database 
                  //and add to the previous ListView
                  onPressed:() {

                    //convert string to int
                    try{
                      var boughttime = int.parse(boughtTimeController.text);
                      var quantityNum = int.parse(quanNumController.text);
                      var expiretime = int.parse(expireTimeController.text);

                      //add item name and expiretime to show in the ListView
                    //and then
                    addItemExpi(expiretime);
                    addItemName(nameController.text);

                    //Calculate the current state of the new food
                    //well actually i should assume the state of a new food should always be good, unless the user is an idiot
                    //But i'm going to do the calculation anyway
                    
                    //insert new data into database
                    insertDB(nameController.text, categoryController.text, boughttime, expiretime, quanTypeController.text, quantityNum, 'good', 0.0);
                    print(dbhelper.queryAll('foods'));

                    //user positive value add 1
                    var user1 = dbhelper.queryAll('users');

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

}