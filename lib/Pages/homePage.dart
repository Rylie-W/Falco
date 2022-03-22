import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // camera related
  late String imagePath;
  Future pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;


    setState(() {
      imagePath = image.path;
    });
    doUpload(image);
  }

  //upload picture request related
  final url_to_api = "http://34.65.81.128:5000/";
  doUpload(image) async {
    final imageTemp = XFile(image.path);
    final bytes = String.fromCharCodes(await XFile(imageTemp.path).readAsBytes());
    print(bytes);
    http.get(Uri.parse(url_to_api)).then((response) {
      print('success');
      print(json.decode(response.body));
    }).catchError((error) {
      print(error);
      print("fail");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.camera_alt),
        onPressed: () {
          pickImage();
        },
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