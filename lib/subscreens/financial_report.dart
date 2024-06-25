import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';

class FinancialReport extends StatefulWidget {
  const FinancialReport({
    super.key,
  });

  @override
  State<FinancialReport> createState() => _FinancialReportState();
}

class _FinancialReportState extends State<FinancialReport> {
  DateTime? startDate, endDate;
  DateTimeRange? selectedDate;
  String? guestName;
  List<ReservationModel?> reservations = [];
  List<Services?> services = [];
  List<Expenses?> expenses = [];
  List<Map<String, Object>> totals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Report'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, color: Colors.orangeAccent),
                  TextButton(
                    onPressed: () async {
                      DateTimeRange? dateTimeRange = await showDateRangePicker(
                          initialDateRange:
                              DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                          context: context,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2030));
                      if (dateTimeRange != null) {
                        setState(() {
                          selectedDate = dateTimeRange;
                          startDate = selectedDate!.start;
                          endDate = selectedDate!.end;
                        });
                      }
                    },
                    child: startDate != null && endDate != null
                        ? Text(
                            '${DateFormat('EEEE, d MMM, yyyy').format(startDate!)} - ${DateFormat('EEEE, d MMM, yyyy').format(endDate!)}',
                            style: TextStyle(color: Colors.black),
                          )
                        : Text('Choose Date Range'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(
                    future: Future.wait([
                      Provider.of<ReservationManager>(context, listen: false)
                          .filteredReservationsWith2DatesStatus(startDate, endDate, 'checkedOut'),
                      Provider.of<ServicesManager>(context, listen: false)
                          .getFilteredServices(startDate, endDate, null),
                      Provider.of<ExpensesManager>(context, listen: false)
                          .getFilteredExpenses(startDate, endDate),
                    ]),
                    builder: (context, snapshot) {
                      reservations.clear();
                      services.clear();
                      expenses.clear();
                      if (!snapshot.hasData)
                        return Center(child: Text('No data found your filter'));
                      else if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        for (int i = 0; i < snapshot.data!.elementAt(0).length; i++) {
                          ReservationModel? reservation =
                              snapshot.data?.elementAt(0).elementAt(i) as ReservationModel?;
                          reservations.add(reservation);
                        }
                        for (int i = 0; i < snapshot.data!.elementAt(1).length; i++) {
                          Services? service = snapshot.data?.elementAt(1).elementAt(i) as Services?;
                          services.add(service);
                        }
                        for (int i = 0; i < snapshot.data!.elementAt(2).length; i++) {
                          Expenses? expense = snapshot.data?.elementAt(2).elementAt(i) as Expenses?;
                          expenses.add(expense);
                        }
                        if (startDate != null && endDate != null) {
                          totals =
                              getTotals(reservations, services, expenses, startDate!, endDate!);
                        }
                      }
                      List<DataRow> dataRows = [];
                      if (totals.isNotEmpty)
                        for (int i = 0; i < totals.length; i++) {
                          DataRow dataRow = DataRow(cells: [
                            DataCell(
                              Center(
                                  child: Text(
                                '${totals[i]['month']}',
                                textAlign: TextAlign.center,
                              )),
                            ),
                            DataCell(
                              Center(
                                  child:
                                      Text('${totals[i]['revenue']}', textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${totals[i]['commission']}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child:
                                      Text('${totals[i]['daily']}', textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${totals[i]['rent']}', textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child:
                                      Text('${totals[i]['water']}', textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${totals[i]['electricity']}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${totals[i]['internet']}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text('${totals[i]['services']}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child:
                                      Text('${totals[i]['nights']}', textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${(double.parse(totals[i]['nights'].toString()) / 360).toStringAsPrecision(2)}',
                                      textAlign: TextAlign.center)),
                            ),
                          ]);
                          dataRows.add(dataRow);
                        }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            border: TableBorder.all(width: 2, color: Colors.orange),
                            columnSpacing: 10.0,
                            columns: [
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Room Revenue')),
                              DataColumn(label: Text('Commissions')),
                              DataColumn(label: Text('Daily Expenses')),
                              DataColumn(label: Text('Rent')),
                              DataColumn(label: Text('Water')),
                              DataColumn(label: Text('Electricity')),
                              DataColumn(label: Text('Internet')),
                              DataColumn(label: Text('Services')),
                              DataColumn(label: Text('Nights')),
                              DataColumn(label: Text('Room Occupation')),
                            ],
                            rows: dataRows),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, Object>> getTotals(List<ReservationModel?> reservations,
      List<Services?> services, List<Expenses?> expenses, DateTime firstDate, DateTime lastDate) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    List<Map<String, Object>> totals = [];
    double totalMonthlyRoomRevenue = 0,
        totalMonthlyCommission = 0,
        totalMonthlyDailyExpenses = 0,
        totalMonthlyRent = 0,
        totalMonthlyElectricity = 0,
        totalMonthlyWater = 0,
        totalMonthlyServices = 0,
        totalMonthlyInternet = 0,
        totalNights = 0;
    Duration yearDiff = lastDate.difference(firstDate);
    int numberOfMonths = (yearDiff.inDays * 12 / 365).floor();
    if (yearDiff.inDays < 366) {
      numberOfMonths = firstDate.month;
    }
    for (int i = firstDate.month; i <= numberOfMonths + 1; i++) {
      Map<String, Object> monthValues;
      for (int j = 0; j < reservations.length; j++) {
        if (reservations[j]!.checkIn.month == i) {
          totalMonthlyRoomRevenue += reservations[j]!.totalPrice;
          totalMonthlyCommission += reservations[j]!.commission;
          totalNights += reservations[j]!.nights;
        }
      }
      for (int j = 0; j < services.length; j++) {
        if (services[j]!.dateTime.month == i) {
          totalMonthlyServices += services[j]!.amount;
        }
      }
      for (int j = 0; j < expenses.length; j++) {
        if (expenses[j]!.date.month == i) {
          if (expenses[j]!.type.trim().toLowerCase() == 'daily')
            totalMonthlyDailyExpenses += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'rent')
            totalMonthlyRent += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'electricity')
            totalMonthlyElectricity += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'water')
            totalMonthlyWater += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'internet')
            totalMonthlyInternet += expenses[j]!.amount;
        }
      }
      monthValues = {
        'month': months[(i - 1) % 12],
        'nights': totalNights,
        'revenue': totalMonthlyRoomRevenue,
        'commission': totalMonthlyCommission,
        'services': totalMonthlyServices,
        'daily': totalMonthlyDailyExpenses,
        'rent': totalMonthlyRent,
        'water': totalMonthlyWater,
        'electricity': totalMonthlyElectricity,
        'internet': totalMonthlyInternet
      };
      totals.add(monthValues);
      totalMonthlyRoomRevenue = 0;
      totalMonthlyCommission = 0;
      totalMonthlyDailyExpenses = 0;
      totalMonthlyRent = 0;
      totalMonthlyElectricity = 0;
      totalMonthlyWater = 0;
      totalMonthlyServices = 0;
      totalMonthlyInternet = 0;
      totalNights = 0;
    }
    return totals;
  }
}
