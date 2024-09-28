import 'package:dio/dio.dart';
import 'package:erailpass_mobile/common/custom_dio.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/models/app_response.dart';
import 'package:erailpass_mobile/models/ticket.dart';
import 'package:erailpass_mobile/services/station_service.dart';
import 'package:flutter/cupertino.dart';

class TicketService {

  static Future<Ticket?> createTicket(Ticket ticket) async {
    Map<String, dynamic> data = ticket.toJson();

    String url = getApiUrl("auth/ticket/add");
    Response<dynamic> response = await customDio.post(url, data: data);

    AppResponse<Map<String, dynamic>> appResponse = AppResponse.fromJson(response);
    debugPrint(response.toString());
    if(appResponse.success) {
      return Ticket.fromJson(appResponse.data!);
    } else {
      showToast("Failed to create ticket");
      return null;
    }
  }

  static Future<List<Ticket>> getAll() async {
    String url = getApiUrl("auth/ticket/all");
    Response<dynamic> response = await customDio.get(url);
    AppResponse<List<dynamic>> appResponse = AppResponse.fromJson(response);
    if(appResponse.success) {
      return appResponse.data!.map((e) => Ticket.fromJson(e)).toList();
    } else {
      showToast("Failed to create ticket");
      return [];
    }
  }

  static Future<void> markTicketChecked(String? id) async {
    String url = getApiUrl("checker/ticket/mark-checked");
    Response<dynamic> response = await customDio.post(url, data: {"_id": id});
    AppResponse<void> appResponse = AppResponse.fromJson(response);
    if(!appResponse.success) {
      showToast("Failed to update ticket");
    }
  }

  static Future<void> markTicketAsPaid(String? id) async {
    String url = getApiUrl("sm/ticket/mark-paid");
    Response<dynamic> response = await customDio.post(url, data: {"_id": id});
    AppResponse<void> appResponse = AppResponse.fromJson(response);
    if(!appResponse.success) {
      showToast("Failed to update ticket");
    }
  }
}
