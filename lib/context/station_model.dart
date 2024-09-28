import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/services/station_service.dart';
import 'package:flutter/material.dart';

class StationModel extends ChangeNotifier {
  List<Station> _stations = [];

  List<Station> getAll() {
    if (_stations.isNotEmpty) {
      return _stations;
    }

    _getStationsFromApi().then((stations) {
      _stations = stations;
      notifyListeners();
    });
    return [];
  }

  static Future<List<Station>> _getStationsFromApi() async {
    return await StationService.getAll();
  }

}
