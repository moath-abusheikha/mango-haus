import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango_haus/models/models.dart';

class BookingFireBaseApi {
  Future<List<ReservationModel?>> getReservationByName(String guestName) async {
    List<ReservationModel?> bookings = [];
    await FirebaseFirestore.instance
        .collection('reservations')
        .where('guestName', isEqualTo: guestName)
    .where('status', isEqualTo: 'reserved')
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
    Iterable a = querySnapshot.docs.map((doc) => doc.data());
    a.forEach((element) {
      ReservationModel booking = ReservationModel.fromMap(jsonDecode(jsonEncode(element)));
      allDocs.add(booking);
    });
    // allDocs = querySnapshot.docs.map((doc) => doc.data()).cast<Booking>().toList();
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
      final post = await FirebaseFirestore.instance
          .collection('reservations')
          .where('checkIn', isEqualTo: booking.checkIn)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        return snapshot.docs[0].reference;
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
        'reservedBed': booking.reservedBed,
        'note': booking.note,
        'bookingDate': booking.bookingDate,
        'commission': booking.commission,
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
