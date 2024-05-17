import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';
class ServicesScreen extends StatefulWidget {
  final List<Guest> suggestions;
  const ServicesScreen({super.key, required this.suggestions});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  DateTime dateTime = DateTime.now();
  TextEditingController description_TEC = TextEditingController();
  TextEditingController amount_TEC = TextEditingController();
  TextEditingController guestNameTEC = TextEditingController();
  FocusNode node1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                color: Colors.orange,
                              )),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
                    child: Text('New Service'),
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                color: Colors.orange,
                              )),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                      ))
                ],
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
              child: Row(
                children: [
                  Spacer(),
                  Text(DateFormat('EEEE, d MMM, yyyy').format(dateTime).toString()),
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
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 10, right: 5, bottom: 5),
              width: MediaQuery.of(context).size.width - 10,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
              child: TextField(
                controller: description_TEC,
                decoration: InputDecoration(border: InputBorder.none, label: Text('Descriptions')),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              padding: EdgeInsets.only(left: 10, right: 5, bottom: 5),
              width: MediaQuery.of(context).size.width - 10,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
              child: TextField(
                controller: amount_TEC,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none, label: Text('Amount')),
              ),
            ),
            Container(
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
                    for (int i = 0; i< widget.suggestions.length; i++)
                      matches.add(widget.suggestions[i].name);
                    matches.retainWhere((s) {
                      return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                    return matches;
                  }
                },
                onSelected: (String selection) async {
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
            Row(children: [
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () async {
                  print(dateTime);
                  if (amount_TEC.text.isNotEmpty &&
                      description_TEC.text.isNotEmpty && guestNameTEC.text.isNotEmpty) {
                    Services service = Services(
                        amount: double.parse(amount_TEC.text),
                        note: description_TEC.text,
                        dateTime: dateTime,
                    costumerName: guestNameTEC.text
                    );
                    Provider.of<ServicesManager>(context, listen: false).addService(service);
                    ScaffoldMessenger.of(context).showSnackBar(
                        new SnackBar(content: new Text('Service saved')));
                    setState(() {
                      dateTime = DateTime.now();
                      description_TEC.clear();
                      amount_TEC.clear();
                      guestNameTEC.clear();
                    });
                  }
                },
                child: Text('Save'),
              ),
              Spacer(),
            ]),
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
        dateTime = date;
      });
    }
  }
}