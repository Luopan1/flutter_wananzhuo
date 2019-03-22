import 'dart:async';

import 'package:flutter_sixteenhome/utils/DateUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sp {
  static Map<String, String> _headerMap;
  static String cookie;
  static DateTime cookieExpiresTime;
  static put(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static getS(String key, Function callback) async {
    SharedPreferences.getInstance().then((prefs) {
      callback(prefs.getString(key));
    });
  }

  static putUserName(String value) {
    put("username", value);
  }

  static putPassword(String value) {
    put("password", value);
  }

  static putCookie(String value) {
    put("cookie", value);
  }

  static putCookieExpires(String value) {
    put("expires", value);
  }

  static getUserName(Function callback) {
    getS("username", callback);
  }

  static getPassword(Function callback) {
    getS("password", callback);
  }

  static getCookie(Function callback) {
    getS("cookie", callback);
  }

  static getCookieExpires(Function callback) {
    getS("expires", callback);
  }

  static Map<String, String> getHeader() {
    Sp.getCookie((str) {
        cookie = str;
      _headerMap = null;
    });
    Sp.getCookieExpires((str) {
      if (null != str && str.length > 0) {
        cookieExpiresTime = DateTime.parse(str);
        //提前3天请求新的cookie
        if (cookieExpiresTime.isAfter(DateUtil.getDaysAgo(3))) {
          Timer(Duration(milliseconds: 100), () {

          });
        }
      }
    });
    if (null == _headerMap) {
      _headerMap = Map();
      _headerMap["Cookie"] = cookie;
    }
    return _headerMap;
  }
}
