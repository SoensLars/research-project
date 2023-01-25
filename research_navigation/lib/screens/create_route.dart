import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:research_navigation/screens/route_overview.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CreateRoute extends StatefulWidget {
  const CreateRoute({Key? key}) : super(key: key);

  @override
  State<CreateRoute> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRoute> {
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  final TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String PLACES_API_KEY = "AIzaSyAlDkKrmY4QPk4WLmdzLJFvEuCYSa2wYdg";
    String request =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken";

    print(request);
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    // print('data');
    // print(data);

    if (response.statusCode == 200) {
      // print(response.body);
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(0),
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(Icons.location_on),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Destination',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //       itemCount: _placesList.length,
            //       itemBuilder: (context, index) {
            //         return ListTile(
            //           title: Text(_placesList[index]['description']),
            //           onTap: () async {
            //             var locations = await locationFromAddress(_placesList[index]['description']);
            //             // print(locations.last.longitude);
            //             // print(locations.last.latitude);
            //             lngController.text = locations.last.longitude.toString();
            //             latController.text = locations.last.latitude.toString();
            //           },
            //         );
            //       }),
            // )
            Expanded(
              child: ListView.builder(
                  itemCount: _placesList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const Divider(
                          color: Colors.transparent,
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () async {
                              var locations = await locationFromAddress(
                                  _placesList[index]['description']);
                              lngController.text =
                                  locations.last.longitude.toString();
                              latController.text =
                                  locations.last.latitude.toString();
                              _controller.text = _placesList[index]['description'];
                            },
                            leading: const SizedBox(
                              height: 400,
                              child: CircleAvatar(
                                child: Icon(Icons.location_on),
                              ),
                            ),
                            title: Text(_placesList[index]['structured_formatting']['main_text'],
                                style: const TextStyle(fontWeight: FontWeight.bold)
                            ),
                            tileColor: Colors.grey[200],
                            subtitle: Text('${_placesList[index]['structured_formatting']['secondary_text']}'),
                          ),
                        )
                      ],
                    );
                  }),
            )
            // Expanded(
            //   child: [
            //         const Divider(
            //           color: Colors.transparent,
            //           height: 12,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
            //           child: ListTile(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             onTap: () {
            //               setValuesHome();
            //             },
            //             leading: const SizedBox(
            //               height: 400,
            //               child: CircleAvatar(
            //                 child: Icon(Icons.home),
            //               ),
            //             ),
            //             title: const Text('Home',
            //                 style: TextStyle(fontWeight: FontWeight.bold)),
            //             // ignore: prefer_const_constructors
            //             subtitle: Text('50.865361, 3.299528',
            //                 overflow: TextOverflow.ellipsis),
            //             trailing: const Icon(Icons.keyboard_arrow_right),
            //             tileColor: Colors.grey[200],
            //           ),
            //         ),]
            // )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.directions_bike),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OverviewPage(
                      double.parse(latController.text),
                      double.parse(lngController.text))));
            },
            label: const Text('Create route')));

    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //       body: SafeArea(
    //         child: SingleChildScrollView(
    //           physics: const ScrollPhysics(),
    //           child: Column(
    //             children: [
    //               // inputField(sourceController, destinationController),
    //               Card(
    //                 elevation: 2,
    //                 clipBehavior: Clip.antiAlias,
    //                 margin: const EdgeInsets.all(0),
    //                 child: Container(
    //                   padding: const EdgeInsets.all(15),
    //                   child: Row(
    //                     children: [
    //                       Column(
    //                         children: [
    //                           const Text("A"),
    //                           Container(
    //                             margin: const EdgeInsets.only(top: 3),
    //                             color: Colors.black,
    //                             width: 1,
    //                             height: 40,
    //                           ),
    //                           const Text("B"),
    //                         ],
    //                       ),
    //                       Expanded(
    //                         child: Column(
    //                           children: [
    //                             // LocationField(
    //                             //     isDestination: false,
    //                             //     textEditingController: sourceController),
    //                             // LocationField(
    //                             //     isDestination: true,
    //                             //     textEditingController: destinationController),
    //                             SizedBox(
    //                               height: 50,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.symmetric(
    //                                     horizontal: 10),
    //                                 child: TextField(
    //                                   controller: latController,
    //                                   decoration: const InputDecoration(
    //                                     border: OutlineInputBorder(),
    //                                     labelText: 'latitude',
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             // ignore: prefer_const_constructors
    //                             SizedBox(
    //                               height: 20,
    //                             ),
    //                             SizedBox(
    //                               height: 50,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.symmetric(
    //                                     horizontal: 10),
    //                                 child: TextField(
    //                                   controller: lngController,
    //                                   decoration: const InputDecoration(
    //                                     border: OutlineInputBorder(),
    //                                     labelText: 'longtitude',
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Column(children: [
    //                 const Divider(
    //                   color: Colors.transparent,
    //                   height: 12,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
    //                   child: ListTile(
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     onTap: () {
    //                       setValuesHome();
    //                     },
    //                     leading: const SizedBox(
    //                       height: 400,
    //                       child: CircleAvatar(
    //                         child: Icon(Icons.home),
    //                       ),
    //                     ),
    //                     title: const Text('Home',
    //                         style: TextStyle(fontWeight: FontWeight.bold)),
    //                     // ignore: prefer_const_constructors
    //                     subtitle: Text('50.865361, 3.299528',
    //                         overflow: TextOverflow.ellipsis),
    //                     trailing: const Icon(Icons.keyboard_arrow_right),
    //                     tileColor: Colors.grey[200],
    //                   ),
    //                 ),
    //                 const Divider(
    //                   color: Colors.transparent,
    //                   height: 12,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
    //                   child: ListTile(
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     onTap: () {
    //                       setValuesWork();
    //                     },
    //                     leading: const SizedBox(
    //                       height: 400,
    //                       child: CircleAvatar(
    //                         child: Icon(Icons.work),
    //                       ),
    //                     ),
    //                     title: const Text('Work',
    //                         style: TextStyle(fontWeight: FontWeight.bold)),
    //                     // ignore: prefer_const_constructors
    //                     subtitle: Text('50.824892, 3.300710',
    //                         overflow: TextOverflow.ellipsis),
    //                     trailing: const Icon(Icons.keyboard_arrow_right),
    //                     tileColor: Colors.grey[200],
    //                   ),
    //                 ),
    //                 const Divider(
    //                   color: Colors.transparent,
    //                   height: 12,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
    //                   child: ListTile(
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     onTap: () {
    //                       setValuesSchool();
    //                     },
    //                     leading: const SizedBox(
    //                       height: 400,
    //                       child: CircleAvatar(
    //                         child: Icon(Icons.school),
    //                       ),
    //                     ),
    //                     title: const Text('School',
    //                         style: TextStyle(fontWeight: FontWeight.bold)),
    //                     // ignore: prefer_const_constructors
    //                     subtitle: Text('50.824499, 3.251003',
    //                         overflow: TextOverflow.ellipsis),
    //                     trailing: const Icon(Icons.keyboard_arrow_right),
    //                     tileColor: Colors.grey[200],
    //                   ),
    //                 ),
    //                 const Divider(
    //                   color: Colors.transparent,
    //                   height: 12,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
    //                   child: ListTile(
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     onTap: () {
    //                       setValuesBrewery();
    //                     },
    //                     leading: const SizedBox(
    //                       height: 400,
    //                       child: CircleAvatar(
    //                         child: Icon(Icons.sports_bar),
    //                       ),
    //                     ),
    //                     title: const Text('Brewery De Brabandere',
    //                         style: TextStyle(fontWeight: FontWeight.bold)),
    //                     // ignore: prefer_const_constructors
    //                     subtitle: Text('50.862760, 3.299245',
    //                         overflow: TextOverflow.ellipsis),
    //                     trailing: const Icon(Icons.keyboard_arrow_right),
    //                     tileColor: Colors.grey[200],
    //                   ),
    //                 ),
    //                 const Divider(
    //                   color: Colors.transparent,
    //                   height: 12,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
    //                   child: ListTile(
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     onTap: () {
    //                       setValuesColruyt();
    //                     },
    //                     leading: const SizedBox(
    //                       height: 400,
    //                       child: CircleAvatar(
    //                         child: Icon(Icons.shopping_cart),
    //                       ),
    //                     ),
    //                     title: const Text('Colruyt Kuurne',
    //                         style: TextStyle(fontWeight: FontWeight.bold)),
    //                     // ignore: prefer_const_constructors
    //                     subtitle: Text('50.844670, 3.270857',
    //                         overflow: TextOverflow.ellipsis),
    //                     trailing: const Icon(Icons.keyboard_arrow_right),
    //                     tileColor: Colors.grey[200],
    //                   ),
    //                 ),
    //                 const Divider(
    //                   color: Colors.transparent,
    //                   height: 12,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
    //                   child: ListTile(
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                     onTap: () {
    //                       setValuesCarhartt();
    //                     },
    //                     leading: const SizedBox(
    //                       height: 400,
    //                       child: CircleAvatar(
    //                         child: Icon(Icons.checkroom),
    //                       ),
    //                     ),
    //                     title: const Text('Carhartt WIP Store Ghent',
    //                         style: TextStyle(fontWeight: FontWeight.bold)),
    //                     // ignore: prefer_const_constructors
    //                     subtitle: Text('51.048323, 3.727019',
    //                         overflow: TextOverflow.ellipsis),
    //                     trailing: const Icon(Icons.keyboard_arrow_right),
    //                     tileColor: Colors.grey[200],
    //                   ),
    //                 ),
    //               ])
    //             ],
    //           ),
    //         ),
    //       ),
    //       floatingActionButton: FloatingActionButton.extended(
    //           icon: const Icon(Icons.directions_bike),
    //           onPressed: () {
    //             Navigator.of(context).push(MaterialPageRoute(
    //                 builder: (context) => OverviewPage(
    //                     double.parse(latController.text),
    //                     double.parse(lngController.text))));
    //           },
    //           label: const Text('Create route')));
  }

  // setValuesHome() =>
  //     {latController.text = '50.865361', lngController.text = '3.299528'};

  // setValuesWork() =>
  //     {latController.text = '50.824892', lngController.text = '3.300710'};

  // setValuesSchool() =>
  //     {latController.text = '50.824499', lngController.text = '3.251003'};

  // setValuesBrewery() =>
  //     {latController.text = '50.862760', lngController.text = '3.299245'};

  // setValuesColruyt() =>
  //     {latController.text = '50.844670', lngController.text = '3.270857'};

  // setValuesCarhartt() =>
  //     {latController.text = '51.048323', lngController.text = '3.727019'};
}
