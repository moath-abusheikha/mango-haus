import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango_haus/models/models.dart';

class BookingFireBaseApi {
  Future<List<ReservationModel?>> getReservationByName(String guestName, String status) async {
    List<ReservationModel?> bookings = [];
    await FirebaseFirestore.instance
        .collection('reservations')
        .where('guestName', isEqualTo: guestName)
        .where('status', isEqualTo: status)
        .orderBy('checkIn')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        ReservationModel map = ReservationModel.fromMap(element.data());
        bookings.add(map);
      });
    });
    return bookings;
  }

  Future<List<ReservationModel>> getAllReservations() async {
    List<ReservationModel>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("reservations")
        .orderBy('guestName', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      ReservationModel booking = ReservationModel.fromMap(element);
      allDocs.add(booking);
    });
    // allDocs = querySnapshot.docs.map((doc) => doc.data()).cast<Booking>().toList();
    return allDocs;
  }

  Future<Iterable<ReservationModel>> filteredReservations(DateTime? startDate, DateTime? endDate,
      String? roomName, String? status, String? guestName) async {
    List<ReservationModel>? allDocs = [];
    Iterable<ReservationModel>? filteredQuery = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("reservations")
        .orderBy('checkIn', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      ReservationModel booking = ReservationModel.fromMap(element);
      allDocs.add(booking);
    });
    filteredQuery = allDocs;
    if (startDate != null) {
      filteredQuery = filteredQuery.where((element) => (element.checkIn.year == startDate.year &&
          element.checkIn.month == startDate.month &&
          element.checkIn.day >= startDate.day));
    }
    if (endDate != null)
      filteredQuery = filteredQuery.where((element) => (element.checkIn.year == endDate.year &&
          element.checkIn.month == endDate.month &&
          element.checkIn.day <= endDate.day));
    if (roomName != null && roomName.trim().toLowerCase() != 'room name')
      filteredQuery =
          filteredQuery.where((element) => element.room == roomName.trim().toLowerCase());
    if (status != null && status.trim().toLowerCase() != 'status')
      filteredQuery =
          filteredQuery.where((element) => element.status == status.trim().toLowerCase());
    if (guestName != null)
      filteredQuery = filteredQuery.where((element) => element.guestName == guestName);
    return filteredQuery;
  }

  Future<List<ReservationModel>> reservedBetween2CheckInDatesWithStatus(
      DateTime? startDate, DateTime? endDate, String status) async {
    List<ReservationModel>? allDocs = [];
    Iterable<ReservationModel>? filteredQuery = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("reservations")
        .orderBy('checkIn', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      if (startDate != null && endDate != null) {
        ReservationModel booking = ReservationModel.fromMap(element);
        if (booking.checkIn.year >= startDate.year &&
            booking.checkIn.year <= endDate.year &&
            booking.checkIn.month >= startDate.month &&
            booking.checkIn.month <= endDate.month &&
            booking.checkIn.day >= startDate.day &&
            booking.checkIn.day <= endDate.day &&
            booking.status == status) allDocs.add(booking);
      }
    });
    return allDocs;
  }
  Future<List<ReservationModel>> reservationsCheckIn(
      DateTime? checkIn) async {
    List<ReservationModel>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("reservations")
        .orderBy('checkIn', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      if (checkIn != null) {
        ReservationModel booking = ReservationModel.fromMap(element);
        if (booking.checkIn.year == checkIn.year &&
            booking.checkIn.month == checkIn.month &&
            booking.checkIn.day == checkIn.day){
          allDocs.add(booking);}
      }
    });
    return allDocs;
  }

  Future<List<ReservationModel>> reservationsCheckout(
      DateTime? checkOut) async {
    List<ReservationModel>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("reservations")
        .orderBy('checkIn', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      if (checkOut != null) {
        ReservationModel booking = ReservationModel.fromMap(element);
        if (booking.checkout.year == checkOut.year &&
            booking.checkout.month == checkOut.month &&
            booking.checkout.day == checkOut.day){
          allDocs.add(booking);}
      }
    });
    return allDocs;
  }

  void addReservation(ReservationModel booking) async {
    final docGuest = await FirebaseFirestore.instance.collection('reservations').doc();
    // booking.reservationId = docGuest.id;
    final json = booking.toMap();
    await docGuest.set(json);
  }

  void deleteReservation(ReservationModel booking) async {
    final docGuest = await FirebaseFirestore.instance
        .collection('reservations')
        .doc() //booking.guestName.toLowerCase().trim()
        .get();
    FirebaseFirestore.instance
        .runTransaction((transaction) async => await transaction.delete(docGuest.reference));
  }

  Future<void> updateReservation(ReservationModel booking) async {
    try {
      int docNumber = 0;
      final post = await FirebaseFirestore.instance
          .collection('reservations')
          .get()
          .then((QuerySnapshot snapshot) {
        int i = 0;
        snapshot.docs.forEach((element) {
          Map<String, dynamic> a = element.data() as Map<String, dynamic>;
          ReservationModel s = ReservationModel.fromMap(a);
          if (s.checkIn.day == booking.checkIn.day &&
              s.checkIn.month == booking.checkIn.month &&
              s.checkIn.year == booking.checkIn.year) docNumber = i;
          i++;
        });
        return snapshot.docs[docNumber].reference;
      });
      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {
        'totalPrice': booking.totalPrice,
        'guestName': booking.guestName,
        'checkIn': booking.checkIn,
        'checkout': booking.checkout,
        'nights': booking.nights,
        'room': booking.room,
        'bookedFrom': booking.bookedFrom,
        'guestsCount': booking.guestsCount,
        'roomPrice': booking.roomPrice,
        'reservedBed': booking.reservedBeds,
        'note': booking.note,
        'bookingDate': booking.bookingDate,
        'commission': booking.commission,
        'fullyPaid':booking.fullyPaid,
        'status': booking.status,
        'physicalCheckIn': booking.physicalCheckIn,
        'physicalCheckOut': booking.physicalCheckOut
      });
      batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
