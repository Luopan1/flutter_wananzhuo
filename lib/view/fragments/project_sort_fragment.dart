import 'package:flutter/material.dart';
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
        Stack(
          children: <Widget>[
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
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
            Positioned(
              top: ScreenUtil.getInstance().setHeight(170),
              left: ScreenUtil.getInstance().setHeight(160),
              child: Text("昵称时什么什么"),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                width: ScreenUtil.getInstance().setWidth(800),
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
        Container(
          width: ScreenUtil.getInstance().setWidth(700),
          height: ScreenUtil.getInstance().setWidth(220),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "我的订单",
                  style: TextStyle(color: Colors.black),
                ),
                trailing:  Text(
                  "查看更多订单 >",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.1),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.print),
                        Text("代付款")
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.print),
                        Text("代付款")
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.print),
                        Text("代付款")
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.print),
                        Text("代付款")
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
      ],
    ));
  }
}
