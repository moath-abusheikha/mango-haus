import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';
import 'package:mango_haus/managers/managers.dart';
import '../api/guest_fire_base_api.dart';

class GuestPayment extends StatefulWidget {
  final List<Guest> suggestions;

  const GuestPayment({required this.suggestions, super.key});

  @override
  State<GuestPayment> createState() => _GuestPaymentState();
}

class _GuestPaymentState extends State<GuestPayment> {
  TextEditingController guestNameTEC = TextEditingController();
  FocusNode node1 = FocusNode();
  Guest? guest;
  CheckInOut? checkInOut;
  Payment? guestPayment;
  List<ReservationModel?> reservations = [];
  ReservationModel? currentReservation;
  List<DateTime> paymentDatesList = [];
  List<double> paymentAmountsList = [];
  GuestFireBaseApi fireBaseApi = GuestFireBaseApi();
  TextEditingController paymentAmount_TEC = TextEditingController();
  TextEditingController receivedBy_TEC = TextEditingController();
  String guestName = 'guestName', checkInRange = 'check in date - check out date';
  double totalPrice = 0, remainingBalance = 0, totalPayments = 0, remaining = 0;
  int numberOfGuest = 0, nights = 0;
  String roomName = 'Room Name';
  DateTime paymentDate = DateTime.now(),
      checkInDate = DateTime.now(),
      checkoutDate = DateTime.now();
  Payment? payment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'Guest Payment',
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
                    textEditingController: guestNameTEC,
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
                      // print('You just selected $selection');
                      guest = await Provider.of<GuestManager>(context, listen: false)
                          .getGuest(selection.toLowerCase().trim());
                      if (guest != null) {
                        guestName = guest!.name;
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
                                          ))));
                                }).toList(),
                              ))));
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
                            'Choose Reservation',
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
                                itemBuilder: ((context, index) {
                                  checkInRange = DateFormat('EEEE, d MMM, yyyy')
                                          .format(reservations[index]!.checkIn) +
                                      '-' +
                                      DateFormat('EEEE, d MMM, yyyy')
                                          .format(reservations[index]!.checkout);
                                  return GestureDetector(
                                    onTap: () async {
                                      payment =
                                          await Provider.of<PaymentManager>(context, listen: false)
                                              .getCurrentGuestPayment(
                                                  guestName,
                                                  reservations[index]!.checkIn,
                                                  reservations[index]!.checkout);
                                      for (int i = 0; i < payment!.paymentAmounts.length; i++) {
                                        totalPayments += payment!.paymentAmounts[i];
                                      }
                                      setState(() {
                                        paymentAmountsList = payment!.paymentAmounts;
                                        currentReservation = reservations[index];
                                        roomName = currentReservation!.room;
                                        checkInDate = currentReservation!.checkIn;
                                        checkoutDate = currentReservation!.checkout;
                                        checkInRange = DateFormat('EEEE, d MMM, yyyy')
                                                .format(currentReservation!.checkIn) +
                                            '-' +
                                            DateFormat('EEEE, d MMM, yyyy')
                                                .format(currentReservation!.checkout);
                                        totalPrice = currentReservation!.totalPrice;
                                        nights = currentReservation!.nights;
                                        numberOfGuest = currentReservation!.guestsCount;
                                        remaining = payment!.remaining;
                                        remainingBalance = totalPrice - totalPayments;
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
                                            '-' +
                                            DateFormat('EEEE, d MMM, yyyy')
                                                .format(reservations[index]!.checkout))),
                                  );
                                }),
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Name: $guestName'),
                            SizedBox(height: 5),
                            Text('Check in Range: $checkInRange'),
                            SizedBox(height: 5),
                            Text('Nights : $nights'),
                            SizedBox(height: 5),
                            Text('Number of Guests: $numberOfGuest'),
                            SizedBox(height: 5),
                            Text('Total Charge: $totalPrice'),
                            SizedBox(height: 5),
                            Text('Room Name: $roomName'),
                            SizedBox(height: 5),
                            Text('Total Payments: $totalPayments'),
                            SizedBox(height: 5),
                            Text('Remaining: $remaining'),
                            SizedBox(height: 5),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      height: 55,
                      width: 150,
                      margin: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(15.0), boxShadow: [
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
                      child: Center(
                          child: TextField(
                        onChanged: (value) {
                          if (value.isEmpty) value = '0';
                          if (remaining < double.parse(value)) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: Text('Warning'),
                                  content: Text('Amount is bigger than Remaining')),
                            );
                          } else {
                            setState(() {
                              remainingBalance = remaining - double.parse(value);
                            });
                          }
                        },
                        controller: paymentAmount_TEC,
                        decoration: InputDecoration(
                            labelText: 'Amount',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.green),
                            prefixIcon: Icon(Icons.payment_rounded, color: Colors.green),
                            border: InputBorder.none),
                      )),
                    ),
                    Spacer(),
                    Container(
                      height: 55,
                      width: 150,
                      margin: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(15.0), boxShadow: [
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
                      child: Center(
                          child: TextField(
                        controller: receivedBy_TEC,
                        decoration: InputDecoration(
                            labelText: 'Received by',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.green),
                            prefixIcon: Icon(Icons.contact_page_outlined, color: Colors.green),
                            border: InputBorder.none),
                      )),
                    ),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      height: 55,
                      width: 200,
                      margin: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(15.0), boxShadow: [
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
                      child: Center(
                          child: Text(
                        'Remaining Balance: $remainingBalance',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      )),
                    ),
                    Spacer(),
                  ],
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width - 10,
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
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (guestNameTEC.text.isNotEmpty) {
                        paymentAmountsList.add(double.parse(paymentAmount_TEC.text));
                        paymentDatesList.add(paymentDate);
                        Payment currentPayment = Payment(
                            checkIn: checkInDate,
                            checkOut: checkoutDate,
                            receivedBy: receivedBy_TEC.text,
                            guestName: guestName,
                            paymentAmounts: paymentAmountsList,
                            paymentDates: paymentDatesList,
                            remaining: remainingBalance);
                        await Provider.of<PaymentManager>(context, listen: false)
                            .updatePayment(currentPayment);
                        if (remainingBalance == 0) {
                          currentReservation!.fullyPaid = true;
                          await Provider.of<ReservationManager>(context, listen: false)
                              .updateReservation(currentReservation);
                        }
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Information'),
                            content: Text('payment is saved'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      guest = null;
                                      guestPayment = null;
                                      guestNameTEC.clear();
                                      paymentAmount_TEC.clear();
                                      receivedBy_TEC.clear();
                                      guestName = 'guestName';
                                      checkInDate = DateTime.now();
                                      checkoutDate = DateTime.now();
                                      totalPrice = 0;
                                      remainingBalance = 0;
                                      paymentDate = DateTime.now();
                                      totalPayments = 0;
                                      reservations.clear();
                                      nights = 0;
                                      checkInRange = 'Check In Date - Check Out Date';
                                      remaining = 0;
                                      numberOfGuest = 0;
                                      roomName = '';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('continue'))
                            ],
                          ),
                        );
                      } else
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('warning'),
                            content: Text('guest name is empty'),
                          ),
                        );
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
                      child: Center(child: Text('Save Payment')),
                    ),
                  ),
                ),
              ],
            ),
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
        paymentDate = date;
      });
    }
  }
}
