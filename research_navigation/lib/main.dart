import 'package:flutter/material.dart';
import 'package:research_navigation/screens/create_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  int currentPage = 0;
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

// import 'package:flutter/material.dart';
// import 'package:flutter_uber_location/navigation_screen.dart';
// import 'package:research_navigation/screens/route_overview.dart';

// main() {
//   runApp(MaterialApp(
//     home: MyApp(),
//   ));
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   TextEditingController latController = TextEditingController();
//   TextEditingController lngController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter uber'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Text(
//             'Enter your location',
//             style: TextStyle(fontSize: 40),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           TextField(
//             controller: latController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'latitude',
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextField(
//             controller: lngController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'longitute',
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             width: double.infinity,
//             child: ElevatedButton(
//                 onPressed: () {
//                  Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => OverviewPage(
//                           double.parse(latController.text),
//                           double.parse(lngController.text))));
//                 },
//                 child: Text('Get Directions')),
//           ),
//         ]),
//       ),
//     );
//   }
// }

