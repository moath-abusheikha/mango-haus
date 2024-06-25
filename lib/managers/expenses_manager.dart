import 'package:flutter/material.dart';
import 'package:mango_haus/models/models.dart';
import '../api/api.dart';

class ExpensesManager extends ChangeNotifier {
  final ExpensesFireBaseApi fireBaseApi = ExpensesFireBaseApi();

  Future<void> addExpense(Expenses expense) async {
    fireBaseApi.addExpense(expense);
    notifyListeners();
  }

  void removeExpense(Expenses expense) async{
    fireBaseApi.deleteExpense();
    notifyListeners();
  }

  Future<Expenses?> getExpenseByDate(DateTime date) async {
    Expenses? expense = await fireBaseApi.getExpense();
    notifyListeners();
    return expense;
  }
  Future<List<Expenses>> getFilteredExpenses(DateTime? startDate, DateTime? endDate) async {
    List<Expenses> allExpenses = await fireBaseApi.filteredExpenses(startDate, endDate);
    notifyListeners();
    return allExpenses;
  }
  Future<List<Expenses>> getExpenses() async {
    List<Expenses> allExpenses = await fireBaseApi.getAllExpenses();
    notifyListeners();
    return allExpenses;
  }

  void updateExpense(Expenses expense) async {
    await fireBaseApi.updateExpense(expense);
    notifyListeners();
  }
}
