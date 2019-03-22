import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sixteenhome/entity/hot_key.dart';
import 'package:flutter_sixteenhome/entity/search.dart';
import 'package:flutter_sixteenhome/utils/net_utils.dart';
import 'package:flutter_sixteenhome/utils/print_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _textEditController;
  bool isGone = true;
  List hotKeyData = List();
  List searchLists = List();
  String hotkey;
  int HotKeyId;
  int currentPage = 0;
  List searchList = List();
  VoidCallback refrshCallback;
  VoidCallback loadMoreCallBack;

  @override
  void initState() {
    _textEditController = TextEditingController();
    _getHotKey();
    super.initState();
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  void _getHotKey() async {
    String url = "/hotkey/json";
    var responce = await NetUtils.get(url);
    print(responce);
    if (responce["errorCode"] == 0) {
      HotKey hotKey = HotKey.fromMap(responce);
      hotKeyData.addAll(hotKey.data);
      if (hotKeyData.length > 0) {
        setState(() {
          DataListBean key =
              hotKeyData[Random().nextInt(hotKeyData.length - 1)];
          HotKeyId = key.id;
          _textEditController.text = key.name;
          isGone = false;
        });
      }
    }
  }

  void _goSearchResult() async {
    searchList.clear();
    Search search ;
        String url = "https://www.wanandroid.com/article/query/$currentPage/json";

    Map<String, dynamic> map = Map();
    map["k"] =  _textEditController.text;

    var response = await NetUtils.postFormData(url, FormData.from(map));
    PrintUtils.printValue(response.toString());
    if (response["errorCode"] == 0) {
      setState(() {
        search= Search.fromJson(response);
        searchList.addAll(search.data.datas);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: ScreenUtil.getInstance().setHeight(60),
            width: ScreenUtil.getInstance().setWidth(800),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1.0),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil.getInstance().setHeight(60),
                  width: ScreenUtil.getInstance().setWidth(480),
                  child: TextField(
                    onChanged: (value) {
                      if (value.length <= 0) {
                        setState(() {
                          isGone = true;
                        });
                      } else {
                        isGone = false;
                      }
                    },
                    onSubmitted: (value) {
                      setState(() {
                        hotkey = value;
                        _goSearchResult();
                      });
                    },
                    controller: _textEditController,
                    textInputAction: TextInputAction.search,
                    onTap: () {
                      setState(() {
                        if (_textEditController.text.length <= 0) {
                          isGone = true;
                        } else {
                          isGone = false;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 16.0, top: 10.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Offstage(
                  offstage: isGone,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _textEditController.text = "";
                        isGone = true;
                      });
                    },
                  ),
                )
              ],
            )),
      ),
      body: BodyView(hotKeyData, searchList,(value){
        _textEditController.text=value;
        _goSearchResult();
      }),
    );
  }
}

class BodyView extends StatelessWidget {
  final List keywordList;
  final List searchList;
  final Function callBack;

  BodyView(this.keywordList, this.searchList, this.callBack,);

  @override
  Widget build(BuildContext context) {
    if (keywordList == null || keywordList.length <= 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return CustomScrollView(
        slivers: <Widget>[
          KeyWorldWidget(keywordList,callBack),
          SearchResult(searchList,),
        ],
      );
    }
  }
}

class SearchResult extends StatefulWidget {
  final List list;


  SearchResult(this.list);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return listData();
    }


  Widget listData() {

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(10, 8.0),
                      color: Colors.grey,
                      blurRadius: 20.0,
                      spreadRadius: -9.0)
                ]),
            width: ScreenUtil.getInstance().setWidth(600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.list[index].title.replaceAll("<em class='highlight'>","").replaceAll("</em>", "").replaceAll("&amp;","").trim(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0, top: 3.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(widget.list[index].niceDate),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text("@${widget.list[index].author}")
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0, top: 3.0),
                  margin: EdgeInsets.only(bottom: 3.0),
                  child: Row(
                    children: <Widget>[
                      _buildTags(index),
                      Text(widget.list[index].superChapterName +
                          "/" +
                          widget.list[index].chapterName),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }, childCount: widget.list.length),
    );
  }

  Widget _buildTags(int index) {
    if (widget.list[index].tags.length <= 0) {
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
          " " + widget.list[index].tags[0].name + " ",
          style: TextStyle(color: Colors.blue),
        ),
      );
    }
  }
}

class KeyWorldWidget extends StatelessWidget {
  final List keywordList;
  final Function callBack;

  KeyWorldWidget(this.keywordList,this.callBack);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, int index) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: ActionChip(
            onPressed: () {
              callBack(keywordList[index].name);
            },
            label: Text(
              keywordList[index].name,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                keywordList[index].name.substring(0, 1),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      }, childCount: keywordList.length),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.8),
    );
  }
}
