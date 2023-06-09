import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Show extends StatefulWidget {
  String url;
  Show(this.url);
  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: Image.network(widget.url, width: double.infinity),
    );
  }
}
