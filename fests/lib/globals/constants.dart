import 'package:dio/dio.dart';
import 'package:fests/stub/stub.dart'
    if (dart.library.io) 'package:fests/utils/customHttpRequestMobile.dart'
    if (dart.library.js) 'package:fests/utils/customHttpWeb.dart';

const baseUrl = "https://festing.vercel.app";

abstract class CustomHttp {
  Future<void> prepareJar();
  Future<Map> autoLoginRequest(String url, String contentType);
  Future<Map> get(String url, String contentType);
  Future<Map> makeSerchQuery(String url, String contentType);
  Future<Map> postBody(String url, String contentType, Map body);
  Future<Map?> postForm(String url, String contentType, FormData body);
  Future<Map?> putForm(String url, String contentType, FormData body);
  Future<Map?> delete(
      String url, String contentType, Map<String, dynamic> body);
  Future<Map> postParams(
      String url, String contentType, Map<String, dynamic> params);
}

var http = getInstanceDio();
