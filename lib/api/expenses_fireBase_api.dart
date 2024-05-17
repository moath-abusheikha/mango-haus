import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateExpense(Expenses expense) async {
    final doc = FirebaseFirestore.instance.collection('expenses').doc();
    await doc.update({});
  }
}
