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
                    child: ListView.builder(
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
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Charge : ${checkIns[index].totalPrice}',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Room : ${checkIns[index].room}',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'No. of Guests : ${checkIns[index].guestsCount}',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Check In : ${DateFormat('EEEE, d MMM, yyyy').format(checkIns[index].checkIn)}',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
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
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(height: 20),
                                Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                SizedBox(height: 20),
                                Text('Check in')
                              ],
                            ),
                          ),
                        );
                      },
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
                                builder: (context) => CheckOut(suggestions: suggestions)));
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(height: 20),
                                Icon(
                                  Icons.remove,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                SizedBox(height: 20),
                                Text('Check Out')
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
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(height: 20),
                                Icon(
                                  Icons.payments,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Guest Payment',
                                  style: TextStyle(fontSize: 12),
                                )
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
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 20),
                          Icon(
                            Icons.shopping_cart_checkout_outlined,
                            color: Colors.green,
                            size: 35,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Expenses',
                            style: TextStyle(fontSize: 12),
                          )
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
                            height: 100,
                            width: 100,
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
                                children: const [
                                  SizedBox(height: 20),
                                  Icon(
                                    Icons.room_service_rounded,
                                    color: Colors.green,
                                    size: 35,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Services',
                                    style: TextStyle(fontSize: 12),
                                  )
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
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                            border: Border.all(color: Colors.orangeAccent, width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(height: 20),
                              Icon(
                                Icons.my_library_books_outlined,
                                color: Colors.green,
                                size: 35,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'New Reservation',
                                style: TextStyle(fontSize: 12),
                              )
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
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 20),
                          Icon(
                            Icons.report_gmailerrorred,
                            color: Colors.green,
                            size: 35,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Reports',
                            style: TextStyle(fontSize: 12),
                          )
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
                  child: ListView.builder(
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
                              color: Colors.black, blurStyle: BlurStyle.outer, offset: Offset(3, 0))
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
