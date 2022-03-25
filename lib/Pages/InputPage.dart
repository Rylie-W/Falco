import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:less_waste/components/dialog.dart';

import '../components/datePicker.dart';
import '../components/quantityDialog.dart';
import 'package:less_waste/Helper/DB_Helper.dart';

class InputPage extends StatefulWidget {
  
  @override
  _InputPageState createState() => _InputPageState();
}
// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
class _InputPageState extends State<InputPage> {
  //const InputPage({Key? key}) : super(key: key);
  DateTime timeNowDate = new DateTime.now();
  int timeNow = DateTime.now().millisecondsSinceEpoch;

  //Create Databse Object
  DBHelper dbhelper = DBHelper();
  List food = ['', '', -1, -1, '', -1, -1.0, ''];

  TextEditingController nameController = TextEditingController();
 

  @override
  void dispose(){
    //Clean up all controllers when the widget is disposed
    nameController.dispose();

    super.dispose();
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

  
  Future<void> insertDB() async{

    //var maxId = await dbhelper.getMaxId();
    //print('##########################MaxID = $maxId###############################');
    //axId = maxId + 1;
    var newFood = Food(name: food[0], category: food[1], boughttime: food[2], expiretime: food[3], quantitytype: food[4], quantitynum: food[5], consumestate: food[6], state: food[7]);
    print(newFood);

    await dbhelper.insertFood(newFood);
    print(await dbhelper.queryAll('foods'));

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

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    String foodName = '';
    bool showSuggestList = false;
    //List<String> items = ["eggs", "milk", "pizza"];
    
    DateTime dateToday = new DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Column(
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
            DataPicker(getdatePicker: (value) {
              setState(() {
                food[3] = value;
              });
            },)
            //food[3] = DataPicker().expiredate,
          ],
        ),
      ],
    );

    Widget detailSelection = Column(
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
            _buildButtonColumn2(context, color, 'category'),
            //food[1] = BodyWidget().category,     
            _buildButtonColumn2(context, color, date),
          ],
        )
      ],
    );

    /// build item

    //var txt = TextEditingController();

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
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
            ),
            buttonSection,
            detailSelection,
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            // Respond to button press  -----> write in database
            //convert string to int
                    try{
                      //用戶不需要輸入購買時間，直接默認為用戶第一次添加事物的當前時間
                     // var boughttime = timeNow;
                      //food[1] = Category
                      food[0] = nameController.text;
                      print(food[0]);
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
                    insertDB();
                    print(dbhelper.queryAll('foods'));

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
          icon: Icon(Icons.add),
          label: Text('EXTENDED'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  //+ ${value} days 
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
  //quantity num + quantity type
  ElevatedButton _buildButtonColumn2(
      BuildContext context, Color color, String lable) {
    return ElevatedButton.icon(
        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Quantity'),
                content: QuantityNumber(),
                //food[1] = BodyWidget().category;
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

  
// category

  ElevatedButton _buildButtonColumn3(
      BuildContext context, Color color) {
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
}