import 'package:flutter/material.dart';

String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';
String cowUrl = 'https://i.stack.imgur.com/XPOr3.png';
String camelUrl = 'https://i.stack.imgur.com/YN0m7.png';
String sheepUrl = 'https://i.stack.imgur.com/wKzo8.png';
String goatUrl = 'https://i.stack.imgur.com/Qt4JP.png';

class BodyWidget extends StatelessWidget {
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
            title: Text('Horse'),
            subtitle: Text('A strong animal'),
            onTap: () {
              print('horse');
            },
            selected: true,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/category/meat.png"),
            ),
            title: Text('Cow'),
            subtitle: Text('Provider of milk'),
            onTap: () {
              print('cow');
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(camelUrl),
            ),
            title: Text('Camel'),
            subtitle: Text('Comes with humps'),
            onTap: () {
              print('camel');
            },
            enabled: false,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(sheepUrl),
            ),
            title: Text('Sheep'),
            subtitle: Text('Provides wool'),
            onTap: () {
              print('sheep');
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(goatUrl),
            ),
            title: Text('Goat'),
            subtitle: Text('Some have horns'),
            onTap: () {
              print('goat');
            },
          ),
        ],
      ),
    );
  }
}
