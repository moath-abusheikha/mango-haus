import 'dart:convert';

CheckInOut CheckInOutFromJson(String str) => CheckInOut.fromMap(json.decode(str));

String CheckInOutToJson(CheckInOut data) => json.encode(data.toMap());

class CheckInOut {
  String reservationId, bedNumber;
  bool paid;

  CheckInOut(
    this.paid, {
    required this.reservationId,
    required this.bedNumber,
  });

  factory CheckInOut.fromMap(Map<String, dynamic> map) {
    return CheckInOut(map['paid'],
        reservationId: map['reservationId'], bedNumber: map['bedNumber']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'paid': paid,
      'reservationId': reservationId,
      'bedNumber': bedNumber
    };
    return map;
  }
}
