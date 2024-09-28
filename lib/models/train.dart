import 'package:erailpass_mobile/models/station.dart';
import 'package:flutter/material.dart';

class TrainStop {
  final Station station;
  final String time;
  final int day;
  final int hour;
  final int minute;

  TrainStop(this.day, this.hour, this.minute, {required this.station, required this.time});

  TrainStop.fromJson(Map<String, dynamic> json)
      : station = Station.fromJson(json['station']),
        time = json['time'] as String,
        day = json['day'] as int,
        hour = json['hour'] as int,
        minute = json['minute'] as int;

  Map<String, dynamic> toJson() => {
        'station': station.id,
        'time': time,
        'day': day,
        'hour': hour,
        'minute': minute,
      };
}

class Train {
  final String id;
  final String name;
  final int line;
  final String trainNo;
  final Station from;
  final Station to;
  final String status;
  final List<TrainStop> stops;

  Train({
    required this.id,
    required this.name,
    required this.line,
    required this.trainNo,
    required this.from,
    required this.to,
    required this.status,
    required this.stops,
  });

  Train.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        name = json['trName'] as String,
        line = json['trLine'] as int,
        trainNo = (json['trNo'] as int).toString(),
        from = Station.fromJson(json['trFrom']),
        to = Station.fromJson(json['trTo']),
        status = json['trStatus'] as String,
        stops = (json['stops'] as List<dynamic>).map((e) {
          return TrainStop.fromJson(e);
        }).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'trName': name,
        'trLine': line,
        'trNo': int.parse(trainNo),
        'trFrom': from.id,
        'trTo': to.id,
        'trStatus': status,
        'stops': stops.map((e) => e.toJson()),
      };

  @override
  bool operator ==(Object other) {
    if (other is! Train) return false;
    if (id != other.id) return false;
    if (name != other.name) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + name.hashCode;
    return result;
  }
}
