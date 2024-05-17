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
  static const List<String> list = <String>['Daily', 'Rent', 'Electricity', 'Water','Internet'];
  String _dDValue = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width - 10,
              margin: EdgeInsets.all(15),
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
              child: DropdownButton(
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
