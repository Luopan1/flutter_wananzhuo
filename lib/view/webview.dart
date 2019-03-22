import 'package:flutter/material.dart';
import 'package:flutter_sixteenhome/utils/net_utils.dart';
import 'package:flutter_sixteenhome/utils/show_snack_bar.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  final String url, title;
  bool isCollect;
  final int id;

  WebViewPage(this.url, this.title, this.isCollect, this.id);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: widget.isCollect ? Colors.red : Colors.white,
              ),
              onPressed: () {
                if (widget.isCollect) {
                  //取消收藏
                  String url = "lg/uncollect_originId/${widget.id}/json";
                  NetUtils.postData(url, Map(), (Map<String, dynamic> response) {

                    if (response["errorCode"] == 0) {
                      ShowSnackBar.show(context, widget.title, "取消收藏成功!", 3);
                      setState(() {
                        widget.isCollect = false;
                      });
                    } else if (response["errorCode"] == -1001) {
                      Navigator.of(context).pushNamed("/login");
                    } else {
                      ShowSnackBar.show(
                          context, widget.title, response["errorMsg"], 3);
                    }
                  });
                } else {
                  String url = "lg/collect/${widget.id}/json";
                  NetUtils.postData(url, Map(), (Map<String, dynamic> response) {

                    if (response["errorCode"] == 0) {
                      ShowSnackBar.show(context, widget.title, "收藏成功!", 3);
                      setState(() {
                        widget.isCollect = true;
                      });
                    } else if (response["errorCode"] == -1001) {
                      Navigator.of(context).pushNamed("/login");
                    } else {
                      ShowSnackBar.show(
                          context, widget.title, response["errorMsg"], 3);
                    }
                  });
                }
              },
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
        ],
      ),
      body: WebviewScaffold(
        url: widget.url,
        withZoom: false,
        withLocalStorage: true,
        withJavascript: true,
      ),
    );
  }






}
