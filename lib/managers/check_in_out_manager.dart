import 'package:flutter/material.dart';
import 'package:mango_haus/models/models.dart';
import '../api/api.dart';

class CheckInManager extends ChangeNotifier {
  final CheckInOutFireBaseApi fireBaseApi = CheckInOutFireBaseApi();

  Future<void> addCheckIn(CheckInOut checkInOut) async {
    fireBaseApi.addCheckIn(checkInOut);
    notifyListeners();
  }

  Future<List<CheckInOut>> getAllCheckIns() async{
    List<CheckInOut> checkIns = await fireBaseApi.getAllCheckIns();
    return checkIns;
  }
  void removeCheckInOut(Guest guest) async {
    fireBaseApi.deleteCheckIn(guest);
    notifyListeners();
  }

  Future<CheckInOut?> getCheckInOut(String? reservationId) async {
    CheckInOut? guestCheckIn = await fireBaseApi.getCheckInOut(reservationId);
    notifyListeners();
    return guestCheckIn;
  }

  void updateCheckInOut(CheckInOut? checkInOut) async {
    await fireBaseApi.updateCheckInOut(checkInOut);
  }
}
