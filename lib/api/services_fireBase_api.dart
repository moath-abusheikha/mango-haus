import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          allDocs.add(service);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return allDocs;
  }

  Future<List<Services>> filteredServices(
      DateTime? startDate, DateTime? endDate, String? guestName, RangeValues? amountRange) async {
    if (startDate == null) startDate = DateTime(2020, 1, 1);
    if (endDate == null) endDate = DateTime.now();
    if (amountRange == null) amountRange = RangeValues(0, 300);
    List<Services>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("services")
        .orderBy('dateTime', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      Services service = Services.fromMap(element);
      if (service.dateTime.isAfter(startDate!.subtract(Duration(days: 1))) &&
          service.dateTime.isBefore(endDate!.add(Duration(days: 1))) &&
          service.amount < amountRange!.end &&
          service.amount > amountRange.start) {
        if (guestName == null) {
          allDocs.add(service);
        } else if (service.customerName.trim() == guestName.trim()) {
          allDocs.add(service);
        }
      }
    });
    return allDocs;
  }

  Future<void> updateService(Services service, Services updatedService) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection('services')
          .get()
          .then((QuerySnapshot snapshot) {
        DocumentReference? elementReference;
        snapshot.docs.forEach((element) {
          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          Services currService = Services.fromMap(map);
          if (currService.amount == service.amount &&
              currService.customerName == service.customerName &&
              currService.dateTime == service.dateTime &&
              currService.note == service.note) elementReference = element.reference;
        });
        //print(elementReference);
        return elementReference;
      });
      var batch = FirebaseFirestore.instance.batch();
      batch.update(post!, {
        'amount': updatedService.amount,
        'costumerName': updatedService.customerName,
        'dateTime': updatedService.dateTime,
        'note': updatedService.note
      });
      batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
