import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';
import 'package:mango_haus/managers/managers.dart';
import '../api/guest_fire_base_api.dart';

class GuestPayment extends StatefulWidget {
  const GuestPayment({super.key});

  @override
  State<GuestPayment> createState() => _GuestPaymentState();
}

class _GuestPaymentState extends State<GuestPayment> {
  TextEditingController guestNameTEC = TextEditingController();
  FocusNode node1 = FocusNode();
  Guest? guest;
  CheckInOut? checkInOut;
  Payment? guestPayment;
  ReservationModel? reservation;
  List<String> suggestions = [];
  List<String>? paymentDatesList;
  List<double>? paymentAmountsList;
  GuestFireBaseApi fireBaseApi = GuestFireBaseApi();
  TextEditingController paymentAmount_TEC = TextEditingController();
  TextEditingController receivedBy_TEC = TextEditingController();
  String guestName = 'guestName', checkInDate = 'checking date', checkOutDate = 'checkout Date';
  double totalPrice = 0, remainingBalance = 0;
  DateTime paymentDate = DateTime.now();

  @override
  void initState() {
    getAllGuests();
    super.initState();
  }

  void getAllGuests() async {
    List<Guest> guests = await fireBaseApi.getAllGuests();
    for (int i = 0; i < guests.length; i++) {
      suggestions.add(guests[i].name);
      // print(suggestions[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Payment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                height: 55,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                child: RawAutocomplete(
                  textEditingController: guestNameTEC,
                  focusNode: node1,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      matches.addAll(suggestions);
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
                    guestPayment = await Provider.of<PaymentManager>(context, listen: false)
                        .getGuestPayment(selection.toLowerCase().trim());
                    // reservation = await Provider.of<ReservationManager>(context, listen: false)
                    //     .getGuestTodayReservation(selection.toLowerCase().trim());
                    //checkInOut = await Provider.of<CheckInManager>(context, listen: false)
                    //    .getCheckInOut(reservation?.reservationId);
                    // ToDo: check if user have more than 1 reservation
                    // ToDo: received by should be also an array
                    // print('guest: ${guest?.name}');
                    // print('guestPayment: ${guestPayment?.guestName}');
                    // print('check-in-out: ${checkInOut?.guestName}');
                    setState(() {
                      if (guest != null && guestPayment != null) {
                        guestName = guest!.name;
                         //checkInDate = reservation!.checkIn;
                        // checkOutDate = checkInOut!.checkOut;
                        totalPrice = guestPayment!.remaining;
                        paymentAmountsList = guestPayment!.paymentAmounts;
                        paymentDatesList = guestPayment!.paymentDates;
                        remainingBalance = totalPrice;
                      }
                    });
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
                          prefixIcon: Icon(Icons.contact_page_outlined, color: Colors.orangeAccent),
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
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.orange)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Guest Info:'),
                    SizedBox(height: 5),
                    Text('Name: $guestName'),
                    SizedBox(height: 5),
                    Text('Check in: $checkInDate'),
                    SizedBox(height: 5),
                    Text('Check out: $checkOutDate'),
                    SizedBox(height: 5),
                    Text('Total Charge: $totalPrice')
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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                    child: Center(
                        child: TextField(
                      onChanged: (value) {
                        remainingBalance = totalPrice - double.parse(value);
                        if (remainingBalance < 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              new SnackBar(content: new Text('Charging more than it should')));
                        } else {
                          setState(() {
                            remainingBalance = totalPrice - double.parse(value);
                          });
                        }
                      },
                      controller: paymentAmount_TEC,
                      decoration: InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.payment_rounded, color: Colors.orangeAccent),
                          border: InputBorder.none),
                    )),
                  ),
                  Spacer(),
                  Container(
                    height: 55,
                    width: 150,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                    child: Center(
                        child: TextField(
                      controller: receivedBy_TEC,
                      decoration: InputDecoration(
                          labelText: 'Received by',
                          prefixIcon: Icon(Icons.contact_page_outlined, color: Colors.orangeAccent),
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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                    child: Center(child: Text('Remaining Balance: $remainingBalance')),
                  ),
                  Spacer(),
                ],
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 10,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                child: Row(
                  children: [
                    Spacer(),
                    Text(DateFormat('EEEE, d MMM, yyyy').format(paymentDate).toString()),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () => selectDate(),
                      child: Text('change date'),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () async {
                      if (guestNameTEC.text.isEmpty)
                        ScaffoldMessenger.of(context)
                            .showSnackBar(new SnackBar(content: new Text('guest name is empty')));
                      paymentAmountsList?.add(double.parse(paymentAmount_TEC.text));
                      paymentDatesList?.add(DateFormat('EEEE, d MMM, yyyy').format(paymentDate));
                      Payment payment = Payment(
                          receivedBy: receivedBy_TEC.text,
                          guestName: guestName,
                          paymentAmounts: paymentAmountsList!,
                          paymentDates: paymentDatesList!,
                          remaining: remainingBalance);
                      await Provider.of<PaymentManager>(context, listen: false)
                          .updatePayment(payment);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(new SnackBar(content: new Text('payment is saved')));
                      if (remainingBalance == 0) {
                        checkInOut?.paid = true;
                        Provider.of<CheckInManager>(context, listen: false)
                            .updateCheckInOut(checkInOut);
                      }
                      setState(() {
                        guest = null;
                        guestPayment = null;
                        guestNameTEC.clear();
                        paymentAmount_TEC.clear();
                        receivedBy_TEC.clear();
                        guestName = 'guestName';
                        checkInDate = 'checking date';
                        checkOutDate = 'checkout Date';
                        totalPrice = 0;
                        remainingBalance = 0;
                        paymentDate = DateTime.now();
                      });
                    },
                    child: Text('Save Payment'),
                  ),
                  Spacer(),
                ],
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
        paymentDate = date;
      });
    }
  }
}
