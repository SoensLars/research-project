import 'package:flutter/material.dart';
import '../screens/route_overview.dart';

Widget createRideBtn(BuildContext context) {
  return FloatingActionButton.extended(
      icon: const Icon(Icons.directions_bike),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return const OverviewPage();
        }));
      },
      label: const Text('Create route'));
}
