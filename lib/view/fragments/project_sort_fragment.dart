import 'package:flutter/material.dart';

class ProjectSortFragment extends StatefulWidget {
  @override
  _ProjectSortFragmentState createState() => _ProjectSortFragmentState();
}

class _ProjectSortFragmentState extends State<ProjectSortFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("项目分类"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("项目分类"),
      ),
    );
  }
}
