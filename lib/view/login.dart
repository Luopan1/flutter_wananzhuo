import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sixteenhome/main.dart';
import 'package:flutter_sixteenhome/utils/DateUtil.dart';
import 'package:flutter_sixteenhome/utils/Sp.dart';
import 'package:flutter_sixteenhome/utils/net_utils.dart';
import 'package:flutter_sixteenhome/utils/print_utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginPageView extends StatefulWidget {
  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}

ProgressDialog pr;

class _LoginPageViewState extends State<LoginPageView> {
  int _currentIndex = 0;
  bool passworldAgainVisable = true;
  var dio = new Dio();
  bool _isAutovalidate = false;
  String userName, passworld, passworldAgain;

  final _loginFormStateKay = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _validatorUserName(value) {
    if (value.isEmpty) {
      return "用户名不能为空";
    } else if (value.length < 6) {
      return "用户名长度必须大于6";
    }
    return null;
  }

  String _validatorPasworld(value) {
    if (value == null) {
      return "密码为空";
    } else if (value.length < 6) {
      return "密码长度必须大于6";
    }
    if (value.isEmpty) {
      return "密码不能为空";
    }
    return null;
  }

  String _validatorPassworldAgain(value) {
    debugPrint("value_________$value:" + "passworld__________$passworld");
    if (_currentIndex == 0) {
      return null;
    }
    if (value.isEmpty) {
      return "密码不能为空";
    } else if (value != passworld) {
      return "两次密码不一致";
    }
    return null;
  }

  void _submit() {
    pr = new ProgressDialog(context);
    pr.setMessage('Please wait...');
    if (_currentIndex == 0) {
      if (_loginFormStateKay.currentState.validate()) {
        _loginFormStateKay.currentState.save();
        //todo 去登陆
        _gotoLogin();
        if (!pr.isShowing()) {
          pr.show();
        }
      } else {
        setState(() {
          _isAutovalidate = true;
        });
      }
    } else {
      _loginFormStateKay.currentState.save();
      if (_loginFormStateKay.currentState.validate()) {
        // todo   去注册
        _toRegiest();
        if (!pr.isShowing()) {
          pr.show();
        }
      } else {
        setState(() {
          _isAutovalidate = true;
        });
      }
    }
  }

  void _gotoLogin() async {
    String url = "user/login";
    FormData formData = FormData.from({
      'username': userName.trim(),
      'password': passworld.trim(),
    });
    var response = await NetUtils.login(url, formData);
    if (pr.isShowing()) {
      pr.hide();
    }
    if (response.data["errorCode"] == 0) {
      _saveCookie(response);

      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        title: userName,
        message: "登陆成功 !",
        duration: Duration(seconds: 2),
      )..show(context);

      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return MainAppPage();
          },
        ), (route) => route == null);
      });
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        message: response.data["errorMsg"].toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  void _saveCookie(response) {
    List<Cookie> cookies = [
      new Cookie("name", userName.trim()),
      new Cookie("passworld", passworld.trim())
    ];
    CookieJar cj = new CookieJar();
    cj.saveFromResponse(Uri.parse("/login"), cookies);

    Sp.putUserName(userName);
    Sp.putPassword(passworld);
    String cookie = "";
    DateTime expires;
    PrintUtils.printValue(response.headers);
    response.headers.forEach((String name, List<String> values) {
      PrintUtils.printValue(values);
      if (name == "set-cookie") {
        cookie = json
            .encode(values)
            .replaceAll("\[\"", "")
            .replaceAll("\"\]", "")
            .replaceAll("\",\"", "; ");
        try {
          expires = DateUtil.formatExpiresTime(cookie);
        } catch (e) {
          expires = DateTime.now();
        }
      }
    });
    Sp.putCookie(cookie);
    Sp.putCookieExpires(expires.toIso8601String());
  }

  void _toRegiest() async {
    String url = "user/register";

    FormData formData = FormData.from({
      'username': userName.trim(),
      'password': passworld.trim(),
      'repassword': passworldAgain.trim(),
    });
    debugPrint(formData.toString());
    var response = await NetUtils.postFormData(url, formData);
    debugPrint(response.toString());
    if (pr.isShowing()) {
      pr.hide();
    }
    if (response["errorCode"] == 0) {
      List<Cookie> cookies = [
        new Cookie("name", userName.trim()),
        new Cookie("passworld", passworld.trim())
      ];
      CookieJar cj = new CookieJar();
      cj.saveFromResponse(Uri.parse("/login"), cookies);
      List<Cookie> results = cj.loadForRequest(Uri.parse("/login"));
      for (var item in results) {
        print("Cookie:$item");
      }
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        title: userName,
        message: "注册成功 请重新登陆!",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        message: response["errorMsg"].toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }

    print(response);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "image/splash.png",
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.blue.withOpacity(0.5),
              BlendMode.hardLight,
            ),
          ),
        ),
        child: Form(
          key: _loginFormStateKay,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "登陆",
                        style: TextStyle(
                            color: _currentIndex == 0
                                ? Colors.white
                                : Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                          passworldAgainVisable = true;
                        });
                      },
                      color: _currentIndex == 0 ? Colors.blue : Colors.grey,
                    ),
                    SizedBox(
                      width: ScreenUtil.getInstance().setWidth(18),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: _currentIndex == 1 ? Colors.blue : Colors.grey,
                      child: Text(
                        "注册",
                        style: TextStyle(
                            color: _currentIndex == 1
                                ? Colors.white
                                : Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                          passworldAgainVisable = false;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      onSaved: (value) {
                        userName = value.trim();
                        print("*" * 100);
                        print("userName:$userName");
                        print("*" * 100);
                      },
                      validator: _validatorUserName,
                      autovalidate: _isAutovalidate,
                      decoration: InputDecoration(
                          icon: Text(
                            "用  户  名",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          labelText: "用户名",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(32),
                    ),
                    TextFormField(
                      onSaved: (value) {
                        passworld = value.trim();
                        print("*" * 100);
                        print("passworld:$passworld");
                        print("*" * 100);
                      },
                      validator: _validatorPasworld,
                      autovalidate: _isAutovalidate,
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Text("密        码",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                          labelText: "密码",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(32),
                    ),
                    Offstage(
                      offstage: passworldAgainVisable,
                      child: Container(
                        child: TextFormField(
                          onSaved: (value) {
                            passworldAgain = value.trim();
                            print("passworldAgain$passworldAgain");
                          },
                          obscureText: true,
                          validator: _validatorPassworldAgain,
                          autovalidate: _isAutovalidate,
                          decoration: InputDecoration(
                              icon: Text("确认密码",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                              labelText: "确认密码",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(32),
                    ),
                    Container(
                      height: ScreenUtil.getInstance().setHeight(80),
                      width: ScreenUtil.getInstance().setHeight(500),
                      child: RaisedButton(
                        child: Text(
                          "登陆",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
