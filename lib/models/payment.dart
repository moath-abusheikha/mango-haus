import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Payment PaymentFromJson(String str) => Payment.fromMap(json.decode(str));

String PaymentToJson(Payment data) => json.encode(data.toMap());

class Payment {
  String guestName, receivedBy;
  DateTime? checkIn, checkOut;
  List<DateTime> paymentDates;
  double remaining;
  List<double> paymentAmounts;

  Payment(
      {required this.checkIn,
      required this.checkOut,
      required this.receivedBy,
      required this.guestName,
      required this.paymentAmounts,
      required this.paymentDates,
      required this.remaining});

  factory Payment.fromMap(Map<String, dynamic> map) {
    List<double> payments = [];
    List<dynamic> tempDates = [];
    List<DateTime> dates = [];
    tempDates = map['paymentDate'];
    if (map['paymentDate'] != null && tempDates.isNotEmpty) {
      List<dynamic> tempPayments = map['paymentAmount'];
      for (int i = 0; i < tempPayments.length; i++) {
        payments.add(tempPayments[i] as double);
        var t = tempDates[i];
        DateTime dt = t.toDate();
        dates.add(dt);
      }
    }
    Timestamp? cOutTimestamp;
    DateTime? checkInDate, checkOutDate;
    Timestamp cInTimestamp = map['checkIn'] as Timestamp;
    checkInDate = cInTimestamp.toDate();
    if (map['checkOut'] != null) {
      cOutTimestamp = map['checkOut'] as Timestamp;
      checkOutDate = cOutTimestamp.toDate();
    }
    return Payment(
        checkIn: checkInDate,
        checkOut: checkOutDate,
        receivedBy: map['receivedBy'],
        guestName: map['guestName'],
        paymentAmounts: payments,
        paymentDates: dates,
        remaining: map['remaining'].toDouble());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'checkIn': checkIn,
      'checkOut': checkOut,
      'receivedBy': receivedBy,
      'guestName': guestName,
      'paymentDate': paymentDates,
      'paymentAmount': paymentAmounts,
      'remaining': remaining,
    };
    return map;
  }
}
