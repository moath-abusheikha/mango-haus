import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango_haus/models/models.dart';

class PaymentFireBaseApi {
  void addPayment(Payment payment) async {
    final json = payment.toMap();
    final docCheckInOut = await FirebaseFirestore.instance.collection('payments').doc();
    await docCheckInOut.set(json);
  }

  Future<Payment?> getCurrentPayment(String guestName, DateTime checkIn, DateTime checkout) async {
    Payment? payment;
    print('$guestName - $checkIn - $checkout');
    final querySnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('guestName', isEqualTo: guestName)
        .get();
    Map<String, dynamic> result = querySnapshot.docs.first.data();
    payment = Payment.fromMap(result);
    // if (payment.remaining == 0) return null;
    return payment;
  }

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
      int docNumber = 0;
      final post = await FirebaseFirestore.instance
          .collection('payments')
          .where('guestName', isEqualTo: payment.guestName)
          .get()
          .then((QuerySnapshot snapshot) {
        int i = 0;
        snapshot.docs.forEach((element) {
          Map<String, dynamic> a = element.data() as Map<String, dynamic>;
          Payment s = Payment.fromMap(a);
          if (s.checkIn?.day == payment.checkIn?.day &&
              s.checkIn?.month == payment.checkIn?.month &&
              s.checkIn?.year == payment.checkIn?.year) docNumber = i;
          i++;
        });
        return snapshot.docs[docNumber].reference;
      });

      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {
        'checkIn': payment.checkIn,
        'checkOut': payment.checkOut,
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
