import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mango_haus/managers/managers.dart';
import '../models/models.dart';

class ExtendStaying extends StatefulWidget {
  final List<Guest> suggestions;

  const ExtendStaying({required this.suggestions, super.key});

  @override
  State<ExtendStaying> createState() => _ExtendStayingState();
}

class _ExtendStayingState extends State<ExtendStaying> {
  Guest? guest;
  TextEditingController guestNameTEC = TextEditingController();
  TextEditingController roomPriceTEC = TextEditingController();
  FocusNode focusNode = FocusNode();
  ReservationModel? lastReservation;
  DateTime? checkOut;
  String extendedCheckoutDate = 'Extend check out date';
  String guestName = 'guest name';
  double roomPrice = 0, totalPrice = 0;
  int nights = 0, numberOfGuests = 0;
  DateFormat format = new DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extend Staying'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
              child: RawAutocomplete(
                textEditingController: guestNameTEC,
                focusNode: focusNode,
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
                  // lastReservation = await Provider.of<ReservationManager>(context, listen: false)
                  //     .getGuestTodayReservation(selection.toLowerCase().trim());
                  // guestName = lastReservation!.guestName;
                  // checkOut = format.parse(lastReservation!.checkout);
                  numberOfGuests = lastReservation!.guestsCount;
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
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
              child: Column(
                children: [
                  Text('Guest Info'),
                  Text('name: $guestName'),
                  checkOut != null
                      ? Text(
                          'check out: ${DateFormat('EEEE, d MMM, yyyy').format(checkOut!).toString()}')
                      : Text('check out date')
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
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text('Extend to: $extendedCheckoutDate'),
                  Spacer(),
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.orange))),
                      ),
                      onPressed: () => selectDate(),
                      child: Text('Choose date'))
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
                child: Row(children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text('Extended Nights: $nights'),
                  SizedBox(
                    width: 10,
                  ),
                  Text('total price $totalPrice'),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(15.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              roomPrice = 0.0;
                              roomPriceTEC.text = '';
                            } else {
                              setState(() {
                                roomPrice = double.parse(value);
                                // if (lastReservation?.room.toLowerCase() == 'kent' ||
                                //     lastReservation?.room.toLowerCase() == 'tent') {
                                //   totalPrice = roomPrice * nights;
                                // } else
                                //   totalPrice = roomPrice * nights * numberOfGuests;
                              });
                            }
                          });
                        },
                        controller: roomPriceTEC,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Room Price',
                        ),
                      ),
                    ),
                  ),
                ])),
          ],
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
        extendedCheckoutDate = DateFormat('EEEE, d MMM, yyyy').format(date).toString();
        if (checkOut != null) nights = int.parse(date.difference(checkOut!).toString());
      });
    }
  }
}
