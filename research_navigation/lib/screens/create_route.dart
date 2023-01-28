import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  String destinationController = "";
  
  var uuid = const Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];

  bool enabled = false;
  bool viewPlaceholder = true;

  late StreamSubscription connection;
  var connectionAvailable = false;
  bool popupAlert = false;

  @override
  initState() {
    super.initState();

    _controller.addListener(() {
      onChange();
    });
  }

  onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    if (_controller.text.isEmpty) {
      enabled = false;
      viewPlaceholder = false;
    }

    if (_controller.text.isNotEmpty) {
      print(_controller);
    }

    getSuggestion(_controller.text);
  }

  getSuggestion(String input) async {
    String PLACES_API_KEY = "AIzaSyAlDkKrmY4QPk4WLmdzLJFvEuCYSa2wYdg";
    String request =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken";

    print(request);
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    if (response.statusCode == 200) {
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
            // ignore: prefer_const_constructors
            Expanded(
                child: !viewPlaceholder
                    ? ListView.builder(
                        itemCount: _placesList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const Divider(
                                color: Colors.transparent,
                                height: 12,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 4, 12, 4),
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
                                    destinationController = _placesList[index]
                                        ['structured_formatting']['main_text'];
                                    _controller.text =
                                        _placesList[index]['description'];
                                    enabled = true;
                                  },
                                  leading: const SizedBox(
                                    height: 400,
                                    child: CircleAvatar(
                                      child: Icon(Icons.location_on),
                                    ),
                                  ),
                                  title: Text(
                                      _placesList[index]
                                              ['structured_formatting']
                                          ['main_text'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  tileColor: Colors.grey[200],
                                  subtitle: Text(
                                      '${_placesList[index]['structured_formatting']['secondary_text']}'),
                                ),
                              )
                            ],
                          );
                        })
                    // ignore: prefer_const_constructors
                    : Center(
                        child: const Text('Search a destination in de box.'),
                      ))
          ],
        ),
        // ignore: prefer_const_constructors
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.directions_bike),
            onPressed: enabled
                ? () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OverviewPage(
                                double.parse(latController.text),
                                double.parse(lngController.text),
                                (destinationController).toString(),
                              )))
                    }
                : null,
            label: const Text('Create route'),
            backgroundColor: enabled ? Colors.red : Colors.grey[400]));
  }
}
