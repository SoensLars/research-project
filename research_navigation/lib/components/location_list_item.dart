import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget LocationListItem() {
  return ListTile(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    leading: const SizedBox(
      height: 400,
      child: CircleAvatar(
        child: Icon(Icons.location_on),
      ),
    ),
    title: const Text('Location Name',
        style: TextStyle(fontWeight: FontWeight.bold)),
    // ignore: prefer_const_constructors
    subtitle: Text('Address', overflow: TextOverflow.ellipsis),
    trailing: const Icon(Icons.keyboard_arrow_right),
    tileColor: Colors.grey[200],
  );
}
