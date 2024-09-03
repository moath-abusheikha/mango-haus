import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/screens/screens.dart';
import 'package:mango_haus/api/guest_fire_base_api.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GuestFireBaseApi fireBaseApi = GuestFireBaseApi();
  List<Guest> suggestions = [];
  int checkOutItemCount = 0, checkInItemCount = 0;
  List<ReservationModel> checkOuts = [], checkIns = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('images/paint-stain.png'), fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orange, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.5, 0.9],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 10, left: 10, right: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'MANGO HAUS',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Today Arrivals',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  margin: EdgeInsets.only(bottom: 2, left: 4),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(-2, -2),
                      blurStyle: BlurStyle.inner,
                      blurRadius: 7,
                    ),
                  ], color: Colors.white),
                ),
              ),
              Consumer<ReservationManager>(
                builder: (context, manager, child) {
                  manager.reservationsCheckIn(DateTime.now()).then((value) {
                    checkIns = value.toList();
                    checkInItemCount = value.length;
                  });
                  return Container(
                    height: 130,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(-2, -2),
                        blurStyle: BlurStyle.inner,
                        blurRadius: 7,
                      ),
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurStyle: BlurStyle.inner,
                        blurRadius: 7,
                      ),
                    ], color: Colors.white),
                    child: checkIns.length > 0
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: checkInItemCount,
                      itemBuilder: (context, index) => Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(top: 3, bottom: 3, right: 2, left: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                blurStyle: BlurStyle.outer,
                                offset: Offset(3, 0))
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            checkIns[index].status != 'checkedIn'
                                ? Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'Not Checked In',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                                : Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'Checked In',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            Text(
                              'Name : ${checkIns[index].guestName}',
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Charge : ${checkIns[index].totalPrice}',
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Room : ${checkIns[index].room}',
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'No. of Guests : ${checkIns[index].guestsCount}',
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Check In : ${DateFormat('EEEE, d MMM, yyyy').format(checkIns[index].checkIn)}',
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Center(
                      child: Text('No one is checking in today',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: fireBaseApi.getAllGuests(),
                      builder: (context, snapshot) {
                        suggestions.clear();
                        if (snapshot.data != null) {
                          List<Guest> guests = snapshot.data!;
                          for (int i = 0; i < guests.length; i++) {
                            suggestions.add(guests[i]);
                          }
                        }
                        return InkWell(
                          highlightColor: Colors.grey.shade100,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CheckIn(
                                  suggestions: suggestions,
                                )));
                          },
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'images/check-in.png',
                                    fit: BoxFit.fill,
                                    width: 50,
                                    height: 50,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text('Check in', style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                    FutureBuilder(
                      future: Provider.of<GuestManager>(context,listen: false).getAllGuests(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          suggestions.clear();
                          List<Guest> guests = snapshot.data!;
                          for (int i = 0; i < guests.length; i++) {
                            suggestions.add(guests[i]);
                          }
                        }
                        return InkWell(
                          highlightColor: Colors.grey.shade100,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CheckOut(suggestions: suggestions)));
                          },
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'images/check-out.png',
                                    fit: BoxFit.cover,
                                    width: 45,
                                    height: 45,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text('Check Out', style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: fireBaseApi.getAllGuests(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          suggestions.clear();
                          List<Guest> guests = snapshot.data!;
                          for (int i = 0; i < guests.length; i++) {
                            suggestions.add(guests[i]);
                          }
                        }
                        return InkWell(
                          highlightColor: Colors.grey.shade100,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GuestPayment(suggestions: suggestions)));
                          },
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'images/payment-method.png',
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text('Guest Payment', style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        );
                      }),
                  const SizedBox(width: 5),
                  InkWell(
                    highlightColor: Colors.grey.shade100,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => ExpensesPage()));
                    },
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'images/expenses.png',
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  FutureBuilder(
                      future: fireBaseApi.getAllGuests(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          suggestions.clear();
                          List<Guest> guests = snapshot.data!;
                          for (int i = 0; i < guests.length; i++) {
                            suggestions.add(guests[i]);
                          }
                        }
                        return InkWell(
                          highlightColor: Colors.grey.shade100,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ServicesScreen(suggestions: suggestions)));
                          },
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'images/services.png',
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text('Services', style: TextStyle(fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: fireBaseApi.getAllGuests(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        suggestions.clear();
                        List<Guest> guests = snapshot.data!;
                        for (int i = 0; i < guests.length; i++) {
                          suggestions.add(guests[i]);
                        }
                      }
                      return InkWell(
                        highlightColor: Colors.grey.shade100,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Reservation(guests: suggestions)));
                        },
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                            border: Border.all(color: Colors.orangeAccent, width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'images/online-reservation.png',
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 40,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('New Reservation', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    highlightColor: Colors.grey.shade100,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const ReportsScreen()));
                    },
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'images/reports.png',
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Reports', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    highlightColor: Colors.grey.shade100,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const EditInfos()));
                    },
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'images/edit.png',
                              fit: BoxFit.cover,
                              width: 45,
                              height: 45,color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Edit Informations', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Today Departure',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  margin: EdgeInsets.only(bottom: 2, left: 4),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(-2, -2),
                      blurStyle: BlurStyle.inner,
                      blurRadius: 7,
                    ),
                  ], color: Colors.white),
                ),
              ),
              Consumer<ReservationManager>(builder: (context, manager, child) {
                manager.filteredReservationsWithCheckOut(DateTime.now()).then(
                      (value) {
                    checkOuts = value.toList();
                    checkOutItemCount = value.length;
                  },
                );
                return Container(
                  height: 130,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(-2, -2),
                      blurStyle: BlurStyle.inner,
                      blurRadius: 7,
                    ),
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurStyle: BlurStyle.inner,
                      blurRadius: 7,
                    ),
                  ], color: Colors.white),
                  child: checkOuts.length > 0
                      ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: checkOuts.length,
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 3, bottom: 3, right: 2, left: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(3, 0))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          checkOuts[index].status == 'reserved'
                              ? Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Did Not Check in Yet',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                              : checkOuts[index].status == 'checkedIn'
                              ? Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Did not check out yet',
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                              : Text(
                            'Checked Out',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            'Name : ${checkOuts[index].guestName}',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Charge : ${checkOuts[index].totalPrice}',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Room : ${checkOuts[index].room}',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'No. of Guests : ${checkOuts[index].guestsCount}',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Check Out : ${DateFormat('EEEE, d MMM, yyyy').format(checkOuts[index].checkout)}',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Center(
                    child: Text('No one is checking out today',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
