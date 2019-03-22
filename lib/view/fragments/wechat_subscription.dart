import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sixteenhome/entity/wechat_data.dart';
import 'package:flutter_sixteenhome/utils/WeChatData.dart';
import 'package:flutter_sixteenhome/utils/log_utils.dart';
import 'package:flutter_sixteenhome/utils/net_utils.dart';
import 'package:flutter_sixteenhome/utils/translations.dart';
import 'package:flutter_sixteenhome/view/webview.dart';

class WeChatSubscription extends StatefulWidget {
  @override
  _WeChatSubscriptionState createState() => _WeChatSubscriptionState();
}

class _WeChatSubscriptionState extends State<WeChatSubscription>
    with AutomaticKeepAliveClientMixin {
  Color textColor = Colors.white;
  Color nameContainerColor = Colors.blue;
  int currentIndex = 0;
  List weChatList = List();
  List weChatDataLists = List();
  WechatData wechatData;
  int currentPage = 1;
  GlobalKey<EasyRefreshState> _easyRefreshKey;
  GlobalKey<RefreshHeaderState> _headerKey;

  GlobalKey<RefreshFooterState> _footerKey;
  bool canLoadMore = true;

  int currentWebChatId = 0;

  @override
  void initState() {
    _easyRefreshKey = GlobalKey<EasyRefreshState>();
    _headerKey = GlobalKey<RefreshHeaderState>();
    _footerKey = GlobalKey<RefreshFooterState>();
    _getWeChatList();
    super.initState();
  }

  _getWeChatList() {
    String url = "wxarticle/chapters/json";
    NetUtils.getData(url, (Map<String, dynamic> response) {
      WeChatData weChatData = WeChatData.fromMap(response);
      currentWebChatId = weChatData.data[0].id;
      weChatList.addAll(weChatData.data);
      _getWeChatData(currentWebChatId, false);

      setState(() {});
    });
  }

  /// @params needClear 是否需要清除集合数据 防止快速切换菜单时，返回数据叠加
  _getWeChatData(int id, bool needClear) {
    String url = "wxarticle/list/$id/$currentPage/json";
    LogUtils.i("_getWeChatDataId+url", url);
    NetUtils.getData(url, (Map<String, dynamic> response) {
      LogUtils.i("_getWeChatData", response.toString());
      if (response["errorCode"] == 0) {
        wechatData = WechatData.fromMap(response);
        if (needClear) {
          weChatDataLists.clear();
        }
        weChatDataLists.addAll(wechatData.data.datas);
        if (this.mounted) {
          setState(() {
            if (wechatData.data.datas.length <= 10) {
              canLoadMore = false;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("公众号"),
        centerTitle: true,
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: double.infinity,
                child: ListView.builder(
                  itemBuilder: _weChatNameBuilder,
                  itemCount: weChatList.length * 2,
                ),
              ),
              flex: 1,
            ),
            Container(
              width: 1,
              height: double.infinity,
              color: Colors.grey,
            ),
            Expanded(
              child: _weChatDataBuilder(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _weChatNameBuilder(BuildContext context, int index) {
    return Container(
      color: currentIndex == index ? nameContainerColor : Colors.white,
      child: _nameBuidler(index),
    );
  }

  Widget _nameBuidler(int index) {
    if (index.isOdd) {
      return Divider(
        height: 1.0,
      );
    }
    int i = index ~/ 2;
    return Center(
        child: InkWell(
      onTap: () {
        weChatDataLists.clear();
        setState(() {
          if (currentIndex == index) {
            nameContainerColor = Colors.blue;
            textColor = Colors.white;
          }
        });
        currentIndex = index;
        currentWebChatId = weChatList[i].id;
        _getWeChatData(currentWebChatId, true);
        currentPage = 1;
      },
      child: Container(
        alignment: Alignment.center,
        height: ScreenUtil.getInstance().setHeight(160),
        child: Text(
          weChatList[i].name,
          style: TextStyle(
              color: currentIndex == index ? textColor : Colors.black,
              fontSize: 22.0),
        ),
      ),
    ));
  }

  Widget _weChatDataBuilder() {
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
    if (wechatData == null ||
        wechatData.data == null ||
        weChatDataLists.length <= 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (wechatData.data.datas.length <= 0) {
      return Center(
        child: Text("暂无数据"),
      );
    }
    return EasyRefresh(
      key: _easyRefreshKey,
      onRefresh: _onRefresh,
      loadMore: canLoadMore
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
          return weChatData(context, index);
        },
        itemCount: weChatDataLists.length * 2,
      ),
    );
  }

  Widget weChatData(BuildContext context, int index) {
    if (index.isOdd) {
      return Divider(
        height: 1.0,
      );
    }
    int i = index ~/ 2;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WebViewPage(weChatDataLists[i].link, weChatDataLists[i].title,weChatDataLists[i].collect,weChatDataLists[i].id);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                weChatDataLists[i].title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:4.0),
              alignment: Alignment.centerLeft,
              child: Text("作者:${weChatDataLists[i].chapterName}"),
            ),
            Container(
              margin: EdgeInsets.only(top:8.0),
              child: Row(
                children: <Widget>[
                  _buildTags(i),
                  SizedBox(
                    width: 16.0,
                  ),
                  Text("时间:${weChatDataLists[i].niceDate}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(int index) {
    if (weChatDataLists[index].tags.length <= 0) {
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
          " " + weChatDataLists[index].tags[0].name + " ",
          style: TextStyle(color: Colors.blue),
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    currentPage = 1;
    await _getWeChatData(currentWebChatId, true);
  }

  Future<void> _loadMore() async {
    currentPage++;
    await _getWeChatData(currentWebChatId, false);
  }

  @override
  bool get wantKeepAlive => true;
}
