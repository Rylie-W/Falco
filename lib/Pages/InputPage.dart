import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  DateTime dateToday = new DateTime.now();
  int timeNow = DateTime.now().millisecondsSinceEpoch;

  //Create Databse Object
  DBHelper dbhelper = DBHelper();

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
  

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    String foodName = '';
    bool showSuggestList = false;
    List<String> items = ["eggs", "milk", "pizza"];
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
            _buildButtonColumn1(color, 3),
            _buildButtonColumn1(color, 4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonColumn2(context, color, 'No date'),
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
              onSubmitted: (value) {

                Navigator.pop(context);
              },
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

          },
          icon: Icon(Icons.add),
          label: Text('EXTENDED'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  ElevatedButton _buildButtonColumn1(Color color, int value) {
    return ElevatedButton.icon(
        onPressed: () {
          //record new expire time ----> value
          
          
        },
        icon: Icon(Icons.calendar_today, size: 18),
        label: Text("+ ${value} days"),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)))));
  }
// quantity number
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
}
