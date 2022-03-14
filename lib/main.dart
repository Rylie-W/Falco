// Create an infinite scrolling lazily loaded list

import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'models/dashboard.dart';

void main() async => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Nutrivali';

    return MaterialApp(
      title: appName,

      theme: ThemeData(

        brightness: Brightness.dark,
        primaryColor: const Color(0xFFfafafa),
        primaryColorDark: const Color(0xFF4f4f4f),
        accentColor: const Color(0xFFff7b73),
        backgroundColor: const Color(0xFF807d82),
        canvasColor: const Color(0xFFfafafa),

        fontFamily: 'Ubuntu',

        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          subtitle1: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: Dashboard(),
    );
  }
}


//
//     return new MaterialApp(
//       title: 'Startup Name Generator',
//       theme: new ThemeData(          // 新增代码开始...
//         primaryColor: Colors.black26,
//       ),
//       home: new RandomWords(),
//     );
//   }
// }
//
// class RandomWords extends StatefulWidget {
//   @override
//   RandomWordsState createState() => new RandomWordsState();
// }
//
// class RandomWordsState extends State<RandomWords> {
//   final List<WordPair> _suggestions = <WordPair>[];
//   final Set<WordPair> _saved = new Set<WordPair>();
//   final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: const Text('Startup Name Generator'),
//       actions: <Widget>[
//         new IconButton(icon: const Icon(Icons.list),onPressed: _pushSaved),
//       ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }
//
//   void _pushSaved(){
//     Navigator.of(context).push(
//       new MaterialPageRoute<void>(   // 新增如下20行代码 ...
//         builder: (BuildContext context) {
//           final Iterable<ListTile> tiles = _saved.map(
//                 (WordPair pair) {
//               return new ListTile(
//                 title: new Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//               );
//             },
//           );
//           final List<Widget> divided = ListTile
//               .divideTiles(
//             context: context,
//             tiles: tiles,
//           )
//               .toList();
//
//           return new Scaffold(         // 新增 6 行代码开始 ...
//             appBar: new AppBar(
//               title: const Text('Saved Suggestions'),
//             ),
//             body: new ListView(children: divided),
//           );
//
//         },
//       ),
//     );
//   }
//   Widget _buildSuggestions() {
//     return new ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemBuilder: (BuildContext _context, int i) {
//           if (i.isOdd) {
//             return const Divider();
//           }
//           final int index = i ~/ 2;
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(10));
//           }
//           return _buildRow(_suggestions[index]);
//         });
//   }
//
//   Widget _buildRow(WordPair pair) {
//     final bool alreadySaved = _saved.contains(pair);
//     return new ListTile(
//       title: new Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: new Icon(
//         alreadySaved ? Icons.favorite :Icons.favorite_border,
//         color: alreadySaved ? Colors.red :null,
//       ),
//       onTap: () {      // 增加如下 9 行代码...
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }
// }