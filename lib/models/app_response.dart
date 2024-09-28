import 'package:dio/dio.dart';
import 'package:erailpass_mobile/models/user.dart';

class AppResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  AppResponse({required this.success, this.data, this.message});

  AppResponse.fromJson(Response<dynamic> json)
      : success = json.data['success'] as bool,
        data = json.data['data'] as T?,
        message = json.data['message'] as String?;

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data,
    'message': message,
  };
}
