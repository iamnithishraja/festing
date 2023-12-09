import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fests/utils/debouncer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';

class customHttp {
  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(days: 1),
      receiveTimeout: Duration(days: 1),
      sendTimeout: Duration(days: 1),
      responseType: ResponseType.plain,
      followRedirects: false,
      validateStatus: (status) {
        return true;
      },
    ),
  );

  Future<void> prepareJar() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(appDocPath + "/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
  }

  Future<Map> get(String url, String contentType) async {
    await prepareJar();
    final response = await dio.get(
      url,
      options: Options(contentType: contentType),
    );
    return json.decode(response.data) as Map;
  }

  Future<Map> makeSerchQuery(String url, String contentType) async {
    final response = await dio.get(
      url,
      options: Options(contentType: contentType),
    );
    return json.decode(response.data) as Map;
  }

  Future<Map> postBody(String url, String contentType, Map body) async {
    final response = await dio.post(
      url,
      options: Options(contentType: contentType),
      data: body,
    );
    return json.decode(response.data) as Map;
  }

  Future<Map?> postForm(String url, String contentType, FormData body) async {
    try {
      final response = await dio.post(
        url,
        options: Options(contentType: contentType),
        data: body,
        onSendProgress: (count, total) {
          print("$count / $total");
        },
      );
      return json.decode(response.data) as Map;
    } catch (e) {
      print(e);
    }
  }

  Future<Map?> putForm(String url, String contentType, FormData body) async {
    try {
      final response = await dio.put(
        url,
        options: Options(contentType: contentType),
        data: body,
        onSendProgress: (count, total) {
          print("$count / $total");
        },
      );
      return json.decode(response.data) as Map;
    } catch (e) {
      print(e);
    }
  }

  Future<Map?> delete(
      String url, String contentType, Map<String, dynamic> body) async {
    try {
      final response = await dio.delete(
        url,
        options: Options(contentType: contentType),
        data: json.encode(body),
      );
      return json.decode(response.data) as Map;
    } catch (e) {
      print(e);
    }
  }

  Future<Map> postParams(
      String url, String contentType, Map<String, dynamic> params) async {
    final response = await dio.post(url,
        options: Options(contentType: contentType), queryParameters: params);
    return json.decode(response.data) as Map;
  }
}
