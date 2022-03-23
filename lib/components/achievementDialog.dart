// import 'package:flutter/material.dart';
// import 'package:less_waste/components/achievements.dart';
//
// class AchievementDialog extends StatelessWidget{
//   @override
//   Widget build(BuildContext context, String state){
//     double width= MediaQuery.of(context).size.width;
//     double height= MediaQuery.of(context).size.height;
//     int stateIndex= Achievements.stateMap[state]??-1;
//     return Expanded(
//         child:
//         AlertDialog(
//           title: const Text("Congratulations!"),
//           content:
//           new Container(
//             width: 3*width/5,
//             height: height/3,
//             padding: const EdgeInsets.all(10.0),
//             child:
//             new Column(
//               children: [
//                 Expanded(child: stateIndex>-1? Image.asset(Achievements.imageList[stateIndex]):Image.asset(Achievements.imageList[12])),
//                 Text(
//                     stateIndex>-1?"You have made the achievement "+Achievements.achievementNameList[stateIndex]:"Something goes wrong. We are fixing it.",
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontWeight: FontWeight.bold))
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, 'OK'),
//               child: const Text('OK'),
//             ),
//           ],
//         )
//     );
//   }
// }