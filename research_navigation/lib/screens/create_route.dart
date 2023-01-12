import 'package:flutter/material.dart';
import 'package:research_navigation/components/create_ride_btn.dart';
import 'package:research_navigation/components/location_list_item.dart';
import 'package:research_navigation/screens/route_overview.dart';

import '../components/card_input.dart';

class CreateRoute extends StatefulWidget {
  const CreateRoute({Key? key}) : super(key: key);

  @override
  State<CreateRoute> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRoute> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              inputField(sourceController, destinationController),
              Column(children: [
                LocationListItem(),
                const Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                LocationListItem(),
                const Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                LocationListItem(),
                const Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                LocationListItem(),
                const Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                LocationListItem(),                
              ])
            ],
          ),
        ),
      ),
      floatingActionButton: createRideBtn(context),
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
