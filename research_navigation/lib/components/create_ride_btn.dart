import 'package:flutter/material.dart';

import '../screens/route_overview.dart';

Widget createRideBtn(BuildContext context) {
  return Row(
    // alignment: Alignment.bottomRight,
    // padding: const EdgeInsets.fromLTRB(0, 0, 20, 30),
    children: [
      FloatingActionButton.extended(
          icon: const Icon(Icons.directions_car_filled),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const OverviewPage();
            }));
          },
          label: const Text('Create route')),
    ],
  );

  // alignment: Alignment.bottomRight,
  // padding: const EdgeInsets.fromLTRB(0, 0, 20, 30),
  // child: FloatingActionButton.extended(
  //     icon: const Icon(Icons.directions_car_filled),
  //     onPressed: () {
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (BuildContext context) {
  //         return const OverviewPage();
  //       }));
  //     },
  //     label: const Text('Create route')));
}
