import 'package:flutter/material.dart';

void main() {
  runApp(const RumourApp());
}

class RumourApp extends StatelessWidget {
  const RumourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rumour',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(
          child: Text('Rumour - Initializing'),
        ),
      ),
    );
  }
}
