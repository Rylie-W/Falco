import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Pages/InputPage.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'dart:convert';

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


  var txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),

      body: buildList(),

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

  Future<List<String>> getItemName() async {
    //await insertItem();

    //get all foods name as a list of string
    List<String> items = await dbhelper.getAllFoodStringValues('name');
    //print('##################################first######################################');
    //print(items);

    return items;
  }


  Future<List<int>> getItemQuanNum() async{
    //get all foods quantity number as a list of integers
    List<int> num = await dbhelper.getAllFoodIntValues('quantitynum');

    return num;
  }

   Future<List<String>> getItemQuanType() async{
    //get all foods quantity number as a list of integers
    List<String> type = await dbhelper.getAllFoodStringValues('quantitytype');

    return type;
  }

   Future<List<int>> getItemExpireingTime() async{
    //get all foods quantity number as a list of integers
    List<int> expire = await dbhelper.getAllFoodIntValues('expiretime') ;
    //print('############################################second##########################');
    //print(expire);
    return expire;
  }

  Future<void> addItemName(value) async {
  
    List<String> items = await dbhelper.getAllFoodStringValues('name');
    //items = await getItemName();
    //print(items);
      
    setState(() {    
      items.add(value);
    });
  }

    Future<void> addItemExpi(value) async {

    List<int> expires = await dbhelper.getAllFoodIntValues('expiretime');
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
                    //how to show the quantity tyoe and quantity number?

                    //var expires = getItemExpireingTime();
                    var expire = expires[index];
                    return buildItem(item, expire, index);   //#############################################ERROR###########################
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
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    //delete the correspoding food in database
                    //and remove it from the ListView

                    
                  },
                ),
                Text("quantity")
              ],
            ),
          ),
          onTap: () {
            txt.value = new TextEditingController.fromValue(new TextEditingValue(text: items[index])).value;
            pushEditItemScreen(index);
          }
        )
    );
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