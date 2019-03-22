import 'package:flutter/material.dart';
import 'package:flutter_sixteenhome/entity/projectData.dart';
import 'package:flutter_sixteenhome/entity/project_type.dart';
import 'package:flutter_sixteenhome/utils/net_utils.dart';
import 'package:flutter_sixteenhome/utils/print_utils.dart';
import 'package:flutter_sixteenhome/view/ArticalListPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectFragment extends StatefulWidget {
  @override
  _ProjectFragmentState createState() => _ProjectFragmentState();
}

class _ProjectFragmentState extends State<ProjectFragment>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  RefreshController _refreshController;
  List<ProjectType> list = List();
  List _list = List();
  int tabId = 0;

//  List _data = List();
  ProjectData projectData;
  ProjectType projectType;

  @override
  void initState() {
    setTabBar();
    _refreshController = RefreshController();
    super.initState();
  }

  Future setTabBar() async {
    list.clear();
    _list.clear();
    String url = "project/tree/json";
    Map<String, dynamic> response = await NetUtils.get(url);
    print("*"*100);
    print(response);
    if (response["errorCode"] == 0) {
      setState(() {
        projectType = ProjectType.fromMap(response);
        list.add(projectType);
        _list.addAll(projectType.data);
        tabId=_list[0].id;
      });
    }
  }



  Future<Map<String,dynamic>> getProjectListData(int currentPage,int id) async {
    String url = "project/list/$currentPage/json?cid=$id";
    PrintUtils.printValue(url);
    return await NetUtils.get(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("项目"),
        centerTitle: true,
        bottom: _buildTabBar(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (null == _tabController) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return TabBarView(
        controller: _tabController,
        children: _buildPages(projectType),
      );
    }
  }

  Widget _buildSinglePage(type) {
    return ArticalListPage(
      (currentPage){
        return getProjectListData(currentPage,type.id);
      },
      true,
    );
  }

  List<Widget> _buildPages(ProjectType projectType) {
    List<Widget> widgets = projectType.data.map(_buildSinglePage).toList();
    return widgets;
  }

  PreferredSizeWidget _buildTabBar() {
    if (_list.length <= 0) {
      return null;
    }
    if (_tabController == null) {
      _tabController =
          TabController(initialIndex: 0, vsync: this, length: _list.length);
      _tabController.addListener(() {
        PrintUtils.printValue("addListener");
          tabId = _list[_tabController.index].id;
      });
    }
    return TabBar(
      controller: _tabController,
      tabs: _buildTabs(),
      labelColor: Colors.white,
      isScrollable: true,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(bottom: 2.0),
      indicatorWeight: 1.0,
      indicatorColor: Colors.white,
    );
  }

  List<Widget> _buildTabs() {
    return _list.map((v) {
      return Tab(
        text: v.name,
      );
    }).toList();
  }

  @override
  bool get wantKeepAlive => true;
}
