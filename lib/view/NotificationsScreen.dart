import 'package:flutter/material.dart';

class Notificationsscreen extends StatefulWidget {
  const Notificationsscreen({super.key});

  @override
  State<Notificationsscreen> createState() => _NotificationsscreenState();
}

class _NotificationsscreenState extends State<Notificationsscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Screen'),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Column(children: [Text('Notifications Screen')]),
    );
  }
}
