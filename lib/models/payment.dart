import 'dart:convert';

Payment PaymentFromJson(String str) => Payment.fromMap(json.decode(str));

String PaymentToJson(Payment data) => json.encode(data.toMap());

class Payment {
  String guestName, receivedBy;
  List<String> paymentDates;
  double remaining;
  List<double> paymentAmounts;

  Payment(
      {required this.receivedBy,
      required this.guestName,
      required this.paymentAmounts,
      required this.paymentDates,
      required this.remaining});

  factory Payment.fromMap(Map<String, dynamic> map) {
    List<double> payments = [];
    List<dynamic> tempDates = [];
    List<String> dates = [];
    if (map['paymentDate'] != null) {
      List<dynamic> tempPayments = map['paymentAmount'];
      tempDates = map['paymentDate'];
      for (int i = 0; i < tempPayments.length; i++) {
        payments.add(tempPayments[i]);
        dates.add(tempDates[i]);
      }
    }
    return Payment(
        receivedBy: map['receivedBy'],
        guestName: map['guestName'],
        paymentAmounts: payments,
        paymentDates: dates,
        remaining: map['remaining'].toDouble());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'receivedBy': receivedBy,
      'guestName': guestName,
      'paymentDate': paymentDates,
      'paymentAmount': paymentAmounts,
      'remaining': remaining,
    };
    return map;
  }
}
