import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Services {
  DateTime dateTime;
  String note, costumerName;
  double amount;

  Services(
      {
        required this.dateTime,
        required this.note,
        required this.costumerName,
        required this.amount
      });

  factory Services.fromMap(Map<String, dynamic> map) {
    return Services(
        dateTime: (map['dateTime'] as Timestamp).toDate(),
        note: map['note'],
        costumerName: map['costumerName'],
        amount: map['amount']
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'dateTime': dateTime,
      'note': note,
      'costumerName': costumerName,
      'amount': amount,
    };
    return map;
  }
}
