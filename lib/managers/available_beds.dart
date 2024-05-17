import 'package:flutter/material.dart';
import 'package:mango_haus/models/models.dart';
import '../api/api.dart';

class AvailableBeds extends ChangeNotifier {
  final RoomsAndBedsApi fireBaseApi = RoomsAndBedsApi();
  Future <List<RoomAvailability?>> getRoomAvailableBeds(String room) async{
    List<RoomAvailability?> availableBeds = await fireBaseApi.availableBeds(room);
    notifyListeners();
    return availableBeds;
  }
}
