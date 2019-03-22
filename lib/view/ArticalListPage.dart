import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sixteenhome/entity/projectData.dart';
import 'package:flutter_sixteenhome/utils/translations.dart';
import 'package:flutter_sixteenhome/view/webview.dart';

typedef Future<Map<String, dynamic>> RequestData(int page);
//typedef Function OnRefresh(bool up);

class ArticalListPage extends StatefulWidget {
  final bool keepAlive;

//  final RefreshController _refreshController;
//  final OnRefresh _onRefresh;
  final RequestData request;

  ArticalListPage(
    this.request,
    this.keepAlive,
//  this._refreshController, this._onRefresh
  );

  @override
  _ArticalListPageState createState() => _ArticalListPageState();
}

class _ArticalListPageState extends State<ArticalListPage>
    with AutomaticKeepAliveClientMixin {
  int currentPage = 1;
  ProjectData data;
  List dataLists = List();
  GlobalKey<EasyRefreshState> _easyRefreshKey;
  GlobalKey<RefreshHeaderState> _headerKey;

  GlobalKey<RefreshFooterState> _footerKey;

  bool _canLoadMore = true;

  @override
  void initState() {
    _easyRefreshKey = GlobalKey<EasyRefreshState>();
    _headerKey = GlobalKey<RefreshHeaderState>();
    _footerKey = GlobalKey<RefreshFooterState>();
    getData();
    super.initState();
  }

  getData() {
    widget.request(currentPage).then((Map<String, dynamic> response) {
      data = ProjectData.fromMap(response);
      if (data.data.datas.length <= 10) {
        _canLoadMore = false;
      }
      if (this.mounted) {
        setState(() {
          dataLists.addAll(data.data.datas);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget footer = ClassicsFooter(
      key: _footerKey,
      loadText: Translations.of(context).text("pushToLoad"),
      loadReadyText: Translations.of(context).text("releaseToLoad"),
      loadingText: Translations.of(context).text("loading"),
      loadedText: Translations.of(context).text("loaded"),
      noMoreText: Translations.of(context).text("loaded"),
      moreInfo: Translations.of(context).text("updateAt"),
      bgColor: Colors.transparent,
      textColor: Colors.black87,
      moreInfoColor: Colors.black54,
      showMore: true,
    );

    Widget header = ClassicsHeader(
      key: _headerKey,
      refreshText: Translations.of(context).text("pullToRefresh"),
      refreshReadyText: Translations.of(context).text("releaseToRefresh"),
      refreshingText: Translations.of(context).text("refreshing") + "...",
      refreshedText: Translations.of(context).text("refreshed"),
      moreInfo: Translations.of(context).text("updateAt"),
      bgColor: Colors.transparent,
      textColor: Colors.black87,
      moreInfoColor: Colors.black54,
      showMore: true,
    );
    if (data == null || data.data == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(data.data.datas.length<=0){
      return Center(
        child: Text("暂无数据"),
      );
    }

    return EasyRefresh(
      key: _easyRefreshKey,
      onRefresh: _onRefresh,
      loadMore: _canLoadMore
          ? () {
              _loadMore();
            }
          : null,
      autoLoad: false,
      behavior: ScrollOverBehavior(),
      refreshHeader: header,
      refreshFooter: footer,
      child: ListView.builder(
        itemBuilder: (context, int index) {
          return _listItembuilder(context, index);
        },
        itemCount: dataLists.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    data = null;
    dataLists.clear();
    currentPage = 1;
    await getData();
  }

  Future<void> _loadMore() async {
    currentPage++;
    await getData();
  }

  Widget _listItembuilder(context, int index) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WebViewPage(dataLists[index].link, dataLists[index].title,dataLists[index].collect,dataLists[index].id);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Card(
            elevation: 8.0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil.getInstance().setWidth(500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          dataLists[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          dataLists[index].desc,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.access_time,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(dataLists[index].niceDate),
                          Text("@" + dataLists[index].author),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 8.0, top: 3.0),
                        margin: EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          children: <Widget>[
                            _buildTags(index),
                            Text(dataLists[index].superChapterName +
                                "/" +
                                dataLists[index].chapterName),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 120,
                  child: CachedNetworkImage(
                    imageUrl: dataLists[index].envelopePic,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      width: 0,
                      height: 0,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildTags(int index) {
    if (dataLists[index].tags.length <= 0) {
      return Container(
        height: 0,
        width: 0,
        child: Text(''),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
                color: Colors.blue, width: 1.0, style: BorderStyle.solid)),
        child: Text(
          " " + dataLists[index].tags[0].name + " ",
          style: TextStyle(color: Colors.blue),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
