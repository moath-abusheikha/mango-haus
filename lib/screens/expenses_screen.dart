import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/expense.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  DateTime dateTime = DateTime.now();
  TextEditingController description_TEC = TextEditingController();
  TextEditingController amount_TEC = TextEditingController();
  static const List<String> list = <String>['Daily', 'Rent', 'Electricity', 'Water', 'Internet'];
  String
  _dDValue = 'Daily';

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
                    'Expenses',
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
                child: DropdownButton(
                  alignment: Alignment.center,
                  underline: Container(),
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _dDValue = value!;
                    });
                  },
                  value: _dDValue,
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
                    child: Center(child: Text('Save Expense')),
                    onTap: () async {
                      if (amount_TEC.text.isNotEmpty) {
                        Expenses expense = Expenses(
                            amount: double.parse(amount_TEC.text),
                            description: description_TEC.text,
                            type: _dDValue,
                            date: dateTime);
                        Provider.of<ExpensesManager>(context, listen: false).addExpense(expense);
                        description_TEC.clear();
                        amount_TEC.clear();
                        _dDValue = 'Daily';
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
