import 'package:flutter/material.dart';

String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';
String cowUrl = 'https://i.stack.imgur.com/XPOr3.png';
String camelUrl = 'https://i.stack.imgur.com/YN0m7.png';
String sheepUrl = 'https://i.stack.imgur.com/wKzo8.png';
String goatUrl = 'https://i.stack.imgur.com/Qt4JP.png';

class BodyWidget extends StatelessWidget {
  var category;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(horseUrl),
            ),
            title: Text('Meat'),
            subtitle: Text('A strong animal'),
            onTap: () {
              print('Meat');
              category = 'Meat';
              //Navigator.pop(context, category);
            },
            selected: true,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/category/meat.png"),
            ),
            title: Text('Milk Product'),
            subtitle: Text('Provider of milk'),
            onTap: () {
              print('MilkProduct');
              category = 'Milk Product';
              //Navigator.pop(context, category);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(camelUrl),
            ),
            title: Text('Seafood'),
            subtitle: Text('Comes with humps'),
            onTap: () {
              print('Seafood');
              category = 'Seafood';
              //Navigator.pop(context, category);
            },
            enabled: false,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(sheepUrl),
            ),
            title: Text('Fruits'),
            subtitle: Text('Provides wool'),
            onTap: () {
              print('Fruits');
              category = 'Fruits';
              //Navigator.pop(context, category);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(goatUrl),
            ),
            title: Text('Vegetables'),
            subtitle: Text('Some have horns'),
            onTap: () {
              print('Vegetables');
              category = 'Vegetables';
              //Navigator.pop(context, category);
            },
          ),
        ],
      ),
    );
  }
}
