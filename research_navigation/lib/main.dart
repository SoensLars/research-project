import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:research_navigation/screens/create_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late StreamSubscription connection;
  var connectionAvailable = false;
  bool popupAlert = false;

  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  checkConnectivity() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      connectionAvailable = await InternetConnectionChecker().hasConnection;
      if (!connectionAvailable && popupAlert == false) {
        showPopup();
        setState((() => popupAlert = true));
      }
    });
  }

  showPopup() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: const [
                    Text(
                      'No network connection',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text('Please check your internet connectivity.'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => popupAlert = false);
                  connectionAvailable =
                      await InternetConnectionChecker().hasConnection;
                  if (!connectionAvailable && popupAlert == false) {
                    showPopup();
                    setState(() => popupAlert = true);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create route'),
      ),
      body: const CreateRoute(),
    );
  }
}
