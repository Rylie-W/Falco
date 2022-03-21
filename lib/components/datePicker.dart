import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DataPicker extends StatefulWidget {
  @override
  _DataPickerState createState() {
    return _DataPickerState();
  }
}

class _DataPickerState extends State<DataPicker> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton.icon(
          onPressed: () {
            showDatePicker();
          },
          icon: Icon(Icons.calendar_today, size: 18),
          label: Text(selectedDate.toString().substring(0, 10)),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white))))),
    ]);
  }

  void showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                if (value != null && value != selectedDate)
                  setState(() {
                    selectedDate = value;
                    //
                  });
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2000,
              maximumYear: 2023,
            ),
          );
        });
  }
}
