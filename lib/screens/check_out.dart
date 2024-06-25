import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../api/api.dart';
import '../managers/managers.dart';
import '../models/models.dart';

class CheckOut extends StatefulWidget {
  final List<Guest> suggestions;

  const CheckOut({required this.suggestions, super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  GuestFireBaseApi fireBaseApi = GuestFireBaseApi();
  GlobalKey key = GlobalKey();
  TextEditingController guestName_TEC = TextEditingController();
  FocusNode node1 = FocusNode();
  String checkInOutDate = 'check in Date - check out date', roomName = '';
  double totalCharge = 0, totalPayments = 0, remaining = 0;
  Guest? guest;
  int nights = 0, numberOfGuests = 0;
  List<ReservationModel?> reservations = [];
  ReservationModel? currentReservation;
  TextEditingController note_TEC = TextEditingController();
  DateTime checkoutDate = DateTime.now();
  ReservationModel? booking;
  RoomsAndBedsApi roomsAndBeds = RoomsAndBedsApi();
  Payment? payment;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Check Out',
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
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          blurStyle: BlurStyle.inner,
                          offset: Offset(-2, -2)),
                      BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          blurStyle: BlurStyle.inner,
                          offset: Offset(2, 2))
                    ]),
                child: RawAutocomplete(
                  textEditingController: guestName_TEC,
                  focusNode: node1,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      for (int i = 0; i < widget.suggestions.length; i++)
                        matches.add(widget.suggestions[i].name);
                      matches.retainWhere((s) {
                        return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                      return matches;
                    }
                  },
                  onSelected: (String selection) async {
                    guest = await Provider.of<GuestManager>(context, listen: false)
                        .getGuest(selection.toLowerCase().trim());
                    if (guest != null) {
                      reservations = await Provider.of<ReservationManager>(context, listen: false)
                          .getReservationByName(guest!.name.trim().toLowerCase(), 'checkedIn');
                    }
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          labelText: 'guest name',
                          labelStyle: TextStyle(fontSize: 20, color: Colors.green),
                          prefixIcon: Icon(Icons.contact_page_outlined, color: Colors.green),
                          border: InputBorder.none),
                    );
                  },
                  optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                      Iterable<String> options) {
                    return Material(
                      child: SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Column(
                            children: options.map((opt) {
                              return InkWell(
                                onTap: () {
                                  onSelected(opt);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 60),
                                  child: Card(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(opt),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 100,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          'Choose Check In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
                    reservations.length == 0
                        ? Center(
                            child: Text('No data'),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: reservations.length,
                              itemBuilder: ((context, index) => GestureDetector(
                                    onTap: () async {
                                      currentReservation = reservations[index];
                                      payment =
                                          await Provider.of<PaymentManager>(context, listen: false)
                                              .getCurrentGuestPayment(
                                                  guest!.name,
                                                  reservations[index]!.checkIn,
                                                  reservations[index]!.checkout);
                                      totalPayments = 0;
                                      if (payment != null)
                                        for (int i = 0; i < payment!.paymentAmounts.length; i++) {
                                          totalPayments += payment!.paymentAmounts[i];
                                        }
                                      setState(() {
                                        roomName = reservations[index]!.room;
                                        checkInOutDate = DateFormat('EEEE, d MMM, yyyy')
                                                .format(reservations[index]!.checkIn) +
                                            '-' +
                                            DateFormat('EEEE, d MMM, yyyy')
                                                .format(reservations[index]!.checkout);
                                        totalCharge = reservations[index]!.totalPrice;
                                        nights = reservations[index]!.nights;
                                        numberOfGuests = reservations[index]!.guestsCount;
                                        if (payment != null) remaining = payment!.remaining;
                                      });
                                    },
                                    child: Container(
                                        padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 3.0,
                                                  color: Colors.black,
                                                  offset: Offset(2, 2),
                                                  blurStyle: BlurStyle.outer),
                                              BoxShadow(
                                                  blurRadius: 3.0,
                                                  color: Colors.white,
                                                  offset: Offset(2, 2),
                                                  blurStyle: BlurStyle.inner)
                                            ]),
                                        child: Text(DateFormat('EEEE, d MMM, yyyy')
                                                .format(reservations[index]!.checkIn) +
                                            ' - ' +
                                            DateFormat('EEEE, d MMM, yyyy')
                                                .format(reservations[index]!.checkout))),
                                  )),
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          'Guest Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                      margin: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                        BoxShadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurStyle: BlurStyle.outer),
                        BoxShadow(
                            blurRadius: 3.0,
                            color: Colors.white,
                            offset: Offset(2, 2),
                            blurStyle: BlurStyle.inner)
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              guest?.name != null
                                  ? Text('Name: ${guest!.name}')
                                  : Text('Guest Name'),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Check in Range: $checkInOutDate'),
                          SizedBox(
                            height: 5,
                          ),
                          nights == 1
                              ? Text(
                                  'Staying Duration : 1 night',
                                )
                              : Text(
                                  'Staying Duration : ${nights} nights',
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Number Of Guests : ${numberOfGuests.toString()}'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Total Charge: $totalCharge'),
                          SizedBox(height: 5),
                          Text('Total Payments: $totalPayments'),
                          SizedBox(height: 5),
                          Text('Remaining Balance: $remaining'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 10,
                    margin: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                      BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurStyle: BlurStyle.outer),
                      BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.white,
                          offset: Offset(2, 2),
                          blurStyle: BlurStyle.inner)
                    ]),
                    child: Row(
                      children: [
                        Spacer(),
                        Text(DateFormat('EEEE, d MMM, yyyy').format(checkoutDate).toString()),
                        Spacer(),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurStyle: BlurStyle.inner,
                                      color: Colors.black,
                                      offset: Offset(0, 2),
                                      blurRadius: 10,
                                      spreadRadius: 1),
                                  BoxShadow(
                                      blurStyle: BlurStyle.inner,
                                      offset: Offset(-2, -2),
                                      color: Colors.white,
                                      blurRadius: 10,
                                      spreadRadius: 1),
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.orange.shade100,
                                      Colors.orange.shade300,
                                      Colors.orange.shade500,
                                      Colors.orange.shade600,
                                    ],
                                    stops: [
                                      0.0,
                                      0.3,
                                      0.6,
                                      0.9
                                    ])),
                            child: GestureDetector(
                              onTap: () => selectDate(),
                              child: Text('change date'),
                            )),
                        Spacer()
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                  BoxShadow(
                      blurRadius: 3.0,
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurStyle: BlurStyle.outer),
                  BoxShadow(
                      blurRadius: 3.0,
                      color: Colors.white,
                      offset: Offset(2, 2),
                      blurStyle: BlurStyle.inner)
                ]),
                child: TextField(
                  controller: note_TEC,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Note',
                      prefixIcon: Icon(
                        Icons.speaker_notes,
                        color: Colors.orangeAccent,
                      )),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (remaining != 0) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(content: Text('guest cant check out, payment required')),
                      );
                    } else if (guestName_TEC.text.isNotEmpty) {
                      currentReservation?.status = 'checkedOut';
                      currentReservation?.physicalCheckOut = checkoutDate;
                      Provider.of<ReservationManager>(context, listen: false)
                          .updateReservation(currentReservation);
                      currentReservation?.reservedBeds.forEach((element) {
                        roomsAndBeds.updateAvailability(currentReservation!.room, element, true);
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text('${guest?.name} checked out successfully '),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    guest = null;
                                    reservations.clear();
                                    nights = 0;
                                    guestName_TEC.clear();
                                    checkInOutDate = 'check in Date - check out date';
                                    checkoutDate = DateTime.now();
                                    guestName_TEC.clear();
                                    numberOfGuests = 0;
                                    totalCharge = 0;
                                    totalPayments = 0;
                                    remaining = 0;
                                    roomName = '';
                                  });
                                },
                                child: Text('Continue'))
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(content: Text('guest name cannot be empty')),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(15),
                    width: 100,
                    height: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              blurStyle: BlurStyle.inner,
                              color: Colors.black,
                              offset: Offset(0, 2),
                              blurRadius: 10,
                              spreadRadius: 1),
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.orange.shade100,
                              Colors.orange.shade300,
                              Colors.orange.shade500,
                              Colors.orange.shade600,
                            ],
                            stops: [
                              0.0,
                              0.3,
                              0.6,
                              0.9
                            ])),
                    child: Center(child: Text('Check Out')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2123));
    if (date != null) {
      setState(() {
        checkoutDate = date;
      });
    }
  }
}
