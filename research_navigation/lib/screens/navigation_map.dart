import 'package:flutter/material.dart';

class NavigationTurnPage extends StatefulWidget {
  const NavigationTurnPage({Key? key}) : super(key: key);

  @override
  State<NavigationTurnPage> createState() => _NavigationTurnPageState();
}

class _NavigationTurnPageState extends State<NavigationTurnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turn by turn')),
      body: const Text('Turn by turn navigation')
      
    );
  }
}
