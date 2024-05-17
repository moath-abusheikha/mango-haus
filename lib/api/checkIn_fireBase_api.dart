import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango_haus/models/models.dart';

class CheckInOutFireBaseApi {
  void addCheckIn(CheckInOut checkInOut) async {
    final docCheckInOut = await FirebaseFirestore.instance.collection('check_in_out').doc(checkInOut.reservationId);
    final json = checkInOut.toMap();
    await docCheckInOut.set(json);
  }

  void deleteCheckIn(Guest guest) {}

  Future<CheckInOut> getCheckInOut(String? reservationId) async {
    CheckInOut? checkInOut;
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('check_in_out');
    QuerySnapshot querySnapshot =
        await _collectionRef.where('reservationId', isEqualTo: reservationId).get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    String encode = jsonEncode(allData.last);
    Map<String, dynamic> map = jsonDecode(encode);
    checkInOut = CheckInOut.fromMap(map);
    return checkInOut;
  }

  Future<List<CheckInOut>> getAllCheckIns() async {
    List<CheckInOut>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("check_in_out")
        .orderBy('guestName', descending: false)
        .get();
    var a = querySnapshot.docs.map((doc) => doc.data());
    a.forEach((element) {
      CheckInOut checkInOut = CheckInOut.fromMap(jsonDecode(jsonEncode(element)));
      allDocs.add(checkInOut);
    });
    // allDocs = querySnapshot.docs.map((doc) => doc.data()).cast<CheckInOut>().toList();
    return allDocs;
  }

  updateCheckInOut(CheckInOut? checkInOut) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection('check_in_out')
          .where('reservationId', isEqualTo: checkInOut?.reservationId)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        return snapshot.docs[0].reference;
      });

      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {
      });
      batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
