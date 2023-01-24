// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../screens/route_overview.dart';

// class LocationField extends StatefulWidget {
//   final bool isDestination;
//   final TextEditingController textEditingController;

//   const LocationField({
//     Key? key,
//     required this.isDestination,
//     required this.textEditingController,
//   }) : super(key: key);

//   @override
//   State<LocationField> createState() => _LocationFieldState();
// }

// class _LocationFieldState extends State<LocationField> {
//   Timer? searchOnStoppedTyping;
//   String query = '';

//   @override
//   Widget build(BuildContext context) {
//     String placeholderText = widget.isDestination ? 'Destination' : 'Starting point';
//     IconData? iconData = !widget.isDestination ? Icons.my_location : null;
//     return Padding(
//       padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
//       child: CupertinoTextField(
//           controller: widget.textEditingController,
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           placeholder: placeholderText,
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: const BorderRadius.all(Radius.circular(5)),
//           ),
//           // onChanged: _onChangeHandler,
//           suffix: IconButton(
//               onPressed: () {
//                 Navigator.of(context)
//                     .push(MaterialPageRoute(builder: (BuildContext context) {
//                   return const OverviewPage();
//                 }));
//               },
//               padding: const EdgeInsets.all(10),
//               constraints: const BoxConstraints(),
//               icon: Icon(iconData, size: 16))),
//     );
//   }
// }
