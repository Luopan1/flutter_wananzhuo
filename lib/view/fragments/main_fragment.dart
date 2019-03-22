import 'package:banner_view/banner_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sixteenhome/BannerItemFactory.dart';
import 'package:flutter_sixteenhome/Pair.dart';
import 'package:flutter_sixteenhome/entity/banner.dart';
import 'package:flutter_sixteenhome/entity/first.dart';
import 'package:flutter_sixteenhome/utils/net_utils.dart';
import 'package:flutter_sixteenhome/utils/show_snack_bar.dart';
import 'package:flutter_sixteenhome/view/webview.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class MainFragment extends StatefulWidget {
  @override
  _MainFragmentState createState() => _MainFragmentState();
}

int currentPage = 0;

class _MainFragmentState extends State<MainFragment>
    with AutomaticKeepAliveClientMixin {
  List items = List();
  RefreshController _refreshController;
  int pageCount = 0;
  List<Pair<String, Color>> bannerLists = List();

  @override
  void initState() {
    _refreshController = RefreshController();
    getData(0);
    getBannerData();
    super.initState();
  }

  Future getData(int currentPage) async {
    String url = "article/list/$currentPage/json";
    var response = await NetUtils.get(url);
    _refreshController.sendBack(false, RefreshStatus.idle);
    if (response["errorCode"] == 0) {
      IndexData indexData = IndexData.fromJson(response);
      pageCount = indexData.data.pageCount;
      print(pageCount);
      if (indexData.data.over) {
        _refreshController.sendBack(false, RefreshStatus.noMore);
      }
      for (var item in indexData.data.datas) {
        items.add(item);
      }
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  Future getBannerData() async {
    String url = "banner/json";
    var response = await NetUtils.get(url);
    print(response);
    _refreshController.sendBack(true, RefreshStatus.idle);
    if (response["errorCode"] == 0) {
      BannerData bannerData = BannerData.fromJson(response);
      for (var i = 0; i < bannerData.data.length; i++) {
        bannerLists.add(Pair(bannerData.data[i].imagePath, Colors.transparent));
      }
      _refreshController.sendBack(false, RefreshStatus.noMore);
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchWidget(),
        centerTitle: true,
      ),
      body: Container(
        child: SmartRefresher(
          footerConfig: RefreshConfig(),
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onOffsetChange: _onOffsetCallback,
          child: ListView.builder(
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                if (bannerLists.length <= 0) {
                  return Container(
                    child: Center(
                      child: Text('loading……'),
                    ),
                  );
                }
                return Container(
                  height: 200,
                  child: _bannerView(bannerLists),
                );
              } else {
                return _itemBuilder(items, index - 1);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onOffsetCallback(bool up, double offset) {}

  void _onRefresh(bool up) {
    if (up) {
      print("下拉刷新");
      currentPage = 1;
      items.clear();
      bannerLists.clear();
      getBannerData();
      getData(0);
    } else {
      print("上拉加载更多");
      getData(++currentPage);
    }
  }

  void _collectActical(link, name, author, items, id) async {
    String url = "lg/collect/$id/json";
    FormData formData = FormData.from({
      'link': link,
      'title': name,
      'author': author,
    });
    var response = await NetUtils.postFormData(url, formData);
    print(response.toString());
    if (response["errorCode"] == 0) {
      ShowSnackBar.show(context, name, "收藏成功!", 3);
      setState(() {
        items.collect = true;
      });
    } else if (response["errorCode"] == -1001) {
      Navigator.of(context).pushNamed("/login");
    } else {
      ShowSnackBar.show(context, name, response["errorMsg"], 3);
    }
  }

  Widget _itemBuilder(List items, int index) {
    return Card(
        margin: EdgeInsets.all(8.0),
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 8.0,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return WebViewPage(items[index].link, items[index].title,
                  items[index].collect, items[index].id);
            }));
          },
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: items[index].collect ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  _collectActical(items[index].link, items[index].title,
                      items[index].author, items[index], items[index].id);
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: ScreenUtil.getInstance().setWidth(600),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      items[index].title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getInstance().setWidth(600),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("作者:"),
                        Text(
                          items[index].author,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: ScreenUtil.getInstance().setWidth(8),
                        ),
                        Text("分类:"),
                        Text(
                          items[index].chapterName,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: ScreenUtil.getInstance().setWidth(8),
                        ),
                        Text("时间:"),
                        Text(
                          items[index].niceDate,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("/search");
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "搜索关键字以空格形式隔开",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

BannerView _bannerView(List<Pair<String, Color>> lists) {
  return BannerView(
    BannerItemFactory.banners(lists),
    intervalDuration: Duration(seconds: 3),
    indicatorMargin: 10.0,
  );
}
