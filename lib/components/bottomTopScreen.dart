import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:less_waste/components/quantityDialog.dart';

import '../Pages/InputPage.dart';
import 'package:less_waste/Helper/DB_Helper.dart';
import 'dart:convert';
import 'datePicker.dart';

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
  Future<void> updateFoodState(int id,String name) async{
     var consumedFood = await dbhelper.queryOne('foods', name);
     print(consumedFood);
     var consumedFoodUpdate = Food(id: id, name: name, category: consumedFood[0].category, boughttime: timeNow, expiretime: consumedFood[0].expiretime, quantitytype: consumedFood[0].quantitytype, quantitynum: 0, consumestate: 1.0, state: 'consumed');

      dbhelper.updateFood(consumedFoodUpdate);
  }

  //check the primary state of uservalue should be updated or not; if so, update to the latest
  Future<void> updatePrimaryState() async{
    var user1 = await dbhelper.queryAll('users');
    print("#############################$user1###############################");
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
       dbhelper.updateUserPrimary('leavehomw'); 
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
                    //how to show the listsby sequence of expire time?
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
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    //User click to mean consume the correspoding food in database
                    //remove it from the ListView ------------> how?????????
                    //edit the state to 'consumed' and consumestate to 1, and user positive data adds 1
                   print('##################################$text#############$index######################');
                   updateFoodState(index, text);
                   updateUserValue('positive');
                   buildList();

                  },
                ),
                Text("consumed")
              ],
            ),
          ),
          onTap: () {
            //edit one specific card ---------直接跳去詳情頁面吧
            txt.value = new TextEditingController.fromValue(new TextEditingValue(text: items[index])).value;
            pushEditItemScreen(index);
          }
        )
    );
  }


  /// opens add new item screen
  void pushAddItemScreen() {
    String date = dateToday.toString().substring(0, 10);
    Color color = Theme.of(context).primaryColor;
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                    title: Text("Item Detail")
                ),
                body: Padding(padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 4, bottom: 4),
                    child: Form(
                      // key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "FoodName",
                              icon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Not Empty";
                              }
                            },
                            onSaved: (value) {
                              // _name = value.toString();
                              // print("保存用户名：" + _name);
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Expired",
                              icon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Not Empty";
                              }
                            },
                            onSaved: (value) {
                              // _name = value.toString();
                              // print("保存用户名：" + _name);
                            },
                          ),
                          Text("Expiration in xxxxx"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildButtonColumn1(color, 3),
                              _buildButtonColumn1(color, 4),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildButtonColumn2(context, color, 'No date'),
                              DataPicker(),
                            ],
                          ),
                          OutlinedButton(
                            //When the user press this button, add user inputs into the database
                            //and add to the previous ListView
                            onPressed: () {
                              //convert string to int
                              try {
                                var boughttime = int.parse(
                                    boughtTimeController.text);
                                var quantityNum = int.parse(
                                    quanNumController.text);
                                var expiretime = int.parse(
                                    expireTimeController.text);

                                //add item name and expiretime to show in the ListView
                                //and then
                                addItemExpi(expiretime);
                                addItemName(nameController.text);

                                //Calculate the current state of the new food
                                //well actually i should assume the state of a new food should always be good, unless the user is an idiot
                                //But i'm going to do the calculation anyway

                                //insert new data into database
                                insertDB(
                                    nameController.text,
                                    categoryController.text,
                                    boughttime,
                                    expiretime,
                                    quanTypeController.text,
                                    quantityNum,
                                    'good',
                                    0.0);
                                print(dbhelper.queryAll('foods'));

                                //user positive value add 1
                                var user1 = dbhelper.queryAll('users');
                              } on FormatException {
                                print('Format Error!');
                              }

                              // close route
                              // when push is used, it pushes new item on stack of navigator
                              // simply pop off stack and it goes back
                              Navigator.pop(context);
                              buildList();
                            },
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    )
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
  ElevatedButton _buildButtonColumn2(
      BuildContext context, Color color, String lable) {
    return ElevatedButton.icon(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Category List'),
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

}

// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// _buildButtonColumn1(color, 3),
// _buildButtonColumn1(color, 4),
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// _buildButtonColumn2(context, color, 'No date'),
// DataPicker(),
// ],
// ),