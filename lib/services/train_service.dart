import 'package:dio/dio.dart';
import 'package:erailpass_mobile/common/custom_dio.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/models/app_response.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/models/train.dart';

class TrainService {

  static Future<List<Train>> searchTrains(Station from, Station to, DateTime? date) async {
    Map<String, dynamic> data = {
      'from': from.name,
      'to': to.name,
      'date': date?.toIso8601String(),
    };
    String url = getApiUrl("public/train/search");
    Response<dynamic> response = await customDio.post(url, data: data);
    AppResponse<List<dynamic>> appResponse = AppResponse.fromJson(response);
    if(appResponse.success) {
      return appResponse.data!.map((e) => Train.fromJson(e)).toList();
    } else {
      showToast(appResponse.message ?? "Failed to search trains");
      return [];
    }
  }
}
