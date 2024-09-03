import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/models/guest.dart';
import 'package:mango_haus/models/reservation.dart';
import 'package:provider/provider.dart';
import 'package:mango_haus/managers/managers.dart';

class EditReservation extends StatefulWidget {
  final List<Guest> suggestions;

  const EditReservation({super.key, required this.suggestions});

  @override
  State<EditReservation> createState() => _EditReservationState();
}

class _EditReservationState extends State<EditReservation> {
  TextEditingController guestNameTEC = TextEditingController();
  FocusNode node1 = FocusNode();
  Guest? guest;
  ScrollController scrollController = ScrollController();
  Iterable<ReservationModel?>? guestReservations;
  ReservationModel? currentReservation;
  String? checkInRange, roomName;
  int? numberOfGuests, nights;
  double? totalPrice, commission;
  String newBookedDate = 'New Date',
      oldNote = 'Old Value',
      newCheckIn = 'New Date',
      newCheckOut = 'New Date',
      newPhysicalCheckIn = 'New Date',
      newPhysicalCheckOut = 'New Date',
      bookedFromValue = 'Booking',
      roomNameValue = 'alfonso',
      statusValue = 'reserved';
  List<String> bookedFromOpt = ['Booking', 'Hostel World', 'AirPnp', 'Free'],
      roomNameOpt = ['alfonso', 'kent', 'mallika', 'tent'],
      statusOpt = ['reserved', 'checkedIn', 'checkedOut'];
  TextEditingController commission_tec = TextEditingController();
  TextEditingController nOfGs_tec = TextEditingController();
  TextEditingController note_tec = TextEditingController();
  TextEditingController totalPrice_tec = TextEditingController();

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
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Edit Reservation',
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
                    Iterable<ReservationModel?>? temp =
                        await Provider.of<ReservationManager>(context, listen: false)
                            .getReservationsWithFilter(null, null, null, null, guest?.name);
                    if (guest != null) {
                      setState(() {
                        guestReservations = temp;
                      });
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
                height: 150,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: guestReservations?.length != null
                            ? Text(
                                'Choose Reservation (${guestReservations?.length})',
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
                              )
                            : Text(
                                'Reservations',
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
                    SizedBox(
                      height: 5,
                    ),
                    guestReservations == null
                        ? Center(
                            child: Text('No data'),
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
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: guestReservations?.length,
                                  itemBuilder: ((context, index) {
                                    currentReservation = guestReservations?.elementAt(index);
                                    return GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          currentReservation = guestReservations?.elementAt(index);
                                          if (currentReservation != null) {
                                            oldNote = currentReservation!.note;
                                            bookedFromValue = currentReservation!.bookedFrom;
                                            roomNameValue = currentReservation!.room;
                                            statusValue = currentReservation!.status;
                                            roomName = currentReservation!.room;
                                            newBookedDate = currentReservation!.bookingDate;
                                            newCheckIn = DateFormat('EEEE, d MMM, yyyy')
                                                .format(currentReservation!.checkIn);
                                            newCheckOut = DateFormat('EEEE, d MMM, yyyy')
                                                .format(currentReservation!.checkout);
                                            if (currentReservation!.physicalCheckIn != null)
                                              newPhysicalCheckIn = DateFormat('EEEE, d MMM, yyyy')
                                                  .format(currentReservation!.physicalCheckIn!);
                                            if (currentReservation!.physicalCheckOut != null)
                                              newPhysicalCheckOut = DateFormat('EEEE, d MMM, yyyy')
                                                  .format(currentReservation!.physicalCheckOut!);
                                            bookedFromValue = currentReservation!.bookedFrom;
                                            roomNameValue = currentReservation!.room;
                                            statusValue = currentReservation!.status;
                                            checkInRange = DateFormat('EEEE, d MMM, yyyy')
                                                    .format(currentReservation!.checkIn) +
                                                '-' +
                                                DateFormat('EEEE, d MMM, yyyy')
                                                    .format(currentReservation!.checkout);
                                            totalPrice = currentReservation!.totalPrice;
                                            nights = currentReservation!.nights;
                                            numberOfGuests = currentReservation!.guestsCount;
                                            commission = currentReservation!.commission;
                                          }
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
                                        child: currentReservation != null
                                            ? Text(DateFormat('EEEE, d MMM, yyyy').format(
                                                    guestReservations!.elementAt(index)!.checkIn) +
                                                '-' +
                                                DateFormat('EEEE, d MMM, yyyy').format(
                                                    guestReservations!.elementAt(index)!.checkout))
                                            : Container(),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              currentReservation != null
                  ? Column(
                      children: [
                        Text(
                          'Current Reservation Information',
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Booked from: '),
                                    Spacer(),
                                    Container(
                                      width: 110,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      child: DropdownButton<String>(
                                        value: bookedFromValue,
                                        icon: const Icon(Icons.arrow_downward, color: Colors.black),
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                        items: bookedFromOpt
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (value) => setState(() {
                                          bookedFromValue = value!;
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Room Name '),
                                    Spacer(),
                                    Container(
                                      width: 110,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      child: DropdownButton<String>(
                                        value: roomNameValue,
                                        icon: const Icon(Icons.arrow_downward, color: Colors.black),
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                        items: roomNameOpt
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (value) => setState(() {
                                          roomNameValue = value!;
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Reservation Status: '),
                                    Spacer(),
                                    Container(
                                      width: 110,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      child: DropdownButton<String>(
                                        value: statusValue,
                                        icon: const Icon(Icons.arrow_downward, color: Colors.black),
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                        items:
                                            statusOpt.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (value) => setState(() {
                                          statusValue = value!;
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Commission: '),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(right: 8),
                                      width: 180,
                                      child: TextField(
                                        controller: commission_tec,
                                        decoration: InputDecoration(
                                            labelText: commission.toString(),
                                            filled: true,
                                            fillColor: Colors.grey,
                                            disabledBorder: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Number Of Guests '),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(right: 8),
                                      width: 180,
                                      child: TextField(
                                        controller: nOfGs_tec,
                                        decoration: InputDecoration(
                                            labelText: numberOfGuests.toString(),
                                            filled: true,
                                            fillColor: Colors.grey,
                                            disabledBorder: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Note: '),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(right: 8),
                                      width: 180,
                                      child: TextField(
                                        controller: note_tec,
                                        decoration: InputDecoration(
                                            labelText: oldNote,
                                            filled: true,
                                            fillColor: Colors.grey,
                                            disabledBorder: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Total Price: '),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(right: 8),
                                      width: 180,
                                      child: TextField(
                                        controller: totalPrice_tec,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: totalPrice.toString(),
                                            filled: true,
                                            fillColor: Colors.grey,
                                            disabledBorder: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Reserved Beds: '),
                                    Spacer(),
                                    Container(
                                      width: 110,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      child: (currentReservation != null &&
                                              currentReservation!.reservedBeds.length > 0)
                                          ? Container(
                                              padding: EdgeInsets.only(top: 3),
                                              height: 20,
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount:
                                                      currentReservation!.reservedBeds.length,
                                                  itemBuilder: (context, index) => Text(
                                                      '${currentReservation!.reservedBeds[index]}')),
                                            )
                                          : Text('No bed reserved'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Booking Date: '),
                                    Spacer(),
                                    Text('$newBookedDate'),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation: MaterialStatePropertyAll(10),
                                          backgroundColor: MaterialStatePropertyAll(Colors.white)),
                                      onPressed: () async {
                                        DateTime? newDate = await selectDate();
                                        if (newDate != null) {
                                          setState(() {
                                            newBookedDate =
                                                DateFormat('EEEE, d MMM, yyyy').format(newDate);
                                          });
                                        }
                                      },
                                      child: Text('Change Date'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Check In: '),
                                    Spacer(),
                                    Text('$newCheckIn'),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation: MaterialStatePropertyAll(10),
                                          backgroundColor: MaterialStatePropertyAll(Colors.white)),
                                      onPressed: () async {
                                        DateTime? newDate = await selectDate();
                                        if (newDate != null) {
                                          setState(() {
                                            newCheckIn =
                                                DateFormat('EEEE, d MMM, yyyy').format(newDate);
                                          });
                                        }
                                      },
                                      child: Text('Change Date'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('Check Out: '),
                                    Spacer(),
                                    Text('$newCheckOut'),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation: MaterialStatePropertyAll(10),
                                          backgroundColor: MaterialStatePropertyAll(Colors.white)),
                                      onPressed: () async {
                                        DateTime? newDate = await selectDate();
                                        if (newDate != null) {
                                          setState(() {
                                            newCheckOut =
                                                DateFormat('EEEE, d MMM, yyyy').format(newDate);
                                          });
                                        }
                                      },
                                      child: Text('Change Date'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('Real Time Check in: ')),
                                    Spacer(),
                                    Text('$newPhysicalCheckIn'),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation: MaterialStatePropertyAll(10),
                                          backgroundColor: MaterialStatePropertyAll(Colors.white)),
                                      onPressed: () async {
                                        DateTime? newDate = await selectDate();
                                        if (newDate != null) {
                                          setState(() {
                                            newPhysicalCheckIn =
                                                DateFormat('EEEE, d MMM, yyyy').format(newDate);
                                          });
                                        }
                                      },
                                      child: Text('Change Date'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('Real Time Check out: ')),
                                    Spacer(),
                                    Text('$newPhysicalCheckOut'),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation: MaterialStatePropertyAll(10),
                                          backgroundColor: MaterialStatePropertyAll(Colors.white)),
                                      onPressed: () async {
                                        DateTime? newDate = await selectDate();
                                        if (newDate != null) {
                                          setState(() {
                                            newPhysicalCheckOut =
                                                DateFormat('EEEE, d MMM, yyyy').format(newDate);
                                          });
                                        }
                                      },
                                      child: Text('Change Date'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Center(
                  child: Container(
                      width: 120,
                      height: 50,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.orange))),
                          ),
                          onPressed: () {
                            nights = (DateFormat('EEEE, d MMM, yyyy')
                                        .parse(newCheckOut)
                                        .difference(
                                            DateFormat('EEEE, d MMM, yyyy').parse(newCheckIn))
                                        .inHours /
                                    24)
                                .round();
                            // print(nights);
                            if (nights == 0) {
                              nights = 1;
                            }
                            if (currentReservation != null) {
                              ReservationModel updatedReservation = ReservationModel(
                                  note_tec.text.isEmpty ? '' : note_tec.text,
                                  DateFormat('EEEE, d MMM, yyyy').parse(newPhysicalCheckIn),
                                  DateFormat('EEEE, d MMM, yyyy').parse(newPhysicalCheckOut),
                                  currentReservation!.reservedBeds,
                                  totalPrice: totalPrice_tec.text.isEmpty
                                      ? totalPrice!
                                      : double.parse(totalPrice_tec.text),
                                  roomPrice: totalPrice != null && nights != null
                                      ? totalPrice! / nights!
                                      : 0,
                                  guestName: currentReservation!.guestName,
                                  checkIn: DateFormat('EEEE, d MMM, yyyy').parse(newCheckIn),
                                  checkout: DateFormat('EEEE, d MMM, yyyy').parse(newCheckOut),
                                  nights: nights != null ? nights! : 1,
                                  room: roomNameValue,
                                  bookedFrom: bookedFromValue,
                                  guestsCount: nOfGs_tec.text.isEmpty
                                      ? numberOfGuests!
                                      : int.parse(nOfGs_tec.text),
                                  bookingDate: newBookedDate,
                                  commission: commission_tec.text.isEmpty
                                      ? currentReservation!.commission
                                      : double.parse(commission_tec.text),
                                  status: statusValue,
                                  fullyPaid: currentReservation!.fullyPaid);
                              Provider.of<ReservationManager>(context, listen: false)
                                  .changeReservation(currentReservation, updatedReservation);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text('Reservation Updated'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () => Navigator.pop(context), child: Text('OK'))
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text('Change Info'))))
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2123),
    );
    return date;
  }
}
// ToDo: reserved beds shown as checkBox
