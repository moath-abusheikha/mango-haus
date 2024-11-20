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
                          .getFilteredServices(startDate, endDate, null, null),
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
                        List<ReservationModel> futureReservations =
                            snapshot.data?[0] as List<ReservationModel>;
                        List<Services> futureServices = snapshot.data?[1] as List<Services>;
                        List<Expenses> futureExpenses = snapshot.data?[2] as List<Expenses>;
                        if (startDate != null && endDate != null) {
                          totals = getTotals(futureReservations, futureServices, futureExpenses,
                              startDate!, endDate!);
                        }
                      }
                      List<DataRow> dataRows = [];
                      if (totals.isNotEmpty)
                        for (int i = 0; i < totals.length; i++) {
                          int roomCount = int.parse(totals[i]['nights'].toString());
                          double roomOccupancy = roomCount / 360;
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
                                  child: Text(
                                      '${double.parse(totals[i]['revenue'].toString()).toStringAsPrecision(6)}',
                                      textAlign: TextAlign.center)),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${double.parse(totals[i]['commission'].toString()).toStringAsPrecision(3)}',
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
                                  child: Text('${roomOccupancy.toStringAsPrecision(2)}',
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
    print(reservations);
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
    List totalMonthlyRoomRevenue = List.generate(12, (index) => 0, growable: false),
        totalMonthlyCommission = List.generate(12, (index) => 0, growable: false),
        totalMonthlyDailyExpenses = List.generate(12, (index) => 0, growable: false),
        totalMonthlyRent = List.generate(12, (index) => 0, growable: false),
        totalMonthlyElectricity = List.generate(12, (index) => 0, growable: false),
        totalMonthlyWater = List.generate(12, (index) => 0, growable: false),
        totalMonthlyServices = List.generate(12, (index) => 0, growable: false),
        totalMonthlyInternet = List.generate(12, (index) => 0, growable: false);
    List<int> totalNights = List.generate(12, (index) => 0, growable: false);
    Map<String, Object> monthsValues;
    List<Map<String, Object>> totals = [];
    for (int i = 0; i < reservations.length; i++) {
      int index = reservations[i]!.checkIn.month - 1;
      totalMonthlyRoomRevenue[index] += reservations[i]!.totalPrice;
      totalMonthlyCommission[index] += reservations[i]!.commission;
      totalNights[index] += reservations[i]!.nights;
    }
    for (int j = 0; j < services.length; j++) {
      int index = reservations[j]!.checkIn.month - 1;
      totalMonthlyServices[index] += services[j]!.amount;
    }
    for (int j = 0; j < expenses.length; j++) {
      int index = reservations[j]!.checkIn.month - 1;
      if (expenses[j]!.type.trim().toLowerCase() == 'daily')
        totalMonthlyDailyExpenses[index] += expenses[j]!.amount;
      if (expenses[j]!.type.trim().toLowerCase() == 'rent')
        totalMonthlyRent[index] += expenses[j]!.amount;
      if (expenses[j]!.type.trim().toLowerCase() == 'electricity')
        totalMonthlyElectricity[index] += expenses[j]!.amount;
      if (expenses[j]!.type.trim().toLowerCase() == 'water')
        totalMonthlyWater[index] += expenses[j]!.amount;
      if (expenses[j]!.type.trim().toLowerCase() == 'internet')
        totalMonthlyInternet[index] += expenses[j]!.amount;
    }
    for (int i = 0; i < 12; i++) {
      if (totalNights[i] == 0 &&
          totalMonthlyRoomRevenue[i] == 0 &&
          totalMonthlyCommission[i] == 0 &&
          totalMonthlyServices[i] == 0 &&
          totalMonthlyDailyExpenses[i] == 0 &&
          totalMonthlyRent[i] == 0 &&
          totalMonthlyWater[i] == 0 &&
          totalMonthlyElectricity[i] == 0 &&
          totalMonthlyInternet[i] == 0) continue;

      monthsValues = {
        'month': months[i],
        'nights': totalNights[i],
        'revenue': totalMonthlyRoomRevenue[i],
        'commission': totalMonthlyCommission[i],
        'services': totalMonthlyServices[i],
        'daily': totalMonthlyDailyExpenses[i],
        'rent': totalMonthlyRent[i],
        'water': totalMonthlyWater[i],
        'electricity': totalMonthlyElectricity[i],
        'internet': totalMonthlyInternet[i]
      };
      totals.add(monthsValues);
    }
    return totals;
  }
}
