import 'package:flutter/material.dart';
import 'package:less_waste/Helper/DB_Helper.dart';

class BottomTopScreen extends StatefulWidget {
  @override
  _BottomTopScreenState createState() => _BottomTopScreenState();
}

class _BottomTopScreenState extends State<BottomTopScreen> {
  TextEditingController nameController = TextEditingController();
  String foodName = '';
  bool showSuggestList = false;
  List<String> items = [];
  //List<String> items = ['eggs','milk','butter];

  //Create Databse Object
  DBHelper dbhelper = DBHelper();


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

    //get all foods name as a list of string
    List<String> list = await dbhelper.getAllFoodValues("name") as List<String>;
    print(items);

    return items;
  }

  Future<List<int>> getItemQuanNum() async{
    //get all foods quantity number as a list of integers
    List<int> num = await dbhelper.getAllFoodValues("quantitynum") as List<int>;

    return num;
  }

   Future<List<String>> getItemQuanType() async{
    //get all foods quantity number as a list of integers
    List<String> type = await dbhelper.getAllFoodValues("quantitytype") as List<String>;

    return type;
  }

   Future<List<int>> getItemExpireingTime() async{
    //get all foods quantity number as a list of integers
    List<int> expire = await dbhelper.getAllFoodValues("expiretime") as List<int>;
    print(expire);
    return expire;
  }

  Future<void> addItem(value) async {
    setState(() async{
      //Insert a new Food butter
      var butter = Food(id: 0, name: 'butter', category: 'MilkProduct', boughttime: 154893, expiretime: 156432, quantitytype: 'pieces', quantitynum: 3, consumestate: 0.50, state: 'good'); 
      await dbhelper.insertFood(butter);
      var egg = Food(id: 1, name: 'eggs', category: 'Meat', boughttime: 134554, expiretime: 1654757, quantitytype: 'number', quantitynum: 4, consumestate: 0, state: 'good');
      await dbhelper.insertFood(egg);

      print(await dbhelper.queryAll("foods"));

      items = await getItemName();
      print(items);
      //show foods list
      items.add(value);
    });
  }

  Future<void> editItem(index, value) async{
    setState(() async{
      items = await getItemName();
      items[index] = value;
    });
  }

  Widget buildList() {
    //items = await getItemName();
    return FutureBuilder(future: getItemExpireingTime(),builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
      if (!snapshot.hasData) return Container(); // still loading
      // alternatively use snapshot.connectionState != ConnectionState.done
      final List<int> expires = snapshot.requireData;
    
      return FutureBuilder(future: getItemName() , builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) return Container(); // still loading
        // alternatively use snapshot.connectionState != ConnectionState.done
        final List<String> items = snapshot.requireData;
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
    });   
  }
  

  Widget buildItem(String text,int expire, int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text(text,style: TextStyle( fontSize: 25), ),
          subtitle: Text("Expired in $expire days", style: TextStyle(fontStyle: FontStyle.italic),),
          trailing: FittedBox(
            fit: BoxFit.fill,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => {},
                ),
                Text("asa")
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

                body: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'e.g. Eggs',
                      contentPadding: EdgeInsets.all(16)
                  ),

                  controller: txt,

                  onSubmitted: (value) {
//                    debugPrint(value);
                    // add the item
                    addItem(value);

                    // close route
                    // when push is used, it pushes new item on stack of navigator
                    // simply pop off stack and it goes back
                    Navigator.pop(context);

                  },
                ),
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
                  },
                ),
              );
            }
        )
    );
  }

}