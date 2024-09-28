import 'package:dio/dio.dart';
import 'package:erailpass_mobile/common/custom_dio.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/models/app_response.dart';
import 'package:erailpass_mobile/models/station.dart';

class StationService {

  static Future<List<Station>> getAll() async {
    String url = getApiUrl("public/station/all");
    Response<dynamic> response = await customDio.get(url);
    AppResponse<List<dynamic>> appResponse = AppResponse.fromJson(response);
    if(appResponse.success) {
      return appResponse.data!.map((e) => Station.fromJson(e)).toList();
    } else {
      showToast("Failed to create station");
      return [];
    }
  }
}
