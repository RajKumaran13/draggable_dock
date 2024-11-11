import 'package:dock/dock.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final IconData icon;
  final bool placeHolder;

  const ItemWidget({
    super.key,
    required this.icon, ///Displayes icons
    this.placeHolder = false,  ///checks placeholer or not
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48),
      height: 48,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: placeHolder
            ? Colors.transparent  //if it's place holder no color
            : Colors.primaries[icon.hashCode % Colors.primaries.length], //if its placeholder picks color from primary colors
      ),
      child: Center(child: Icon(icon, color: Colors.white)), //display the icons inside the container(dock)
    );
  }
}


