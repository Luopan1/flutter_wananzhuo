import 'package:flutter/material.dart';

class NavigationFragemnt extends StatefulWidget {
  @override
  _NavigationFragemntState createState() => _NavigationFragemntState();
}

class _NavigationFragemntState extends State<NavigationFragemnt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("导航"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("导航"),
      ),
    );
  }
}
