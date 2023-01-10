import 'package:flutter/material.dart';
import 'package:research_navigation/components/create_ride_btn.dart';
import 'package:research_navigation/screens/route_overview.dart';

import '../components/endpoints_card.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(children: [
          endpointsCard(sourceController, destinationController),
          createRideBtn(context)
        ]),
      ),
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
}
