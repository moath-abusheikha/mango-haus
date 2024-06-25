import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';

class ReservationsReport extends StatefulWidget {
  const ReservationsReport({super.key});

  @override
  State<ReservationsReport> createState() => _ReservationsReportState();
}

class _ReservationsReportState extends State<ReservationsReport> {
  ReservationManager _reservationManager = ReservationManager();
  DateTimeRange? selectedDate;
  DateTime startCheckInDate = DateTime.now(),
      endCheckInDate = DateTime.now().add(Duration(days: 1));
  bool showFilter = false;
  List<String> roomNames = ['Room Name', 'Alfonso', 'Mallika', 'Kent', 'Tent'],
      allStatus = ['Status', 'Reserved', 'Checked In', 'Checked Out', 'Cancelled'];
  String roomName = 'Room Name', status = 'Status';
  String? guestName;
  List<Guest> guests = [];
  TextEditingController guestNameTEC = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  Guest? guest;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
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
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Reservation Report',
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
                        setState(() {
                          selectedDate = dateTimeRange;
                          startCheckInDate = selectedDate!.start;
                          endCheckInDate = selectedDate!.end;
                        });
                      }
                    },
                    child: Text(
                      '${DateFormat('EEEE, d MMM, yyyy').format(startCheckInDate)} - ${DateFormat('EEEE, d MMM, yyyy').format(endCheckInDate)}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
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
                        Text('Filter'),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                showFilter = !showFilter;
                                if (showFilter == false) {
                                  roomName = 'Room Name';
                                  status = 'Status';
                                  guestName = null;
                                }
                              });
                            },
                            icon: Icon(Icons.keyboard_double_arrow_right)),
                      ],
                    ),
                  ),
                  showFilter
                      ? Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 60,
                                  child: FutureBuilder(
                                    future: Provider.of<GuestManager>(context, listen: false)
                                        .getAllGuests(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        guests = snapshot.data!;
                                      }
                                      return Container(
                                        padding: EdgeInsets.only(left: 5),
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15.0),
                                            border:
                                                Border.all(color: Colors.orangeAccent, width: 1),
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
                                          focusNode: focusNode1,
                                          optionsBuilder: (TextEditingValue textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              return const Iterable<String>.empty();
                                            } else {
                                              List<String> matches = <String>[];
                                              for (int i = 0; i < guests.length; i++)
                                                matches.add(guests[i].name);
                                              matches.retainWhere((s) {
                                                return s
                                                    .toLowerCase()
                                                    .contains(textEditingValue.text.toLowerCase());
                                              });
                                              return matches;
                                            }
                                          },
                                          onSelected: (String selection) async {
                                            // print('You just selected $selection');
                                            guest = await Provider.of<GuestManager>(context,
                                                    listen: false)
                                                .getGuest(selection.toLowerCase().trim());
                                            setState(() {
                                              guestName = guest!.name;
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
                                                border: InputBorder.none,
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (BuildContext context,
                                              void Function(String) onSelected,
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
                                                                padding: const EdgeInsets.only(
                                                                    right: 60),
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
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      width: 100,
                                      height: 50,
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
                                      child: DropdownButton<String>(
                                        underline: const SizedBox(),
                                        value: roomName,
                                        items: roomNames
                                            .map<DropdownMenuItem<String>>((String? value) {
                                          return DropdownMenuItem<String>(
                                            value: value!,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            roomName = value!;
                                          });
                                        },
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      width: 100,
                                      height: 50,
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
                                      child: DropdownButton<String>(
                                        underline: const SizedBox(),
                                        value: status,
                                        items: allStatus
                                            .map<DropdownMenuItem<String>>((String? value) {
                                          return DropdownMenuItem<String>(
                                            value: value!,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            status = value!;
                                          });
                                        },
                                      ),
                                    )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(
                    future: Future.wait([
                      _reservationManager.getReservationsWithFilter(
                          startCheckInDate, endCheckInDate, roomName, status, guestName)
                    ]),
                    builder: (context, snapshot) {
                      List<DataRow> dataRows = [];
                      if (snapshot.data != null)
                        for (int i = 0; i < snapshot.data!.length; i++) {
                          DataRow dataRow = DataRow(cells: [
                            DataCell(
                              Center(
                                  child: Text(
                                snapshot.data![0].elementAt(i).guestName,
                                textAlign: TextAlign.center,
                              )),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${DateFormat('EEEE, d MMM, yyyy').format(snapshot.data![0].elementAt(i).checkIn)} - ${DateFormat('EEEE, d MMM, yyyy').format(snapshot.data![0].elementAt(i).checkout)}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${snapshot.data![0].elementAt(i).nights}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${snapshot.data![0].elementAt(i).guestsCount}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text(snapshot.data![0].elementAt(i).room,
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${snapshot.data![0].elementAt(i).totalPrice}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${snapshot.data![0].elementAt(i).status}',
                                      textAlign: TextAlign.center)),
                            ),
                          ]);
                          dataRows.add(dataRow);
                        }
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              decoration: BoxDecoration(
                                  color: Colors.white,
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
                              border: TableBorder.all(width: 2, color: Colors.black),
                              columnSpacing: 10.0,
                              columns: [
                                DataColumn(label: Text('Guest Name')),
                                DataColumn(label: Text('Staying Dates')),
                                DataColumn(label: Text('Nights')),
                                DataColumn(label: Text('Number of Guests')),
                                DataColumn(label: Text('Room')),
                                DataColumn(label: Text('Total Price')),
                                DataColumn(label: Text('Status')),
                              ],
                              rows: dataRows),
                        );
                      } else
                        return Container(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: const [
                              Text('getting your data'),
                              Expanded(
                                  child: LinearProgressIndicator(
                                color: Colors.black,
                              ))
                            ],
                          ),
                        );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
