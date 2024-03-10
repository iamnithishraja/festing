import 'dart:convert';
import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:fests/globals/constants.dart';

CustomHttp getInstanceDio() => CustomHttpWeb();

class CustomHttpWeb implements CustomHttp {
  final dio = DioForBrowser(BaseOptions(
    connectTimeout: Duration(days: 1),
    receiveTimeout: Duration(days: 1),
    headers: {
      "Accept": "application/json",
    },
  ));

  @override
  Future<void> prepareJar() async {
    var adapter = BrowserHttpClientAdapter();
    adapter.withCredentials = true;
    dio.httpClientAdapter = adapter;
  }

  @override
  Future<Map> autoLoginRequest(String url, String contentType) async {
    await prepareJar();
    final response = await dio.get(
      url,
      options: Options(contentType: contentType),
    );
    return json.decode(json.encode(response.data)) as Map;
  }

  @override
  Future<Map> get(String url, String contentType) async {
    final response = await dio.get(
      url,
      options: Options(contentType: contentType),
    );
    return json.decode(json.encode(response.data)) as Map;
  }

  @override
  Future<Map> makeSerchQuery(String url, String contentType) async {
    final response = await dio.get(
      url,
      options: Options(contentType: contentType),
    );
    return json.decode(json.encode(response.data)) as Map;
  }

  @override
  Future<Map> postBody(String url, String contentType, Map body) async {
    final response = await dio.post(
      url,
      options: Options(contentType: contentType),
      data: body,
    );
    return json.decode(json.encode(response.data)) as Map;
  }

  @override
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
      return json.decode(json.encode(response.data)) as Map;
    } catch (e) {
      print(e);
    }
  }

  @override
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
      return json.decode(json.encode(response.data)) as Map;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<Map?> delete(
      String url, String contentType, Map<String, dynamic> body) async {
    try {
      final response = await dio.delete(
        url,
        options: Options(contentType: contentType),
        data: json.encode(body),
      );
      return json.decode(json.encode(response.data)) as Map;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<Map> postParams(
      String url, String contentType, Map<String, dynamic> params) async {
    final response = await dio.post(url,
        options: Options(contentType: contentType), queryParameters: params);
    return json.decode(json.encode(response.data)) as Map;
  }
}
