import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ReservationModel reservationFromJson(String str) => ReservationModel.fromMap(json.decode(str));

String reservationToJson(ReservationModel data) => json.encode(data.toMap());

class ReservationModel {
  String guestName, room, note, bookedFrom, bookingDate, status, reservedBed;
  double roomPrice, commission, totalPrice;
  int guestsCount, nights;
  DateTime checkIn, checkout;
  DateTime? physicalCheckIn, physicalCheckOut;

  ReservationModel(this.note, this.physicalCheckIn, this.physicalCheckOut, this.reservedBed,
      {required this.totalPrice,
      required this.roomPrice,
      required this.guestName,
      required this.checkIn,
      required this.checkout,
      required this.nights,
      required this.room,
      required this.bookedFrom,
      required this.guestsCount,
      required this.bookingDate,
      required this.commission,
      required this.status});

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(map['note'] == null ? '' : map['note'], map['physicalCheckIn'],
        map['physicalCheckOut'], map['reservedBed'],
        guestName: map['guestName'],
        totalPrice: map['totalPrice'],
        checkIn: (map['checkIn'] as Timestamp).toDate(),
        checkout: (map['checkout'] as Timestamp).toDate(),
        nights: map['nights'],
        room: map['room'],
        bookedFrom: map['bookedFrom'],
        guestsCount: map['guestsCount'],
        roomPrice: map['roomPrice'],
        bookingDate: map['bookingDate'],
        commission: map['commission'],
        status: map['status']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'totalPrice': totalPrice,
      'guestName': guestName,
      'checkIn': checkIn,
      'checkout': checkout,
      'nights': nights,
      'room': room,
      'bookedFrom': bookedFrom,
      'guestsCount': guestsCount,
      'roomPrice': roomPrice,
      'reservedBed': reservedBed,
      'note': note,
      'bookingDate': bookingDate,
      'commission': commission,
      'status': status,
      'physicalCheckIn': physicalCheckIn,
      'physicalCheckOut': physicalCheckOut
    };
    return map;
  }
}
