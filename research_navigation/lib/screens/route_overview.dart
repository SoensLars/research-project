import 'package:flutter/material.dart';
import 'package:research_navigation/screens/navigation_ar.dart';
import 'package:research_navigation/screens/navigation_map.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

import '../main.dart';

class OverviewPage extends StatefulWidget {
  // const OverviewPage({Key? key}) : super(key: key);
  final double lat;
  final double lng;
  OverviewPage(this.lat, this.lng);

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  loc.LocationData? _currentPosition;
  LatLng curLocation = const LatLng(50.865361, 3.299528);
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route overview')),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Text(widget.lat.toString()),
            SizedBox(
              height: 500,
              child: GoogleMap(
                zoomControlsEnabled: false,
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: CameraPosition(
                  target: curLocation,
                  zoom: 10,
                ),
                markers: {sourcePosition!, destinationPosition!},
                onTap: (latLng) {
                  print(latLng);
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            // Text('Your location -> ${widget.lat}, ${widget.lng}'),
            Row(
              children: [
                const Text("Your location"),
                const SizedBox(width: 8),
                // const Text("->"),
                const Icon(Icons.trending_flat, color: Colors.red),
                const SizedBox(width: 8),
                Text("${widget.lat.toString()}, ${widget.lng.toString()}"),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('Turn by turn navigation'),
              onPressed: () async {
                await launchUrl(Uri.parse(
                    'google.navigation:q=${widget.lat}, ${widget.lng}&key=AIzaSyAlDkKrmY4QPk4WLmdzLJFvEuCYSa2wYdg'));
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('AR navigation'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const NavigationArPage();
                }));
              },
            ),
          ],
        ),
      ),
      // body: sourcePosition == null
      //     ? Center(child: CircularProgressIndicator())
      //     : Stack(
      //         children: [
      //           GoogleMap(
      //             zoomControlsEnabled: false,
      //             polylines: Set<Polyline>.of(polylines.values),
      //             initialCameraPosition: CameraPosition(
      //               target: curLocation,
      //               zoom: 16,
      //             ),
      //             markers: {sourcePosition!, destinationPosition!},
      //             onTap: (latLng) {
      //               print(latLng);
      //             },
      //             onMapCreated: (GoogleMapController controller) {
      //               _controller.complete(controller);
      //             },
      //           ),
      //           Positioned(
      //               bottom: 20,
      //               right: 20,
      //               child: Container(
      //                 width: 50,
      //                 height: 50,
      //                 decoration: BoxDecoration(
      //                     shape: BoxShape.circle, color: Colors.blue),
      //                 child: Center(
      //                   child: IconButton(
      //                     icon: Icon(
      //                       Icons.navigation_outlined,
      //                       color: Colors.white,
      //                     ),
      //                     onPressed: () async {
      //                       await launchUrl(Uri.parse(
      //                           'google.navigation:q=${widget.lat}, ${widget.lng}&key=YOUR_API_KEY'));
      //                     },
      //                   ),
      //                 ),
      //               )),
      //         ],
      //       ),
      // body: Stack(
      //   children: [
      //     // GoogleMap(
      //     //   zoomControlsEnabled: false,
      //     //   polylines: Set<Polyline>.of(polylines.values),
      //     //   initialCameraPosition: CameraPosition(
      //     //     target: curLocation,
      //     //     zoom: 16,
      //     //   ),
      //     //   markers: {sourcePosition!, destinationPosition!},
      //     //   onTap: (latLng) {
      //     //     print(latLng);
      //     //   },
      //     //   onMapCreated: (GoogleMapController controller) {
      //     //     _controller.complete(controller);
      //     //   },
      //     // ),
      //     Positioned(
      //         bottom: 20,
      //         right: 20,
      //         child: Container(
      //           width: 50,
      //           height: 50,
      //           decoration:
      //               BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      //           child: Center(
      //             child: IconButton(
      //               icon: Icon(
      //                 Icons.navigation_outlined,
      //                 color: Colors.white,
      //               ),
      //               onPressed: () async {
      //                 await launchUrl(Uri.parse(
      //                     'google.navigation:q=${widget.lat}, ${widget.lng}&key=YOUR_API_KEY'));
      //               },
      //             ),
      //           ),
      //         )),
      //     Positioned(
      //         bottom: 20,
      //         right: 70,
      //         child: Container(
      //           width: 50,
      //           height: 50,
      //           decoration:
      //               BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      //           child: Center(
      //             child: IconButton(
      //               icon: Icon(
      //                 Icons.navigation_outlined,
      //                 color: Colors.white,
      //               ),
      //               onPressed: () {
      //                 Navigator.of(context).push(
      //                     MaterialPageRoute(builder: (BuildContext context) {
      //                   return const NavigationArPage();
      //                 }));
      //               },
      //             ),
      //           ),
      //         )),
      //   ],
      // ),
    );
  }

  getNavigation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 16,
        )));
        if (mounted) {
          controller
              ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
          setState(() {
            curLocation =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            sourcePosition = Marker(
              markerId: MarkerId(currentLocation.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
              infoWindow: InfoWindow(
                  title:
                      '${double.parse((getDistance(LatLng(widget.lat, widget.lng)).toStringAsFixed(2)))} km'),
              onTap: () {
                print('market tapped');
              },
            );
          });
          getDirections(LatLng(widget.lat, widget.lng));
        }
      });
    }
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyAlDkKrmY4QPk4WLmdzLJFvEuCYSa2wYdg',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }

  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      destinationPosition = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(widget.lat, widget.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart' as loc;
// import 'package:location/location.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:math' show cos, sqrt, asin;

// import '../main.dart';
// import 'create_route.dart';

// class OverviewPage extends StatefulWidget {
//   final double lat;
//   final double lng;
//   OverviewPage(this.lat, this.lng);

//   @override
//   State<OverviewPage> createState() => _OverviewPageState();
// }

// class _OverviewPageState extends State<OverviewPage> {
//   final Completer<GoogleMapController?> _controller = Completer();
//   Map<PolylineId, Polyline> polylines = {};
//   PolylinePoints polylinePoints = PolylinePoints();
//   Location location = Location();
//   Marker? sourcePosition, destinationPosition;
//   loc.LocationData? _currentPosition;
//   LatLng curLocation = LatLng(23.0525, 72.5667);
//   StreamSubscription<loc.LocationData>? locationSubscription;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getNavigation();
//     addMarker();
//   }

//   @override
//   void dispose() {
//     locationSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: sourcePosition == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 GoogleMap(
//                   zoomControlsEnabled: false,
//                   polylines: Set<Polyline>.of(polylines.values),
//                   initialCameraPosition: CameraPosition(
//                     target: curLocation,
//                     zoom: 16,
//                   ),
//                   markers: {sourcePosition!, destinationPosition!},
//                   onTap: (latLng) {
//                     print(latLng);
//                   },
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller.complete(controller);
//                   },
//                 ),
//                 Positioned(
//                   top: 30,
//                   left: 15,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(builder: (context) => MyApp()),
//                           (route) => false);
//                     },
//                     child: Icon(Icons.arrow_back),
//                   ),
//                 ),
//                 Positioned(
//                     bottom: 10,
//                     right: 10,
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.blue),
//                       child: Center(
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.navigation_outlined,
//                             color: Colors.white,
//                           ),
//                           onPressed: () async {
//                             await launchUrl(Uri.parse(
//                                 'google.navigation:q=${widget.lat}, ${widget.lng}&key=YOUR_API_KEY'));
//                           },
//                         ),
//                       ),
//                     ))
//               ],
//             ),
//     );
//   }

//   getNavigation() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     final GoogleMapController? controller = await _controller.future;
//     location.changeSettings(accuracy: loc.LocationAccuracy.high);
//     _serviceEnabled = await location.serviceEnabled();

//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     if (_permissionGranted == loc.PermissionStatus.granted) {
//       _currentPosition = await location.getLocation();
//       curLocation =
//           LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
//       locationSubscription =
//           location.onLocationChanged.listen((LocationData currentLocation) {
//         controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
//           zoom: 16,
//         )));
//         if (mounted) {
//           controller
//               ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
//           setState(() {
//             curLocation =
//                 LatLng(currentLocation.latitude!, currentLocation.longitude!);
//             sourcePosition = Marker(
//               markerId: MarkerId(currentLocation.toString()),
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueBlue),
//               position:
//                   LatLng(currentLocation.latitude!, currentLocation.longitude!),
//               infoWindow: InfoWindow(
//                   title: '${double.parse(
//                           (getDistance(LatLng(widget.lat, widget.lng))
//                               .toStringAsFixed(2)))} km'
//                      ),
//               onTap: () {
//                 print('market tapped');
//               },
//             );
//           });
//           getDirections(LatLng(widget.lat, widget.lng));
//         }
//       });
//     }
//   }

//   getDirections(LatLng dst) async {
//     List<LatLng> polylineCoordinates = [];
//     List<dynamic> points = [];
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         'YOUR_API_KEY',
//         PointLatLng(curLocation.latitude, curLocation.longitude),
//         PointLatLng(dst.latitude, dst.longitude),
//         travelMode: TravelMode.driving);
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         points.add({'lat': point.latitude, 'lng': point.longitude});
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     addPolyLine(polylineCoordinates);
//   }

//   addPolyLine(List<LatLng>polylineCoordinates) {
//     PolylineId id = PolylineId('poly');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.blue,
//       points: polylineCoordinates,
//       width: 5,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }

//    double calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   double getDistance(LatLng destposition) {
//     return calculateDistance(curLocation.latitude, curLocation.longitude,
//         destposition.latitude, destposition.longitude);
//   }
//   addMarker() {
//     setState(() {
//       sourcePosition = Marker(
//         markerId: MarkerId('source'),
//         position: curLocation,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//       );
//       destinationPosition = Marker(
//         markerId: MarkerId('destination'),
//         position: LatLng(widget.lat, widget.lng),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
//       );
//     });
//   }
// }
