import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';

class EditService extends StatefulWidget {
  final List<Guest> suggestions;

  const EditService({required this.suggestions, super.key});

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  TextEditingController serviceAmount = TextEditingController();
  TextEditingController serviceCustomer = TextEditingController();
  TextEditingController serviceNote = TextEditingController();

  List<Services>? result;
  Guest? guest;
  DateTime? firstDate, lastDate, editedDate;
  TextEditingController guestNameTEC = TextEditingController();
  FocusNode node1 = FocusNode();
  RangeValues rangeValues = RangeValues(0, 300);
  bool editSelectedItem = false;
  Services? selectedService;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
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
                    'Edit Service',
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Center(child: Text('Date Between'))),
                        Spacer(),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                DateTime? pickedDate = await selectDate();
                                setState(() {
                                  firstDate = pickedDate;
                                });
                              },
                              child: firstDate == null
                                  ? Text('Change Date')
                                  : Text('${DateFormat('EEEE, d MMM, yyyy').format(firstDate!)}'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                DateTime? pickedDate = await selectDate();
                                setState(() {
                                  lastDate = pickedDate;
                                });
                              },
                              child: lastDate == null
                                  ? Text('Change Date')
                                  : Text('${DateFormat('EEEE, d MMM, yyyy').format(lastDate!)}'),
                            ),
                          ],
                        ),
                        Spacer(),
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
                          var selectedGuest =
                              await Provider.of<GuestManager>(context, listen: false)
                                  .getGuest(selection);
                          setState(() {
                            guest = selectedGuest;
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
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          child: Center(child: Text('Amount Range')),
                        ),
                        Spacer(),
                        Container(
                          width: 250,
                          child: RangeSlider(
                            values: rangeValues,
                            max: 300,
                            divisions: 30,
                            labels: RangeLabels(
                              rangeValues.start.round().toString(),
                              rangeValues.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                rangeValues = values;
                              });
                            },
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Center(
                      child: Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () async {
                            List<Services>? services = await Provider.of<ServicesManager>(context,
                                    listen: false)
                                .getFilteredServices(firstDate, lastDate, guest?.name, rangeValues);
                            setState(() {
                              result = services;
                            });
                          },
                          child: Center(
                            child: Text('Search'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), // filter section
              Container(
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(border: Border.all()),
                  child: GridView.builder(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                    clipBehavior: Clip.antiAlias,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisExtent: 110),
                    itemCount: result?.length != null ? result?.length : 0,
                    itemBuilder: (context, index) {
                      var service = result?[index];
                      return GestureDetector(
                        onTap: () => setState(() {
                          editSelectedItem = true;
                          selectedService = service;
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                            boxShadow: [
                              BoxShadow(
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(0, 1),
                                  color: Colors.black,
                                  blurRadius: 10,
                                  spreadRadius: 2),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${DateFormat('EEEE, d MMM, yyyy').format(service!.dateTime).toString()}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Amount: ${service.amount}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Customer Name: ${service.customerName}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Note: ${service.note}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ), // filtered result
              !editSelectedItem
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 120,
                                child: Center(
                                  child: Text('Amount'),
                                ),
                              ),
                              Expanded(
                                  child: TextField(
                                controller: serviceAmount,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: selectedService?.amount.toString(),
                                ),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 120,
                                child: Center(
                                  child: Text('Guest Name'),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: serviceCustomer,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: selectedService?.customerName.toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 120,
                                child: Center(
                                  child: Text('Note'),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: serviceNote,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: selectedService?.note.toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 120,
                                child: Center(
                                  child: Text('Date'),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      DateTime? temp = await selectDate();
                                      setState(() {
                                        editedDate = temp;
                                      });
                                    },
                                    child: editedDate == null
                                        ? Text('Change Date')
                                        : Text(DateFormat('EEEE, d MMM, yyyy')
                                            .format(editedDate!)
                                            .toString())),
                              ),
                            ],
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Services updatedService = Services(
                                    dateTime: editedDate == null
                                        ? selectedService!.dateTime
                                        : editedDate!,
                                    note: serviceNote.text.isEmpty
                                        ? selectedService!.note
                                        : serviceNote.text,
                                    customerName: serviceCustomer.text.isEmpty
                                        ? selectedService!.customerName
                                        : serviceCustomer.text,
                                    amount: serviceAmount.text.isEmpty
                                        ? selectedService!.amount
                                        : double.parse(serviceAmount.text));
                                Provider.of<ServicesManager>(context, listen: false)
                                    .updateService(selectedService!, updatedService);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text('Service Changed Successfully'),
                                    title: Text('Success'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedService = null;
                                              serviceNote.clear();
                                              serviceCustomer.clear();
                                              serviceAmount.clear();
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok'))
                                    ],
                                  ),
                                );
                              },
                              child: Text('Edit Service'),
                            ),
                          ),
                        ],
                      ),
                    ), // edit selected item
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
        firstDate: DateTime(2021),
        lastDate: DateTime(2123));
    return date;
  }
}
