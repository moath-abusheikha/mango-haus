import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango_haus/models/models.dart';

class RoomsAndBedsApi {
  Future<List<RoomAvailability?>> availableBeds(String room) async {
    List<RoomAvailability?> availableBeds = [];
    // await FirebaseFirestore.instance
    //     .collection('rooms_availability')
    //     .where('roomName', isEqualTo: room.trim().toLowerCase())
    //     .where('available', isEqualTo: true)
    //     .snapshots()
    //     .listen((event) {
    //   event.docs.forEach((element) {
    //     RoomAvailability map = RoomAvailability.fromMap(element.data());
    //     availableBeds.add(map);
    //     print('2 ${availableBeds.length}');
    //   });
    // });
    // print('3 ${availableBeds.length}');
    // return availableBeds;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("rooms_availability")
        .where('roomName', isEqualTo: room.trim().toLowerCase())
        .where('available', isEqualTo: true)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data());
    a.forEach((element) {
      RoomAvailability roomAvailability = RoomAvailability.fromMap(jsonDecode(jsonEncode(element)));
      availableBeds.add(roomAvailability);
    });
    // allDocs = querySnapshot.docs.map((doc) => doc.data()).cast<Booking>().toList();
    return availableBeds;
  }

  void updateAvailability(String room, String bed, bool availability) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection('rooms_availability')
          .where('bedNumber', isEqualTo: bed.toUpperCase())
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        return snapshot.docs[0].reference;
      });
      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {
        'available' : availability,
        'bedNumber':bed.toUpperCase(),
        'roomName': room
      });
      batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
