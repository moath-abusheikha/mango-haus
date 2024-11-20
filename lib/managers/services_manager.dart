import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mango_haus/api/api.dart';
import 'package:mango_haus/models/models.dart';

class ServicesManager extends ChangeNotifier {
  final ServicesFireBaseApi fireBaseApi = ServicesFireBaseApi();

  Future<void> addService(Services service) async {
    fireBaseApi.addService(service);
    notifyListeners();
  }

  void deleteReservation(Service service) async {
    // fireBaseApi.deleteService(service);
    notifyListeners();
  }

  Future<List<Services>?> getFilteredServices(
      DateTime? startDate, DateTime? endDate, String? guestName, RangeValues? amountRange) async {
    List<Services>? services =
        await fireBaseApi.filteredServices(startDate, endDate, guestName,amountRange);
    notifyListeners();
    return services;
  }

  Future<Services?> getService() async {
    Services? services = await fireBaseApi.getService();
    notifyListeners();
    return services;
  }

  getAllServices() async {
    List<Services> services = await fireBaseApi.getAllServices();
    notifyListeners();
    return services;
  }

  void updateService(Services service, Services updatedService) async {
    await fireBaseApi.updateService(service, updatedService);
    notifyListeners();
  }
}
