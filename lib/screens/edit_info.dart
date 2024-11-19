import 'package:flutter/material.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/models.dart';
import 'package:mango_haus/subscreens/subscreens.dart';
import 'package:provider/provider.dart';

class EditInfos extends StatefulWidget {
  const EditInfos({super.key});

  @override
  State<EditInfos> createState() => _EditInfosState();
}

class _EditInfosState extends State<EditInfos> {
  List<Guest> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Edit Information',
                    style: TextStyle(
                      color: Colors.white,
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
              FutureBuilder(
                future: Provider.of<GuestManager>(context, listen: false).getAllGuests(),
                builder: (context, snapshot) {
                  suggestions.clear();
                  if (snapshot.data != null) {
                    List<Guest> guests = snapshot.data!;
                    for (int i = 0; i < guests.length; i++) {
                      suggestions.add(guests[i]);
                    }
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditReservation(suggestions: suggestions),
                      ));
                    },
                    child: Container(
                      width: 150,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black38, spreadRadius: 3, offset: Offset(0, 0)),
                          ]),
                      child: Center(
                          child: Text(
                        'Edit Reservation',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                    ),
                  );
                },
              ),
              FutureBuilder(
                  future: Provider.of<GuestManager>(context, listen: false).getAllGuests(),
                  builder: (context, snapshot) {
                    suggestions.clear();
                    if (snapshot.data != null) {
                      List<Guest> guests = snapshot.data!;
                      for (int i = 0; i < guests.length; i++) {
                        suggestions.add(guests[i]);
                      }
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditGuest(suggestions: suggestions),
                        ));
                      },
                      child: Container(
                        width: 150,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black38, spreadRadius: 3, offset: Offset(0, 0)),
                            ]),
                        child: Center(
                            child: Text(
                          'Edit Guest',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                      ),
                    );
                  }),
              FutureBuilder(
                  future: Provider.of<GuestManager>(context, listen: false).getAllGuests(),
                  builder: (context, snapshot) {
                    suggestions.clear();
                    if (snapshot.data != null) {
                      List<Guest> guests = snapshot.data!;
                      for (int i = 0; i < guests.length; i++) {
                        suggestions.add(guests[i]);
                      }
                    }
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditPayments(suggestions: suggestions),
                      )),
                      child: Container(
                        width: 150,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black38, spreadRadius: 3, offset: Offset(0, 0)),
                            ]),
                        child: Center(
                            child: Text(
                          'Edit Payment',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditExpense(),
                ));},
                child: Container(
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black38, spreadRadius: 3, offset: Offset(0, 0)),
                      ]),
                  child: Center(
                      child: Text(
                    'Edit Expenses',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              FutureBuilder(
                future: Provider.of<GuestManager>(context, listen: false).getAllGuests(),
                builder: (context, snapshot) {
                  suggestions.clear();
                  if (snapshot.data != null) {
                    List<Guest> guests = snapshot.data!;
                    for (int i = 0; i < guests.length; i++) {
                      suggestions.add(guests[i]);
                    }
                  }
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 150,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black38, spreadRadius: 3, offset: Offset(0, 0)),
                          ]),
                      child: Center(
                          child: Text(
                        'Edit Service',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
