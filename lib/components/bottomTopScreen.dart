import 'package:flutter/material.dart';

class BottomTopScreen extends StatefulWidget {
  @override
  _BottomTopScreenState createState() => _BottomTopScreenState();
}

class _BottomTopScreenState extends State<BottomTopScreen> {
  TextEditingController nameController = TextEditingController();
  String foodName = '';
  bool showSuggestList = false;
  List<String> items = ["eggs", "milk", "pizza"];

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

  void addItem(value) {
    setState(() {
      items.add(value);
    });
  }

  void editItem(index, value) {
    setState(() {
      items[index] = value;
    });
  }

  Widget buildList() {
    if (items.length < 1) {
      return Center(
        child: Text("Nothing yet...",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    }

    return
    ListTileTheme(
        contentPadding: EdgeInsets.all(15),
        textColor: Colors.black54,
        style: ListTileStyle.list,
        dense: true,
        child: ListView.builder(
            itemBuilder: (context, index) {
              var item = items[index];

              return buildItem(item, index);
            }
        )
    );

  }

  Widget buildItem(String text, int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text(text,style: TextStyle( fontSize: 25), ),
          subtitle: Text("Expired in 2 days", style: TextStyle(fontStyle: FontStyle.italic),),
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