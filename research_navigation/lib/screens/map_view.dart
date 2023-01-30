import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

class MapOverview extends StatefulWidget {
  final double lat;
  final double lng;
  final double locationLat;
  final double locationLng;
  const MapOverview(this.lat, this.lng, this.locationLat, this.locationLng,
      {super.key});

  @override
  State<MapOverview> createState() => _MapOverviewState();
}

class _MapOverviewState extends State<MapOverview> {
  final Completer<GoogleMapController?> mapController = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? yourLocation, destinationLocation;
  loc.LocationData? currentPosition;
  LatLng curLocation = const LatLng(0, 0);
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  initState() {
    super.initState();
    getLocation();
    getNavigation();
    addMarker();
  }

  @override
  dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route map overview')),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: curLocation,
              zoom: 16,
            ),
            markers: {yourLocation!, destinationLocation!},
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
          ),
        ],
      ),
    );
  }

  getNavigation() async {
    bool serviceEnabled;
    PermissionStatus permissionRequest;
    final GoogleMapController? controller = await mapController.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionRequest = await location.hasPermission();
    if (permissionRequest == PermissionStatus.denied) {
      permissionRequest = await location.requestPermission();
      if (permissionRequest != PermissionStatus.granted) {
        return;
      }
    }
    if (permissionRequest == loc.PermissionStatus.granted) {
      currentPosition = await location.getLocation();
      curLocation =
          LatLng(currentPosition!.latitude!, currentPosition!.longitude!);
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 12,
        )));
        if (mounted) {
          controller
              ?.showMarkerInfoWindow(MarkerId(yourLocation!.markerId.value));
          setState(() {
            curLocation =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            yourLocation = Marker(
              markerId: MarkerId(currentLocation.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
              infoWindow: InfoWindow(
                  title:
                      '${double.parse((getDistance(LatLng(widget.lat, widget.lng)).toStringAsFixed(2)))} km'),
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
        'YOUR_KEY',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.bicycling);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      }
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  getLocation() {
    curLocation = LatLng(widget.locationLat, widget.locationLng);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }

  addMarker() {
    setState(() {
      yourLocation = Marker(
        markerId: const MarkerId('Your location'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      destinationLocation = Marker(
        markerId: const MarkerId('Destination'),
        position: LatLng(widget.lat, widget.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }
}
