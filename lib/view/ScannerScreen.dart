import 'package:flutter/material.dart';

class Scannerscreen extends StatefulWidget {
  const Scannerscreen({super.key});

  @override
  State<Scannerscreen> createState() => _ScannerscreenState();
}

class _ScannerscreenState extends State<Scannerscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner Screen'),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Column(children: [Text('Scanner Screen')]),
    );
  }
}
