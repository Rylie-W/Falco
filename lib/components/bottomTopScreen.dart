import 'package:flutter/material.dart';

class BottomTopScreen extends StatefulWidget {
  @override
  _BottomTopScreenState createState() => _BottomTopScreenState();
}

class _BottomTopScreenState extends State<BottomTopScreen> {
  TextEditingController nameController = TextEditingController();
  String foodName = '';
  bool showSuggestList = false;

  @override
  Widget build(BuildContext context) {
    return Container(

      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              controller: nameController,
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Food Name',
              ),
              onChanged: (text) {
                if (text.length > 0) {
                  setState(() {
                    foodName = text;
                    showSuggestList = true;
                });
                } else {
                  setState(() {
                    foodName = "";
                    showSuggestList = false;
                  });
                }
              },
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(foodName)
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}