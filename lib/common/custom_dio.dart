import 'package:dio/dio.dart';
import 'package:erailpass_mobile/env.dart';
import 'package:erailpass_mobile/services/token_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;

String getApiUrl(String pathPart) {
  String fullPath = p.join(env['api_url']!, pathPart);
  debugPrint(fullPath);
  return fullPath;
}

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    String? token = TokenHolder().getToken();
    if (token != null) {
      options.headers.addAll({
        "Authorization": "Bearer $token",
      });
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    debugPrint('RESPONSE-DATA:${response.data}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    debugPrint(err.response.toString());
    super.onError(err, handler);
  }
}

Dio customDio = Dio()..interceptors.addAll([CustomInterceptor(), LogInterceptor()]);

