import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // camera related
  late String imagePath;
  late File imageFile;
  late String imageData;

  Future pickImage(bool isCamera) async {
    var image;
    if(isCamera == true) {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (image == null) return;
    setState(() {
      imagePath = image.path;
      imageFile = File(image.path);
      imageData = base64Encode(imageFile.readAsBytesSync());
    });
    doUpload(image);
  }

  //upload picture request related
  final url_to_api = "http://34.65.81.128:5000/";
  doUpload(image) async {
    var bodyData = {
      "image": imageData
    };
    print(imageData);
    var response = await http.post(Uri.parse(url_to_api), body:bodyData,headers: {'Content-Type': 'application/json'});
    print(response);
    print(response.body);
    print(response.statusCode);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(
                  Icons.add
              ),
              onPressed: () {
              },
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.lightBlueAccent,
              child: Icon(
                  Icons.photo_album
              ),
              onPressed: () => pickImage(false),
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.lightBlueAccent,
              child: Icon(
                  Icons.camera_alt
              ),
              onPressed: () => pickImage(true),
              heroTag: null,
            )
          ]
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/backyard.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      )
    );

  }
  
}