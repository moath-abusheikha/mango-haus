import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mango_haus/models/models.dart';

class GuestFireBaseApi {
  Future<Guest?> getGuest(String guestName) async {
    Guest? guest;
    DocumentReference guestRef =
        await FirebaseFirestore.instance.collection('guests').doc(guestName.trim());
    await guestRef.get().then((snapshot) {
      var data = snapshot.data();
      String encode = jsonEncode(data);
      Map<String, dynamic> map = jsonDecode(encode);
      guest = Guest.fromMap(map);
    });
    return guest;
  }

  Future<List<Guest>> getAllGuests() async {
    List<Guest> allDocs = [];
    await FirebaseFirestore.instance
        .collection("guests")
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Guest guest = Guest.fromMap(docSnapshot.data());
          allDocs.add(guest);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return allDocs;
  }

  Future<bool> userExist(String guestName) async {
    final docGuest = await FirebaseFirestore.instance.collection('guests').doc(guestName.trim());
    bool exists = false;
    await docGuest.get().then((DocumentSnapshot doc) async {
      if (doc.data() != null) exists = true;
    });
    return exists;
  }

  void addGuest(Guest guest) async {
    final docGuest =
          await FirebaseFirestore.instance.collection('guests').doc(guest.name.toString());
    final json = guest.toMap();
    await docGuest.set(json);
  }

  void deleteGuest(Guest guest) async {
    final docGuest = await FirebaseFirestore.instance
        .collection('guests')
        .doc(guest.name.toLowerCase().trim())
        .get();
    FirebaseFirestore.instance
        .runTransaction((transaction) async => await transaction.delete(docGuest.reference));
  }

  Future<void> updateGuest(Guest guest) async {
    final docGuest =
        FirebaseFirestore.instance.collection('guests').doc(guest.name.toLowerCase().trim());
    await docGuest.update({
      'passportImage': guest.passportImagePath,
      'PhoneNumber': guest.phoneNumber,
      'Nationality': guest.nationality,
      'Name': guest.name
    });
  }
  Future<void> changeGuestInfo(Guest currentGuest,Guest updatedGuest) async {
    final docGuest =
    FirebaseFirestore.instance.collection('guests').doc(currentGuest.name.toLowerCase().trim());
    await docGuest.update({
      'passportImage': updatedGuest.passportImagePath,
      'PhoneNumber': updatedGuest.phoneNumber,
      'Nationality': updatedGuest.nationality,
      'Name': updatedGuest.name
    });
  }
}
