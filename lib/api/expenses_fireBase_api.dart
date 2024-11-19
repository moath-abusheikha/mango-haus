import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/material/slider_theme.dart';
import 'package:mango_haus/models/models.dart';

class ExpensesFireBaseApi {
  Future<Expenses?> getExpense() async {
    Expenses? expense;
    DocumentReference guestRef = await FirebaseFirestore.instance.collection('expenses').doc();
    await guestRef.get().then((snapshot) {
      var data = snapshot.data();
      String encode = jsonEncode(data);
      Map<String, dynamic> map = jsonDecode(encode);
      expense = Expenses.fromMap(map);
    });
    return expense;
  }

  Future<List<Expenses>> filteredExpenses(DateTime? startDate, DateTime? endDate) async {
    List<Expenses>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("expenses")
        .orderBy('date', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      Expenses expenses = Expenses.fromMap(element);
      if (startDate != null && endDate != null) if (expenses.date
              .isAfter(startDate.subtract(Duration(days: 1))) &&
          expenses.date.isBefore(endDate.add(Duration(days: 1)))) {
        allDocs.add(expenses);
      }
    });
    return allDocs;
  }

  Future<List<Expenses>> specificExpense(
      DateTime? startDate, DateTime? endDate, List<String>? types, RangeValues rangeValues) async {
    if (startDate == null) startDate = DateTime(2021, 1, 1);
    if (endDate == null) endDate = DateTime.now();
    if (types == null || types.isEmpty)
      types = <String>['Daily', 'Rent', 'Electricity', 'Water', 'Internet'];
    // print('$startDate -- $endDate -- $types -- $rangeValues');
    List<Expenses>? allDocs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("expenses")
        .orderBy('date', descending: false)
        .get();
    Iterable a = querySnapshot.docs.map((doc) => doc.data()).toList();
    a.forEach((element) {
      Expenses expense = Expenses.fromMap(element);
      // Todo : filter according nulls
      if (startDate != null && endDate != null && types != null) if (expense.date
              .isAfter(startDate.subtract(Duration(days: 1))) &&
          expense.date.isBefore(endDate.add(Duration(days: 1))) &&
          expense.amount >= rangeValues.start &&
          expense.amount <= rangeValues.end &&
          types.contains(expense.type)) {
        allDocs.add(expense);
      }
    });
    return allDocs;
  }

  Future<List<Expenses>> getAllExpenses() async {
    List<Expenses> allDocs = [];
    await FirebaseFirestore.instance
        .collection("expenses")
        .orderBy('date', descending: false)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          allDocs.add(Expenses.fromMap(docSnapshot.data()));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return allDocs;
  }

  void addExpense(Expenses expense) async {
    final doc = await FirebaseFirestore.instance.collection('expenses').doc();
    final json = expense.toMap();
    await doc.set(json);
  }

  void deleteExpense() async {
    final docs = await FirebaseFirestore.instance.collection('expenses').doc().get();
    FirebaseFirestore.instance
        .runTransaction((transaction) async => await transaction.delete(docs.reference));
  }

  Future<void> updateExpense(Expenses expense, Expenses editedExpense) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection('expenses')
          .get()
          .then((QuerySnapshot snapshot) {
        DocumentReference? elementReference;
        snapshot.docs.forEach((element) {
          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          Expenses expenses = Expenses.fromMap(map);
          if (expenses.amount == expense.amount &&
              expenses.description == expense.description &&
              expenses.date == expense.date &&
              expenses.type == expense.type) elementReference = element.reference;
        });
        return elementReference;
      });
      var batch = FirebaseFirestore.instance.batch();
      batch.update(post!, {
        'amount': editedExpense.amount,
        'date': editedExpense.date,
        'description': editedExpense.description,
        'type': editedExpense.type
      });
      batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
