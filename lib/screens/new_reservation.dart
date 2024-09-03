import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/models/models.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import '../managers/managers.dart';

class Reservation extends StatefulWidget {
  final List<Guest> guests;

  Reservation({required this.guests, super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  DateTimeRange selectedDate = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  static const List<String> rooms = <String>['Room', 'Alfonso', 'Mallika', 'Kent', 'tent'];
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));
  String bookingDate = DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()).toString();
  String roomsDDValue = rooms.first,
      countryName = '',
      countryFlag = '',
      phoneNumber = '',
      countryKey = '';
  double commissionPercentage = 0.15, commission = 0, roomPrice = 0, totalPrice = 0, netPrice = 0;
  TextEditingController guest_name = TextEditingController();
  TextEditingController bookedDate_TEC = TextEditingController();
  TextEditingController note_TEC = TextEditingController();
  TextEditingController number_of_guests = TextEditingController();
  TextEditingController phoneNumberTEC = TextEditingController();
  TextEditingController countryTEC = TextEditingController();
  TextEditingController personalCommission = TextEditingController();
  TextEditingController totalPriceTEC = TextEditingController();
  TextEditingController commission_TEC = TextEditingController();
  int nights = 1;
  Guest? guest;
  bool guestExist = false;
  List<String> bookedFrom = <String>['Booking', 'AirBnb', 'HostelWorld', 'Free'];
  String bookOpt = 'Booking';

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
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'New Reservation',
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
                child: TextField(
                  controller: guest_name,
                  onSubmitted: (value) {
                    for (int i = 0; i < widget.guests.length; i++) {
                      if (value.trim().toLowerCase() == widget.guests[i].name) {
                        setState(() {
                          guest = widget.guests[i];
                          guestExist = true;
                        });
                        break;
                      }
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'guest name',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.green),
                      prefixIcon: Icon(Icons.contact_page_outlined, color: Colors.green),
                      border: InputBorder.none),
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
                child: guest != null
                    ? Container(
                        margin: EdgeInsets.all(15),
                        child: Text(
                          'Phone Number : ${guest?.phoneNumber}   --   Country: ${guest?.nationality}',
                          style: TextStyle(fontSize: 14),
                        ))
                    : Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(countryFlag),
                              Text('+$countryKey'),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 160,
                                child: TextField(
                                  controller: phoneNumberTEC,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                      hintText: 'phone number', border: InputBorder.none),
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () => showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (Country country) {
                                  setState(() {
                                    countryName = country.name;
                                    countryFlag = country.flagEmoji;
                                    countryKey = country.phoneCode;
                                  });
                                }),
                            child: Text('Country'),
                          ),
                        ],
                      ),
              ),
              Row(
                children: [
                  Spacer(),
                  Container(
                    width: 110,
                    padding: EdgeInsets.all(5),
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
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.man, color: Colors.orange, size: 20),
                        Expanded(
                          child: TextField(
                            controller: number_of_guests,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: 'number of guests',
                                hintStyle: TextStyle(fontSize: 10),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 115,
                    margin: EdgeInsets.only(left: 5, right: 5),
                    padding: EdgeInsets.all(5),
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
                    child: DropdownButton(
                      underline: const SizedBox(),
                      value: bookOpt,
                      items: bookedFrom.map<DropdownMenuItem<String>>((String bookDest) {
                        return DropdownMenuItem<String>(
                          value: bookDest,
                          child: Text(bookDest),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          bookOpt = value!;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 115,
                    padding: EdgeInsets.only(right: 5),
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
                    child: TextField(
                      controller: totalPriceTEC,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          labelText: 'Total Price',
                          labelStyle: TextStyle(fontSize: 12),
                          prefixIcon: Container(
                              padding: EdgeInsets.only(top: 15, left: 10), child: Text('JOD')),
                          border: InputBorder.none),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  Container(
                      padding: EdgeInsets.all(5),
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
                      child: DropdownButton(
                        underline: const SizedBox(),
                        value: roomsDDValue,
                        items: rooms.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            roomsDDValue = value!;
                          });
                        },
                      )),
                  Container(
                    width: 150,
                    height: 55,
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
                    child: Center(
                        child: Text(
                      'Nights : ${nights}',
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  Spacer(),
                  Container(
                    width: 115,
                    padding: EdgeInsets.only(right: 5),
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
                    child: TextField(
                      controller: commission_TEC,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          labelText: 'Commission',
                          labelStyle: TextStyle(fontSize: 12),
                          prefixIcon: Container(
                              padding: EdgeInsets.only(top: 15, left: 10), child: Text('JOD')),
                          border: InputBorder.none),
                    ),
                  ),
                ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month, color: Colors.orangeAccent),
                    TextButton(
                        onPressed: () => _selectedDate(),
                        child: Text(
                          '$bookingDate',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month, color: Colors.orangeAccent),
                    TextButton(
                        onPressed: () async {
                          DateTimeRange? dateTimeRange = await showDateRangePicker(
                              initialDateRange:
                                  DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                              context: context,
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030));
                          if (dateTimeRange != null) {
                            //print('${selectedDate.start} ${selectedDate.end}');
                            setState(() {
                              selectedDate = dateTimeRange;
                              checkInDate = selectedDate.start;
                              checkOutDate = selectedDate.end;
                              nights =
                                  (selectedDate.end.difference(selectedDate.start).inHours / 24)
                                      .round();
                              // print(nights);
                              if (nights == 0) {
                                nights = 1;
                              }
                            });
                          }
                        },
                        child: Text(
                          '${DateFormat('EEEE, d MMM, yyyy').format(checkInDate)} - ${DateFormat('EEEE, d MMM, yyyy').format(checkOutDate)}',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
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
              GestureDetector(
                onTap: () async {
                  if (guest_name.text.isNotEmpty &&
                      number_of_guests.text.isNotEmpty &&
                      totalPriceTEC.text.isNotEmpty &&
                      roomsDDValue.isNotEmpty && roomsDDValue.toLowerCase().trim() != 'room') {
                    if (!guestExist) {
                      guest = Guest(
                        '',
                        '+${countryKey}${phoneNumberTEC.text}',
                        countryName,
                        name: guest_name.text.toLowerCase().trim(),
                      );
                      await Provider.of<GuestManager>(context, listen: false).addGuest(guest!);
                    }
                    List<ReservationModel?> guestReserve =
                    await Provider.of<ReservationManager>(context, listen: false)
                        .getReservationByName(guest!.name, 'reserved');
                    ReservationModel booking = ReservationModel(note_TEC.text, null, null, [],
                        commission: commission_TEC.text.toString().isNotEmpty
                            ? double.parse(commission_TEC.text)
                            : 0,
                        bookingDate: bookingDate,
                        totalPrice: double.parse(totalPriceTEC.text),
                        roomPrice: double.parse(totalPriceTEC.text) / nights,
                        checkIn: checkInDate,
                        checkout: checkOutDate,
                        guestsCount: int.parse(number_of_guests.text),
                        bookedFrom: bookOpt,
                        guestName: guest!.name,
                        nights: nights,
                        room: roomsDDValue.toLowerCase(),
                        status: 'reserved',
                        fullyPaid: false);
                    int i = 0;
                    for (i = 0; i < guestReserve.length; i++) {
                      if (booking == guestReserve[i]) break;
                    }
                    if (i == guestReserve.length) {
                      await Provider.of<ReservationManager>(context, listen: false)
                          .addGuestReservation(booking);
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.4),
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Reservation Complete'),
                          content: Text(
                            '${guest?.name}\'s reservation completed',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            ElevatedButton(
                              child: Text("Continue"),
                              onPressed: () {
                                setState(() {
                                  bookingDate = DateFormat('EEEE, d MMM, yyyy')
                                      .format(DateTime.now())
                                      .toString();
                                  guest = null;
                                  guest_name.text = '';
                                  commission_TEC.text = '';
                                  guestExist = false;
                                  number_of_guests.text = '';
                                  roomsDDValue = rooms.first;
                                  phoneNumberTEC.text = '';
                                  countryKey = '';
                                  note_TEC.text = '';
                                  countryFlag = '';
                                  countryName = '';
                                  bookOpt = 'Booking';
                                  totalPriceTEC.clear();
                                  nights = 0;
                                  totalPrice = 0;
                                  netPrice = 0;
                                  checkInDate = DateTime.now();
                                  checkOutDate = DateTime.now().add(Duration(days: 1));
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    } else
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.4),
                        context: context,
                        builder: (context) => Center(
                          child: AlertDialog(
                            content: Text(
                              '${guest_name.text} reservation exist',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context), child: Text('Back'))
                            ],
                          ),
                        ),
                      );
                  } else {
                    showDialog(
                      barrierColor: Colors.black.withOpacity(0.4),
                      context: context,
                      builder: (context) => Center(
                        child: AlertDialog(
                          title: Text('missing data'),
                          content: Text(
                            'some data is missing',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context), child: Text('Back'))
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectedDate() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(20100));
    if (_pickedDate != null)
      setState(() {
        bookingDate = DateFormat('EEEE, d MMM, yyyy').format(_pickedDate);
      });
  }
}
