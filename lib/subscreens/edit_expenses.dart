import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mango_haus/managers/managers.dart';
import '../models/models.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({super.key});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  DateTime? date1, date2, changedDate;
  TextEditingController editedExpenseText_ctrl = TextEditingController();
  TextEditingController editedExpenseAmount_ctrl = TextEditingController();
  RangeValues rangeValues = RangeValues(1, 500);
  static const List<String> list = <String>['Daily', 'Rent', 'Electricity', 'Water', 'Internet'];
  List<bool> listValues = List.generate(list.length, (index) => false);
  List<Expenses>? filteredExpenses;
  String _dDValue = 'Daily';
  Expenses? selectedExpense;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height + 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange, Colors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.5, 0.9],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Edit Expenses',
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
                child: Row(
                  children: [
                    Spacer(),
                    Text('Date Between:'),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        DateTime? dateTime1 = await selectDate();
                        setState(() {
                          date1 = dateTime1;
                        });
                      },
                      child: Container(
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
                                  offset: Offset(-1, -1),
                                  color: Colors.orange.shade100,
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
                        child: date1 == null
                            ? Text('change date')
                            : Text(DateFormat('EEEE, d MMM, yyyy').format(date1!).toString()),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        DateTime? dateTime2 = await selectDate();
                        setState(() {
                          date2 = dateTime2;
                        });
                      },
                      child: Container(
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
                                  offset: Offset(-1, -1),
                                  color: Colors.orange.shade100,
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
                        child: date2 == null
                            ? Text('change date')
                            : Text(DateFormat('EEEE, d MMM, yyyy').format(date2!).toString()),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount Range:'),
                    RangeSlider(
                        values: rangeValues,
                        min: 1,
                        max: 500,
                        divisions: 50,
                        labels: RangeLabels('${rangeValues.start}', '${rangeValues.end}'),
                        onChanged: (_rangeValues) {
                          setState(() {
                            rangeValues = _rangeValues;
                          });
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('Expense Type:'),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Checkbox(
                              value: listValues[index],
                              onChanged: (value) {
                                setState(() {
                                  listValues[index] = value!;
                                });
                              }),
                          Text(list[index]),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    List<String> selectedTypes = List.generate(list.length, (index) => '-');
                    for (int i = 0; i < listValues.length; i++) {
                      if (listValues[i] == true) selectedTypes[i] = (list[i]);
                    }
                    selectedTypes = selectedTypes.where((element) => element != '-').toList();
                    List<Expenses> expensesResult =
                        await Provider.of<ExpensesManager>(context, listen: false)
                            .getExpenses(date1, date2, selectedTypes, rangeValues);
                    setState(() {
                      filteredExpenses = expensesResult;
                    });
                  },
                  child: Container(
                    width: 120,
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
                              offset: Offset(-1, -1),
                              color: Colors.orange.shade100,
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
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        Spacer(),
                        Text(
                          'Search',
                          style: TextStyle(fontSize: 25),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 260,
                decoration: BoxDecoration(border: Border.all()),
                child: GridView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                  clipBehavior: Clip.antiAlias,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisExtent: 95),
                  itemCount: filteredExpenses?.length != null ? filteredExpenses?.length : 0,
                  itemBuilder: (context, index) {
                    var expense = filteredExpenses?[index];
                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedExpense = expense;
                        if (selectedExpense != null) {
                          changedDate = selectedExpense?.date;
                          _dDValue = selectedExpense!.type;
                        }
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
                              'Date: ${DateFormat('EEEE, d MMM, yyyy').format(expense!.date).toString()}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Amount: ${expense.amount}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Type: ${expense.type}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Description: ${expense.description}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              selectedExpense == null
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Center(child: Text('Date')),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? tempChangedDate = await selectDate();
                                  setState(() {
                                    changedDate = tempChangedDate;
                                  });
                                },
                                child: Container(
                                  height: 40,
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
                                            offset: Offset(-1, -1),
                                            color: Colors.orange.shade100,
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
                                  child: changedDate == null
                                      ? Center(
                                          child: Text(
                                              '${DateFormat('EEEE, d MMM, yyyy').format(selectedExpense!.date).toString()}'))
                                      : Center(
                                          child: Text(
                                              '${DateFormat('EEEE, d MMM, yyyy').format(changedDate!).toString()}'),
                                        ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          Row(
                            children: [
                              Center(child: Text('Type')),
                              Spacer(),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.only(left: 10, right: 3),
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
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text('Description'),
                              SizedBox(
                                width: 40,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: editedExpenseText_ctrl,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: selectedExpense?.description.toString(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text('Amount'),
                              SizedBox(
                                width: 58,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: editedExpenseAmount_ctrl,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: selectedExpense?.amount.toString(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (changedDate == null) changedDate == selectedExpense?.date;
                              if (editedExpenseAmount_ctrl.text.isEmpty)
                                editedExpenseAmount_ctrl.text = selectedExpense!.amount.toString();
                              if (editedExpenseText_ctrl.text.isEmpty)
                                editedExpenseText_ctrl.text = selectedExpense!.description;
                              Expenses editedExpense = Expenses(
                                  date: changedDate!,
                                  description: editedExpenseText_ctrl.text,
                                  type: _dDValue,
                                  amount: double.parse(editedExpenseAmount_ctrl.text));
                              Provider.of<ExpensesManager>(context, listen: false)
                                  .updateExpense(selectedExpense!, editedExpense);
                              // show message of complete
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text('Expense Changed Successfully'),
                                  title: Text('Success'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedExpense = null;
                                            editedExpenseText_ctrl.clear();
                                            editedExpenseAmount_ctrl.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'))
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              margin: EdgeInsets.only(bottom: 20),
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
                                        offset: Offset(-1, -1),
                                        color: Colors.orange.shade100,
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
                              child: Center(
                                child: Text('Edit Data'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
