import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_sixteenhome/utils/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

Dio dio = new Dio();
String path;
var cookie;

class NetUtils {
  static getCookieName() async {
    SpUtil sp = await SpUtil.getInstance();
    String cookie = sp.getString("name");
  }

  static getCookiePassword() async {
    SpUtil sp = await SpUtil.getInstance();
    String cookie = sp.getString("passworld");
  }

  static Future<String> getCookiePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    path = appDocDir.path + "/";
    return path;
  }

  static setHeaders() {
    dio.options.baseUrl = "https://www.wanandroid.com/";
    Future.wait([getCookiePath()]).then((list) {
      dio.interceptors
        ..add(CookieManager(PersistCookieJar(dir: list[0])))
        ..add(LogInterceptor(responseBody: true));
      return Options(responseType: ResponseType.json);
    });
  }

  static Future get(String url, {Map<String, dynamic> params}) async {
    Response<Map<String, dynamic>> response = await dio.get(
      url,
      queryParameters: params,
      options: setHeaders(),
    );
    return response.data;
  }

  static Future getData(String url, Function callBack,
      {Map<String, dynamic> params}) async {
    dio
        .get(url, queryParameters: params, options: setHeaders())
        .then((response) {
      callBack(response.data);
    });
  }

  static Future post(String url, Map<String, dynamic> params) async {
    Response<Map<String, dynamic>> response = await dio.post(
      url,
      data: params,
      options: setHeaders(),
    );
    return response.data;
  }

  static Future postFormData(String url, FormData data) async {
    Response<Map<String, dynamic>> response =
        await dio.post(url, data: data, options: setHeaders());
    return response.data;
  }

  static Future postData(
      String url, Map<String, dynamic> data, Function callBack) async {
    data = FormData.from(data);
    dio.post(url, data: data, options: setHeaders()).then((response) {
      callBack(response.data);
    });
  }

  static Future<Response> login(String url, FormData data) async {
    Response<Map<String, dynamic>> response = await dio.post(
      url,
      data: data,
    );
    return response;
  }
}
