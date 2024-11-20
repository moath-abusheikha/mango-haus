import 'package:flutter/material.dart';
import 'package:mango_haus/api/api.dart';
import 'package:mango_haus/models/reservation.dart';

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

  Future<List<ReservationModel?>> getReservationByName(String guestName, String status) async {
    List<ReservationModel?> booking = await fireBaseApi.getReservationByName(guestName, status);
    // print('-- $booking');
    //if (booking[0] != null )print('${booking[0]!.checkIn} - ${booking[0]!.checkout}');
    notifyListeners();
    return booking;
  }

  Future<List<ReservationModel>> getAllReservations() async {
    List<ReservationModel> reservations = await fireBaseApi.getAllReservations();
    notifyListeners();
    return reservations;
  }

  Future<Iterable<ReservationModel>> filteredReservationsWith2DatesStatus(
      DateTime? startDate, DateTime? endDate, String status) async {
    Iterable<ReservationModel> reservations =
        await fireBaseApi.reservedBetween2CheckInDatesWithStatus(startDate, endDate, status);
    notifyListeners();
    return reservations;
  }

  Future<Iterable<ReservationModel>> reservationsCheckIn(DateTime? checkIn) async {
    List<ReservationModel> reservations = await fireBaseApi.reservationsCheckIn(checkIn);
    notifyListeners();
    return reservations;
  }

  Future<Iterable<ReservationModel>> filteredReservationsWithCheckOut(DateTime? checkOut) async {
    Iterable<ReservationModel> reservations = await fireBaseApi.reservationsCheckout(checkOut);
    notifyListeners();
    return reservations;
  }

  Future<Iterable<ReservationModel>> getReservationsWithFilter(DateTime? startCheckInDate,
      DateTime? endCheckInDate, String? roomName, String? status, String? guestName) async {
    Iterable<ReservationModel> reservations = await fireBaseApi.filteredReservations(
        startCheckInDate, endCheckInDate, roomName, status, guestName);
    notifyListeners();
    return reservations;
  }

  Future changeReservation(
      ReservationModel? currentReservation, ReservationModel? updatedReservation) async {
    if (updatedReservation != null && currentReservation != null)
      await fireBaseApi.changeReservationDetails(currentReservation, updatedReservation);
  }

  Future updateReservation(ReservationModel? booking) async {
    if (booking != null) await fireBaseApi.updateReservation(booking);
    notifyListeners();
  }
}
