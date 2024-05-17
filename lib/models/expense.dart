import 'package:cloud_firestore/cloud_firestore.dart';

class Expenses {
  DateTime date;
  String description, type;
  double amount;

  Expenses(
      {required this.date, required this.description, required this.type, required this.amount});

  factory Expenses.fromMap(Map<String, dynamic> map) {
    return Expenses(
        date: (map['date'] as Timestamp).toDate(),
        description: map['description'],
        type: map['type'],
        amount: map['amount']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'date': date,
      'description': description,
      'type': type,
      'amount': amount
    };
    return map;
  }
}
