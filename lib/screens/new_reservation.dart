import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';

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
  TextEditingController room_name = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Reservation'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                      prefixIcon: Icon(Icons.contact_page_outlined, color: Colors.orangeAccent),
                      border: InputBorder.none),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 10,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                child: guest != null
                    ? Container(
                        margin: EdgeInsets.all(15),
                        child: Text(
                          'Phone Number : ${guest?.phoneNumber}   --   Country: ${guest?.Nationality}',
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                          boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                    child: Center(
                        child: Text(
                      'Nights : ${nights}',
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  Spacer(),
                  Container(
                    width: 115,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
              Container(
                margin: EdgeInsets.all(15),
                width: 80,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
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
                            .getReservationByName(guest!.name);
                    ReservationModel booking = ReservationModel(note_TEC.text,null,null,'',
                        commission: double.parse(commission_TEC.text),
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
                        status: 'reserved');
                    int i = 0;
                    for (i = 0; i < guestReserve.length; i++) {
                      if (booking == guestReserve[i]) break;
                    }
                    if (i == guestReserve.length) {
                      await Provider.of<ReservationManager>(context, listen: false)
                          .addGuestReservation(booking);
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text('${guest_name.text} reservation completed')));
                    } else
                      ScaffoldMessenger.of(context).showSnackBar(
                          new SnackBar(content: new Text('${guest_name.text} reservation exist')));

                    setState(() {
                      bookingDate =
                          DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()).toString();
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
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
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
