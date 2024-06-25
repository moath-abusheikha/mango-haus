import 'package:flutter/material.dart';
import 'package:mango_haus/api/api.dart';
import 'package:mango_haus/models/models.dart';

class PaymentManager extends ChangeNotifier {
  final PaymentFireBaseApi fireBaseApi = PaymentFireBaseApi();

  Future<void> addGuestPayment(Payment payment) async {
    fireBaseApi.addPayment(payment);
    notifyListeners();
  }

  void deletePayment() async {
    notifyListeners();
  }

  Future<Payment?> getGuestPayment(String guestName) async {
    Payment? payment;
    payment = await fireBaseApi.getPayment(guestName);
    notifyListeners();
    return payment;
  }
  Future<Payment?> getCurrentGuestPayment(String guestName,DateTime checkIn,DateTime checkOut) async {
    Payment? payment;
    payment = await fireBaseApi.getCurrentPayment(guestName,checkIn,checkOut);
    notifyListeners();
    return payment;
  }
  Future<void> updatePayment(Payment? payment) async {
    fireBaseApi.updatePayment(payment!);
    notifyListeners();
  }

  getAllPayments() async{
    List<Payment> payments = await fireBaseApi.getAllPayments();
    notifyListeners();
    return payments;
  }
}
