import 'package:erailpass_mobile/common/date_util.dart';
import 'package:erailpass_mobile/models/station.dart';

Map<int, String> tClasses = {
  1: "1st Class",
  2: "2nd Class",
  3: "3rd Class",
};

class Ticket {
  final String? id;
  final int price;
  final Station startStation;
  final Station endStation;
  final DateTime date;
  final bool isPaid;
  final int tClass;
  final int noOfTickets;
  final String? qrCode;

  Ticket(this.id, this.price, this.startStation, this.endStation, this.date, this.isPaid, this.tClass, this.noOfTickets, this.qrCode);

  Ticket.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        price = json['price'] as int,
        startStation = Station.fromJson(json['startStation']),
        endStation = Station.fromJson(json['endStation']),
        date = dateFromString(json['date'] as String),
        isPaid = json['isPaid'] as bool,
        tClass = json['tClass'] as int,
        noOfTickets = json['noOfTickets'] as int,
        qrCode = json['qrCode'] as String?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'price': price,
        'startStation': startStation.id,
        'endStation': endStation.id,
        'date': date.toIso8601String(),
        'isPaid': isPaid,
        'noOfTickets': noOfTickets,
        'tClass': tClass,
      };

  String getTClass() {
    return tClassFromNumber(tClass);
  }

  @override
  bool operator ==(Object other) {
    if (other is! Ticket) return false;
    if (id != other.id) return false;
    if (startStation != other.startStation) return false;
    if (endStation != other.endStation) return false;
    if (date != other.date) return false;
    if (isPaid != other.isPaid) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + startStation.hashCode;
    result = 37 * result + endStation.hashCode;
    result = 37 * result + date.hashCode;
    result = 37 * result + isPaid.hashCode;
    return result;
  }

  static String tClassFromNumber(tClass) {
    return tClasses[tClass] ?? "none";
  }
}
