import 'package:flutter/material.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:provider/provider.dart';
import 'package:mango_haus/models/models.dart';
import 'package:intl/intl.dart';

class EditPayments extends StatefulWidget {
  final suggestions;

  const EditPayments({this.suggestions, super.key});

  @override
  State<EditPayments> createState() => _EditPaymentsState();
}

class _EditPaymentsState extends State<EditPayments> {
  TextEditingController guestNameTEC = TextEditingController();
  FocusNode node1 = FocusNode();
  List<Payment> payments = [];
  Guest? guest;
  ScrollController scrollController = ScrollController();
  Payment? currentPayment;
  TextEditingController newAmount_tec = TextEditingController();
  List<double>? paymentPayments;
  DateTime? paymentDate;
  TextEditingController paymentAmount_tec = TextEditingController();
  List<ReservationModel?>? reservations;
  ReservationModel? currentReservation;
  double totalPayment = 0;
  List<double>? changedPayments, resPayments;
  List<DateTime>? changedDates, resPaymentsDates;
  List<TextEditingController> controllers = [];
  double? remaining;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orange, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.5, 0.9],
          ),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Edit Payments',
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
                    guest = await Provider.of<GuestManager>(context, listen: false)
                        .getGuest(selection.toLowerCase().trim());
                    if (guest != null) {
                      var tempRes = await Provider.of<ReservationManager>(context, listen: false)
                          .getReservationByName(guest!.name.trim().toLowerCase(), ['checkedIn','checkedOut']);
                      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                            reservations = tempRes;
                          }));
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
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Text(
                    reservations == null
                        ? 'No Reservations'
                        : 'Choose Reservation (${reservations?.length})',
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
                height: 150,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    reservations?.length == 0 || reservations == null
                        ? Center(
                            child: Text(
                              'No Payments Available Or Guest Checked Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: scrollController,
                              thickness: 10,
                              scrollbarOrientation: ScrollbarOrientation.right,
                              trackVisibility: true,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(width: 2)),
                                padding: EdgeInsets.only(left: 5, right: 15),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: reservations?.length,
                                  itemBuilder: ((context, index) => GestureDetector(
                                        onTap: () async {
                                          var currPayment = await Provider.of<PaymentManager>(
                                                  context,
                                                  listen: false)
                                              .getCurrentGuestPayment(
                                                  guest!.name,
                                                  reservations![index]!.checkIn,
                                                  reservations![index]!.checkout);
                                          // print(currPayment?.paymentAmounts.length);
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) => setState(() {
                                                    currentReservation = reservations?[index];
                                                    controllers = List.generate(
                                                        currPayment!.paymentAmounts.length,
                                                        (index) => TextEditingController());
                                                    resPayments = currPayment.paymentAmounts;
                                                    resPaymentsDates = currPayment.paymentDates;
                                                    double sum = 0;
                                                    resPayments?.forEach((element) {
                                                      sum += element;
                                                    });
                                                    totalPayment = sum;
                                                    remaining = currPayment.remaining;
                                                    changedPayments = resPayments;
                                                  }));
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
                                          child: reservations != null
                                              ? Text(DateFormat('EEEE, d MMM, yyyy')
                                                      .format(reservations![index]!.checkIn) +
                                                  '-' +
                                                  DateFormat('EEEE, d MMM, yyyy')
                                                      .format(reservations![index]!.checkout))
                                              : Text('No Reservations'),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              guest == null || currentReservation == null
                  ? Container()
                  : Container(
                      height: 250,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(width: 2)),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 5),
                            padding: EdgeInsets.all(5),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(5), color: Colors.white),
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration:
                                        BoxDecoration(border: Border.all(), color: Colors.white),
                                    child: Column(
                                      children: [
                                        Text('Amount paid'),
                                        Center(
                                          child: Text('$totalPayment'),
                                        )
                                      ],
                                    )),
                                Spacer(),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration:
                                        BoxDecoration(border: Border.all(), color: Colors.white),
                                    child: Column(
                                      children: [
                                        Text('Remaining balance'),
                                        Center(
                                          child: Text('$remaining'),
                                        ),
                                      ],
                                    )),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration:
                                      BoxDecoration(border: Border.all(), color: Colors.white),
                                  child: Column(
                                    children: [
                                      Text('Total Amount'),
                                      Center(
                                        child: Text('${currentReservation?.totalPrice}'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: Provider.of<PaymentManager>(context, listen: false)
                                  .getCurrentGuestPayment(guest!.name, currentReservation!.checkIn,
                                      currentReservation!.checkout),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (!snapshot.hasData) {
                                    return Text('No payments found');
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.all(5),
                                    itemCount: resPayments?.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 170,
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(10),
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
                                              child: Text(
                                                  '${DateFormat('EEEE, d MMM, yyyy').format(resPaymentsDates![index])}'),
                                            ),
                                            onTap: () => selectDate(index),
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 35,
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.only(left: 7),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  border: Border.all(
                                                      color: Colors.orangeAccent, width: 1),
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
                                              child: TextField(
                                                onSubmitted: (value) {
                                                  //print(double.parse(value) - resPayments![index] + totalPayment);
                                                  if (value.isNotEmpty) {
                                                    double diff = double.parse(value) -
                                                        resPayments![index] +
                                                        totalPayment;
                                                    // print('$diff - ${currentReservation!.totalPrice}');
                                                    if (diff <= currentReservation!.totalPrice) {
                                                      setState(() {
                                                        totalPayment = diff;
                                                        remaining = currentReservation!.totalPrice -
                                                            totalPayment;
                                                      });
                                                      changedPayments?[index] = double.parse(value);
                                                      controllers[index].clear();
                                                      print(changedPayments);
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          content:
                                                              Text('Amount Exceeds Total Price'),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  controllers[index].clear();
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('OK'))
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                controller: controllers[index],
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  label: Text(
                                                    '${resPayments?[index]}',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else
                                  return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              ElevatedButton(
                onPressed: () async {
                  Payment payment = Payment(
                      checkIn: currentReservation!.checkIn,
                      checkOut: currentReservation!.checkout,
                      receivedBy: currentPayment != null ? currentPayment!.receivedBy : '',
                      guestName: currentReservation!.guestName,
                      paymentAmounts: changedPayments!,
                      paymentDates: resPaymentsDates!,
                      remaining: remaining!);
                  await Provider.of<PaymentManager>(context, listen: false).updatePayment(payment);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('Payment Changed Successfully'),
                      title: Text('Success'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                guest = null;
                                guestNameTEC.clear();
                                currentReservation = null;
                                currentPayment = null;
                                controllers.forEach((element) => element.clear());
                                reservations = [];
                                remaining = 0;
                                totalPayment = 0;
                                resPaymentsDates = [];
                                resPayments = [];
                                changedPayments = [];
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Ok'))
                      ],
                    ),
                  );
                },
                child: Text('Change Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(index) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2123));
    if (date != null) {
      setState(() {
        resPaymentsDates?[index] = date;
      });
    }
  }
}
