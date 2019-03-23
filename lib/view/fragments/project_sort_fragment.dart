import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String url =
    "http://read.html5.qq.com/image?imgflag=7&imageUrl=http://i2.wp.com/acby3.heibaimanhua.com/wp-content/uploads/2016/01/21/20160121_56a0898814744.png&src=share";

class ProjectSortFragment extends StatefulWidget {
  @override
  _ProjectSortFragmentState createState() => _ProjectSortFragmentState();
}

class _ProjectSortFragmentState extends State<ProjectSortFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ///头部信息
          Stack(
            children: <Widget>[
              ///头部黄色背景
              Container(
                alignment: Alignment(0.9, -0.5),
                color: Colors.yellow,
                height: ScreenUtil.getInstance().setHeight(300),
                child: IconButton(
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () {}),
              ),

              ///头部白色背景 以及照相机按钮
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setHeight(150),
                    left: ScreenUtil.getInstance().setHeight(16),
                    right: ScreenUtil.getInstance().setHeight(16)),
                height: ScreenUtil.getInstance().setHeight(200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(0.8, -1.0),
                      child: IconButton(
                        icon: Icon(Icons.linked_camera),
                        onPressed: () {
                          scan();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// 用户头像
              Positioned(
                top: ScreenUtil.getInstance().setHeight(100),
                left: ScreenUtil.getInstance().setHeight(52),
                child: Container(
                  width: ScreenUtil.getInstance().setHeight(100),
                  height: ScreenUtil.getInstance().setHeight(100),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.0)),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(url),
                  ),
                ),
              ),

              ///用户昵称
              Positioned(
                top: ScreenUtil.getInstance().setHeight(170),
                left: ScreenUtil.getInstance().setHeight(160),
                child: Text(barcode),
              ),

              ///用户账号信息
              Positioned(
                bottom: 5,
                left: 15,
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(700),
                  height: ScreenUtil.getInstance().setHeight(80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("积分", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("抵用券", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "—",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "我的余额",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///用户账户信息下的黄色渐变背景
              Positioned(
                left: 10,
                bottom: 0,
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(710),
                  height: ScreenUtil.getInstance().setWidth(20),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          16.0,
                        ),
                        bottomRight: Radius.circular(16.0)),
                    gradient: LinearGradient(colors: [
                      Colors.yellow[700],
                      Colors.yellow,
                    ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),

          /// 我的订单
          Container(
            width: ScreenUtil.getInstance().setWidth(700),
            height: ScreenUtil.getInstance().setWidth(220),
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "我的订单",
                        style: TextStyle(color: Colors.black),
                      ),
                      Container(
                        width: ScreenUtil.getInstance().setWidth(600),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "查看更多订单",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ///分割线  可用Divider()实现
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
                SizedBox(
                  height: 20,
                ),

                ///订单分类
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          ImageIcon(
                            AssetImage('assets/img/order_img.png'),
                            size: 28.0,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text("代付款")
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          ImageIcon(
                            AssetImage(
                              'assets/img/order_img2.png',
                            ),
                            size: 28.0,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text("带配送")
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          ImageIcon(
                            AssetImage('assets/img/order_img3.png'),
                            size: 28.0,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text("待收货")
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          ImageIcon(
                            AssetImage('assets/img/order_img4.png'),
                            size: 28.0,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text("已完成")
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          SizedBox(
            height: 20,
          ),

          ///常用工具
          Container(
            width: ScreenUtil.getInstance().setWidth(700),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil.getInstance().setWidth(100),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "常用工具",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      childAspectRatio: 2.0,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0),
                  itemBuilder: _girdItemBuilder,
                  itemCount: toolData.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List toolData = [
    ToolData('assets/img/tool_img.png', Text("我的会员卡")),
    ToolData('assets/img/tool_img2.png', Text("我的积分")),
    ToolData('assets/img/tool_img3.png', Text("我的抵用券")),
    ToolData('assets/img/tool_img4.png', Text("联系客服")),
    ToolData('assets/img/tool_img5.png', Text("收货地址")),
  ];

  Widget _girdItemBuilder(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        Image.asset(
          toolData[index].img,
          scale: 2.0,
        ),
        toolData[index].text,
      ],
    );
  }

  String barcode = "昵称是什么什么";

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = '没有取得权限';
        });
      } else {
        setState(() => this.barcode = '发生了错误: $e');
      }
    } on FormatException {
      setState(() => this.barcode ="空  您按下了返回键");
    } catch (e) {
      setState(() => this.barcode = '发生了错误 $e');
    }
  }
}

class ToolData {
  String img;
  Widget text;

  ToolData(this.img, this.text);
}
