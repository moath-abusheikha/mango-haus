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
  bool? showZeros = false;

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
                        initialDateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                        context: context,
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2030),
                      );
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
            Row(
              children: [
                Spacer(),
                Center(child: Text('Remove Empty Fields'),),
                Container(
                    child: Checkbox(
                      value: showZeros,
                      onChanged: (bool? value) {
                        setState(() {
                          showZeros = value;
                        });
                      },
                    ))
              ],
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
                      List<DataRow> dataRows = [];
                      if (!snapshot.hasData)
                        return Center(child: Text('No data found your filter'));
                      else if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        List<ReservationModel> futureReservations =
                            snapshot.data?[0] as List<ReservationModel>;
                        List<Services> futureServices = snapshot.data?[1] as List<Services>;
                        List<Expenses> futureExpenses = snapshot.data?[2] as List<Expenses>;
                        if (startDate != null && endDate != null) {
                          dataRows = getTotals(futureReservations, futureServices, futureExpenses,
                              startDate!, endDate!);
                          // for (int m = 0; m < dataRows.length; m++) print(dataRows[m].cells);
                        }
                      }
                      // return Container();
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

  List<DataRow> getTotals(List<ReservationModel?> reservations, List<Services?> services,
      List<Expenses?> expenses, DateTime firstDate, DateTime lastDate) {
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
    int yearDiff = (lastDate.year - firstDate.year) + 1;
    int numberOfMonths = (yearDiff * 12) - (firstDate.month - 1) - (12 - lastDate.month);
    List<DataRow> rows = List.generate(
      numberOfMonths,
      (index) => DataRow(
        cells: [
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
          DataCell(Container()),
        ],
      ),
    );
    List<int> indices = [];
    for (int i = 0; i < numberOfMonths; i++) {
      int yearAddition = ((i + firstDate.month - 1) / 12).truncate();
      // print('${months[(i + firstDate.month - 1)%12]}');
      int monthIndex = (i + firstDate.month - 1) % 12;
      String month = months[monthIndex];
      int year = firstDate.year + yearAddition;
      double monthlyRoomRevenue = 0,
          monthlyCommission = 0,
          monthlyDailyExpenses = 0,
          monthlyRent = 0,
          monthlyElectricity = 0,
          monthlyWater = 0,
          monthlyServices = 0,
          monthlyInternet = 0,
          monthlyNights = 0;
      for (int j = 0; j < reservations.length; j++) {
        if (reservations[j]?.checkIn.month == monthIndex + 1 &&
            reservations[j]?.checkIn.year == year &&
            reservations[j]?.status == 'checkedOut') {
          monthlyRoomRevenue += reservations[j]!.totalPrice;
          monthlyCommission += reservations[j]!.commission;
          monthlyNights += reservations[j]!.nights;
        }
      }
      for (int j = 0; j < expenses.length; j++) {
        if (expenses[j]?.date.month == monthIndex && expenses[j]?.date.year == year) {
          if (expenses[j]!.type.trim().toLowerCase() == 'daily')
            monthlyDailyExpenses += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'rent') monthlyRent += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'electricity')
            monthlyElectricity += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'water')
            monthlyWater += expenses[j]!.amount;
          if (expenses[j]!.type.trim().toLowerCase() == 'internet')
            monthlyInternet += expenses[j]!.amount;
        }
      }

      if (monthlyRoomRevenue == 0 &&
          monthlyCommission == 0 &&
          monthlyDailyExpenses == 0 &&
          monthlyRent == 0 &&
          monthlyElectricity == 0 &&
          monthlyWater == 0 &&
          monthlyServices == 0 &&
          monthlyInternet == 0 &&
          monthlyNights == 0) indices.add(i);
      DataRow dataRow = DataRow(cells: [
        DataCell(
          Center(
            child: Text(
              '$month - $year',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text('${monthlyRoomRevenue.toStringAsFixed(2)}', textAlign: TextAlign.center),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyCommission.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyDailyExpenses.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyRent.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyWater.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyElectricity.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyInternet.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyServices.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${monthlyNights.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${((monthlyNights / 360) * 100).toStringAsFixed(2)} %',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);
      // print(rows);
      rows[i] = dataRow;
    }
    List<DataRow> finalRows = [];
    for (int q = 0; q < rows.length; q++) {
      if (!indices.contains(q)) finalRows.add(rows[q]);
    }
    return showZeros == true ? finalRows : rows;
  }
}
