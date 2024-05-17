import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango_haus/models/models.dart';

class PaymentFireBaseApi {
  void addPayment(Payment payment) async {
    final json = payment.toMap();
    final docCheckInOut = await FirebaseFirestore.instance.collection('payments').doc();
    await docCheckInOut.set(json);
  }

// ToDo: get payment
  Future<Payment?> getPayment(String guestName) async {
    Payment? payment;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('guestName', isEqualTo: guestName)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    String encode = jsonEncode(allData.last);
    Map<String, dynamic> map = jsonDecode(encode);
    payment = Payment.fromMap(map);
    return payment;
  }

  Future<void> updatePayment(Payment payment) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection('payments')
          .where('guestName', isEqualTo: payment.guestName)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        return snapshot.docs[0].reference;
      });

      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {
        'guestName': payment.guestName,
        'paymentAmount': payment.paymentAmounts,
        'paymentDate': payment.paymentDates,
        'receivedBy': payment.receivedBy,
        'remaining': payment.remaining,
      });
      batch.commit();
    } catch (e) {
      print(e);
    }
  }
  Future<List<Payment>> getAllPayments() async {
    List<Payment>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("payments")
        .orderBy('guestName', descending: false)
        .get();
    var a = querySnapshot.docs.map((doc) => doc.data());
    a.forEach((element) {
      Payment payment = Payment.fromMap(jsonDecode(jsonEncode(element)));
      allDocs.add(payment);
    });
    // allDocs = querySnapshot.docs.map((doc) => doc.data()).cast<Payment>().toList();
    return allDocs;
  }

}
