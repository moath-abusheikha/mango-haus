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
    // print('$guestName - $checkIn - $checkout');
    final querySnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('guestName', isEqualTo: guestName)
        .get();
    List<Map<String, dynamic>> result = querySnapshot.docs.map((doc) => doc.data()).toList();
    result.forEach((element) {
      var paymentTemp = Payment.fromMap(element);

      if (paymentTemp.checkIn?.year == checkIn.year &&
          paymentTemp.checkIn?.month == checkIn.month &&
          paymentTemp.checkIn?.day == checkIn.day &&
          paymentTemp.checkOut?.year == checkout.year &&
          paymentTemp.checkOut?.month == checkout.month &&
          paymentTemp.checkOut?.day == checkout.day) {
        payment = paymentTemp;
      }
    });
    return payment;
  }

  Future<List<Payment>> getPayment(String guestName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('guestName', isEqualTo: guestName)
        .get();
    final allData = querySnapshot.docs.map((doc) => Payment.fromMap(doc.data())).toList();
    return allData;
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

  void updatePaymentTotal(ReservationModel? reservation, double updatedTotal) async {
    print('guck');
    if (reservation != null)
      try {
        int docNumber = 0;
        double updatedRemaining = 0;
        var paymentAmounts = [];
        var paymentDates = [];
        String? receivedBy;
        final DocumentReference post = await FirebaseFirestore.instance
            .collection('payments')
            .where('guestName', isEqualTo: reservation.guestName)
            .get()
            .then((QuerySnapshot snapshot) {
          int i = 0;
          snapshot.docs.forEach((element) {
            Map<String, dynamic> a = element.data() as Map<String, dynamic>;
            Payment s = Payment.fromMap(a);
            if (s.checkIn?.day == reservation.checkIn.day &&
                s.checkIn?.month == reservation.checkIn.month &&
                s.checkIn?.year == reservation.checkIn.year) {
              paymentAmounts = s.paymentAmounts;
              paymentDates = s.paymentDates;
              receivedBy = s.receivedBy;
              docNumber = i;
              double total = 0;
              for (int i = 0; i < s.paymentAmounts.length; i++) {
                total += s.paymentAmounts[i];
              }
              updatedRemaining = updatedTotal - total + s.remaining;
            }
            ;
            i++;
          });
          return snapshot.docs[docNumber].reference;
        });
        // print('___ $post ## $updatedRemaining');

        var batch = FirebaseFirestore.instance.batch();
        batch.update(post, {
          'checkIn': reservation.checkIn,
          'checkOut': reservation.checkout,
          'guestName': reservation.guestName,
          'paymentAmount': paymentAmounts,
          'paymentDate': paymentDates,
          'receivedBy': receivedBy,
          'remaining': updatedRemaining,
        });
        batch.commit();
      } catch (e) {
        print(e);
      }
  }
}
