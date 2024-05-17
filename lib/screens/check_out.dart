import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../api/guest_fire_base_api.dart';
import '../managers/managers.dart';
import '../models/models.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  GuestFireBaseApi fireBaseApi = GuestFireBaseApi();
  GlobalKey key = GlobalKey();
  List<String> suggestions = [];
  static const List<String> workers = ['معاذ', 'سيف'];
  TextEditingController guestName_TEC = TextEditingController();
  FocusNode node1 = FocusNode();
  String checkInOutDate = 'check in Date - check out date', dropDownValue = workers.first;
  TextEditingController note_TEC = TextEditingController();
  DateTime checkoutDate = DateTime.now();
  ReservationModel? booking;

  @override
  void initState() {
    getAllGuests();
    super.initState();
  }

  void getAllGuests() async {
    List<Guest> guests = await fireBaseApi.getAllGuests();
    for (int i = 0; i < guests.length; i++) {
      suggestions.add(guests[i].name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out'),
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
                textEditingController: guestName_TEC,
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
                  // booking = await Provider.of<ReservationManager>(context, listen: false)
                  //    false .getReservationByName(selection);
                  setState(() {
                    checkInOutDate = '${booking?.checkIn} - ${booking?.checkout}';
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
              height: 45,
              width: MediaQuery.of(context).size.width - 10,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
              child: Center(
                  child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      child: Text(checkInOutDate))),
            ),
            Row(
              children: [
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
                      Text(DateFormat('EEEE, d MMM, yyyy').format(checkoutDate).toString()),
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
                      Spacer()
                    ],
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
              width: 100,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.orange))),
                ),
                child: Text('Check Out'),
                onPressed: () {
                  if (guestName_TEC.text.isNotEmpty) {
                    String actualCheckoutDate =
                        DateFormat('EEEE, d MMM, yyyy').format(checkoutDate).toString();
                    if (actualCheckoutDate != booking?.checkout) {
                      DateTime checkout = DateFormat('EEEE, d MMM, yyyy') as DateTime;//.parse(booking!.checkout);
                      int days = (checkoutDate.difference(checkout).inHours / 24).floor();
                      booking?.nights += days;
                    }
                    Provider.of<ReservationManager>(context, listen: false).updateReservation(booking);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(new SnackBar(content: new Text('* checked out')));//*${booking?.guestName}
                    setState(() {
                      guestName_TEC.clear();
                      checkInOutDate = 'check in Date - check out date';
                      checkoutDate = DateTime.now();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        new SnackBar(content: new Text('guest name cannot be empty')));
                  }
                },
              ),
            ),
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
        checkoutDate = date;
      });
    }
  }
}
