import 'package:erailpass_mobile/models/user.dart';

class Station {
  final String? id;
  final String name;
  final int line;
  final User? sm;
  final double position;

  Station({required this.id, required this.name, required this.line, this.sm, required this.position});

  Station.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        name = json['sName'] as String,
        line = json['sLine'] as int,
        sm = json['sm'] is String ? null : User.fromJson(json['sm']),
        position = json['position'] is int ? (json['position'] as int).toDouble() : json['position'] as double;

  Map<String, dynamic> toJson() => {
    'id': id,
    'sName': name,
    'sLine': line,
    'sm': sm?.id,
    'position': position,
  };

  @override
  bool operator ==(Object other) {
    if (other is! Station) return false;
    if (id != other.id) return false;
    if (name != other.name) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result +  name.hashCode;
    return result;
  }
}
