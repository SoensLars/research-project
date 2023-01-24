import 'package:flutter/material.dart';
import 'locations_input.dart';

// Widget inputField(TextEditingController sourceController, TextEditingController destinationController) {
//   return Card(
//     elevation: 2,
//     clipBehavior: Clip.antiAlias,
//     margin: const EdgeInsets.all(0),
//     child: Container(
//       padding: const EdgeInsets.all(15),
//       child: Row(
//         children: [
//           Column(
//             children: [
//               const Text("A"),
//               Container(
//                 margin: const EdgeInsets.only(top: 3),
//                 color: Colors.black,
//                 width: 1,
//                 height: 40,
//               ),
//               const Text("B"),
//             ],
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 LocationField(
//                     isDestination: false,
//                     textEditingController: sourceController),
//                 LocationField(
//                     isDestination: true,
//                     textEditingController: destinationController),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
// );}