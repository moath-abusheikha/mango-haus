import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mango_haus/screens/screens.dart';
import 'package:mango_haus/api/guest_fire_base_api.dart';
import '../models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GuestFireBaseApi fireBaseApi = GuestFireBaseApi();
  List<Guest> suggestions = [];

  @override
  void initState() {
    getAllGuests();
    super.initState();
  }

  void getAllGuests() async {
    List<Guest> guests = await fireBaseApi.getAllGuests();
    for (int i = 0; i < guests.length; i++) {
      suggestions.add(guests[i]);
      // print(suggestions[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/paint-stain.png'), fit: BoxFit.fitHeight)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Spacer(),
                    Stack(children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width * 0.89,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.vertical(
                                bottom:
                                    Radius.elliptical(MediaQuery.of(context).size.width, 100.0))),
                      ),
                      Positioned(
                        child: Text(
                          'MANGO HAUS',
                          style: TextStyle(
                              color: Colors.orange, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        top: 80,
                        right: 20,
                        left: 60,
                      ),
                    ]),
                    Spacer(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
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
                          color: Colors.white.withOpacity(0.8),
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
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      highlightColor: Colors.grey.shade100,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => const CheckOut()));
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white.withOpacity(0.8),
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
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      highlightColor: Colors.grey.shade100,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ExtendStaying(suggestions: suggestions)));
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white.withOpacity(0.8),
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 20),
                            Icon(
                              Icons.edit_calendar,
                              color: Colors.green,
                              size: 35,
                            ),
                            SizedBox(height: 20),
                            Text('Extend Staying')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      highlightColor: Colors.grey.shade100,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => const GuestPayment()));
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white.withOpacity(0.8),
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
                    ),
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
                          color: Colors.white.withOpacity(0.8),
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
                    InkWell(
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
                            color: Colors.white.withOpacity(0.8),
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
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      highlightColor: Colors.grey.shade100,
                      onTap: () {
                        print(suggestions.length);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Reservation(guests: suggestions)));
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white.withOpacity(0.8),
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
                          color: Colors.white.withOpacity(0.8),
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
              ]),
        ),
      ),
    );
  }
}
