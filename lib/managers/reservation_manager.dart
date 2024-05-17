import 'package:flutter/material.dart';
import 'package:mango_haus/api/api.dart';
import 'package:mango_haus/models/reservation.dart';
import '../api/guest_fire_base_api.dart';

class ReservationManager extends ChangeNotifier {
  final BookingFireBaseApi fireBaseApi = BookingFireBaseApi();

  Future<void> addGuestReservation(ReservationModel booking) async {
    fireBaseApi.addReservation(booking);
    notifyListeners();
  }

  void deleteReservation(ReservationModel booking) async {
    fireBaseApi.deleteReservation(booking);
    notifyListeners();
  }


  Future<List<ReservationModel?>> getReservationByName(String guestName) async {
    List<ReservationModel?> booking = await fireBaseApi.getReservationByName(guestName);
    notifyListeners();
    return booking;
  }
  Future<List<ReservationModel>> getAllReservations() async{
    List<ReservationModel> reservations = await fireBaseApi.getAllReservations();
    return reservations;
  }

  Future updateReservation(ReservationModel? booking) async {
    await fireBaseApi.updateReservation(booking!);
  }
}
