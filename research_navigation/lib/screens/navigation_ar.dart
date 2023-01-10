import 'package:flutter/material.dart';

class NavigationArPage extends StatefulWidget {
  const NavigationArPage({Key? key}) : super(key: key);

  @override
  State<NavigationArPage> createState() => _NavigationArPageState();
}

class _NavigationArPageState extends State<NavigationArPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Navigation')),
      body: const Text('Ar Navigation')
      
    );
  }
}
