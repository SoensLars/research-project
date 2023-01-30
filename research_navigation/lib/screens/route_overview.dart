import 'package:flutter/material.dart';
import 'package:research_navigation/screens/navigation_ar.dart';
import 'package:research_navigation/screens/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

class OverviewPage extends StatefulWidget {
  final double lat;
  final double lng;
  final String chosenLocation;
  const OverviewPage(this.lat, this.lng, this.chosenLocation, {super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  LatLng curLocation = const LatLng(0, 0);
  double time = 0;
  bool showDistTime = false;

  @override
  initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route details')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const SizedBox(
                              height: 55,
                              width: 55,
                              child: CircleAvatar(
                                  child: Icon(Icons.my_location, size: 30.0)),
                            ),
                            const SizedBox(width: 15),
                            const Expanded(
                                child: Text('Your location',
                                    style: TextStyle(fontSize: 18)))
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(27, 10, 0, 10),
                              color: Colors.grey[300],
                              width: 1,
                              height: 40,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              height: 55,
                              width: 55,
                              child: CircleAvatar(
                                  child: Icon(Icons.flag, size: 30.0)),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(widget.chosenLocation,
                                  style: const TextStyle(fontSize: 18)),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text('Distance from point to point',
                            style: TextStyle(fontSize: 18)),
                        showDistTime
                            ? Text(
                                '${double.parse((getDistance(LatLng(widget.lat, widget.lng)).toStringAsFixed(2)))} km',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                'Calculating...',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text('Estimated time',
                            style: TextStyle(fontSize: 18)),
                        showDistTime
                            ? Text(
                                "${time.round()}min",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                "Calculating...",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    )
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text('View detailed route'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MapOverview(
                                widget.lat,
                                widget.lng,
                                curLocation.latitude,
                                curLocation.longitude)));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text('Turn by turn navigation'),
                      onPressed: () async {
                        await launchUrl(Uri.parse(
                            'google.navigation:q=${widget.lat}, ${widget.lng}&key=YOUR_KEY&mode=b'));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text('AR navigation'),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return NavigationArPage("right", 100);
                        }));
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  calculateTime() {
    var calculatedTime = getDistance(LatLng(widget.lat, widget.lng)) * 4.5;
    if (calculatedTime < 1) {
      time = 1;
    } else {
      time = calculatedTime;
    }
  }

  getLocation() async {
    var location = Location();
    var currentLocation = await location.getLocation();
    setState(() {
      curLocation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      calculateTime();
      showDistTime = true;
    });
  }

  getDistance(LatLng destination) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destination.latitude, destination.longitude);
  }
}
