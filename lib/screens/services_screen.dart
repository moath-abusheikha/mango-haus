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
                    'Services',
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
                height: 45,
                width: MediaQuery.of(context).size.width - 10,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
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
                child: Row(
                  children: [
                    Spacer(),
                    Text(DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()).toString()),
                    Spacer(),
                    Container(
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
                              BoxShadow(
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(-2, -2),
                                  color: Colors.white,
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
                        child: GestureDetector(
                          onTap: () => selectDate(),
                          child: Text('change date'),
                        )),
                    Spacer()
                  ],
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
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
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: description_TEC,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      label: Center(
                        child: Text(
                          'Descriptions',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 45,
                padding: EdgeInsets.only(left: 10, right: 5, bottom: 5),
                width: MediaQuery.of(context).size.width - 10,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
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
                  child: GestureDetector(
                    child: Center(child: Text('Save Service')),
                    onTap: () async {
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
                  ),
                ),
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
        dateTime = date;
      });
    }
  }
}