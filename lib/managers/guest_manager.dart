import 'package:flutter/material.dart';
import 'package:mango_haus/models/guest.dart';
import '../api/guest_fire_base_api.dart';

class GuestManager extends ChangeNotifier {
  final GuestFireBaseApi fireBaseApi = GuestFireBaseApi();

  Future<void> addGuest(Guest guest) async {
    fireBaseApi.addGuest(guest);
    notifyListeners();
  }
  Future<List<Guest>> getAllGuests()async{
    List<Guest> guests = await fireBaseApi.getAllGuests();
    notifyListeners();
    return guests;
  }
  Future<bool> guestExist(String guestName) async {
    if (guestName.isNotEmpty && await fireBaseApi.userExist(guestName)) return true;
    notifyListeners();
    return false;
  }

  void removeGuest(Guest guest) async{
    fireBaseApi.deleteGuest(guest);
    notifyListeners();
  }

  Future<Guest?> getGuest(String guestName) async {
    Guest? guest = await fireBaseApi.getGuest(guestName);
    notifyListeners();
    return guest;
  }

  void updateGuest(Guest guest) async {
    await fireBaseApi.updateGuest(guest);
  }

  Future<bool> userExist(String guestName) async {
    return await fireBaseApi.userExist(guestName);
  }
}
