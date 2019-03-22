import 'package:flutter/material.dart';

class SystemFragment extends StatefulWidget {
  @override
  _SystemFragmentState createState() => _SystemFragmentState();
}

class _SystemFragmentState extends State<SystemFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("体系"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("体系"),
      ),
    );
  }
}
