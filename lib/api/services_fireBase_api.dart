import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango_haus/models/models.dart';

class ServicesFireBaseApi {
  void addService(Services services) async {
    final json = services.toMap();
    final docServices = await FirebaseFirestore.instance.collection('services').doc();
    await docServices.set(json);
  }

  Future<Services?> getService() async {
    Services service;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('guestName', isEqualTo: 'something')
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    String encode = jsonEncode(allData.last);
    Map<String, dynamic> map = jsonDecode(encode);
    service = Services.fromMap(map);
    return service;
  }
  Future<List<Services>> getAllServices() async {
    List<Services> allDocs = [];
    await FirebaseFirestore.instance
        .collection("services")
        .orderBy('dateTime', descending: false)
        .get()
        .then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Services service = Services.fromMap(docSnapshot.data());
          //print(service.dateTime);
          allDocs.add(service);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return allDocs;
  }

  Future<void> updateService(Services service) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection('services')
          .where('guestName', isEqualTo: '')
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        return snapshot.docs[0].reference;
      });

      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {});
      batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
