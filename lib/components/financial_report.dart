import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/models/models.dart';

class FinancialReport extends StatefulWidget {
  final List<CheckInOut>? allCheckIns;
  final List<Guest>? guests;
  final List<ReservationModel>? bookings;
  final List<Payment>? payments;
  final List<Expenses>? expenses;
  final List<Services>? services;

  const FinancialReport({
    required this.allCheckIns,
    required this.guests,
    required this.bookings,
    required this.payments,
    required this.expenses,
    required this.services,
    super.key,
  });

  @override
  State<FinancialReport> createState() => _FinancialReportState();
}

class _FinancialReportState extends State<FinancialReport> {
  DateTime startDate = DateTime(2024, 1);
  DateTime endDate = DateTime.now();
  List<InkWell> inkwells = [];

  @override
  void initState() {
    inkwells = getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white.withOpacity(0.5),
        padding: EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 10,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                child: Row(
                  children: [
                    Spacer(),
                    Text('Start: ${DateFormat('EEEE, d MMM, yyyy').format(startDate).toString()}'),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {
                        DateTime date = await selectDate();
                        setState(() {
                          startDate = date;
                          inkwells = getList();
                        });
                      },
                      child: Text('change date'),
                    ),
                  ],
                ),
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                child: Row(
                  children: [
                    Spacer(),
                    Text('End Date: ${DateFormat('EEEE, d MMM, yyyy').format(endDate).toString()}'),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {
                        DateTime date = await selectDate();
                        setState(() {
                          endDate = date;
                          inkwells = getList();
                        });
                      },
                      child: Text('change date'),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 300,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0,
                      mainAxisExtent: 200,
                    ),
                    padding: EdgeInsets.all(8.0), // padding around the grid
                    itemCount: inkwells.length + 1, // total number of items
                    itemBuilder: (context, index) {
                      if (index == inkwells.length)
                        return SizedBox(
                          height: 10,
                        );
                      return inkwells[index];
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime> selectDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2123));
    if (date != null) {
      return date;
    }
    return DateTime.now();
  }

  List<InkWell> getList() {
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
    int totalNumberOfNights = 364;
    DateTime date = startDate;
    if (widget.allCheckIns != null && widget.bookings != null)
      while (date.isBefore(endDate)) {
        String theDate = DateFormat("MMMM, yyyy").format(date);
        int numberOfNights = 0, numberOfGuests = 0, extensionNights = 0;
        double netRoomRevenue = 0,
            roomOccupancy = 0,
            roomRevenue = 0,
            totalCommission = 0,
            dailyExpense = 0,
            rentExpense = 0,
            electricityExpense = 0,
            waterExpense = 0,
            internetExpense = 0,
            totalServices = 0;
        ReservationModel? currentReservation;
        for (int i = 0; i < widget.allCheckIns!.length; i++) {
          for (int m = 0; m < widget.bookings!.length; m++) {
            if (widget.allCheckIns![i].reservationId == widget.bookings![m].checkIn) {
              currentReservation = widget.bookings![m];
              break;
            }
          }
          // if (DateFormat("yyyy-MM-dd hh:mm:ss").parse(currentReservation!.checkIn).month ==
          //         date.month &&
          //     DateFormat("yyyy-MM-dd hh:mm:ss").parse(currentReservation.checkIn).year ==
          //         date.year) {
          //   if (currentReservation.room != 'Kent' || currentReservation.room != 'Tent') {
          //     numberOfGuests += currentReservation.guestsCount;
          //   } else
          //     numberOfGuests++;
          //   numberOfNights += currentReservation.nights;
          // /*  roomRevenue += currentReservation.totalPrice +
          //       (currentReservation.totalPrice * currentReservation.commission);
          //   totalCommission += currentReservation.totalPrice * currentReservation.commission;*/
          //   netRoomRevenue += currentReservation.totalPrice;
          // }
        }
        roomOccupancy = numberOfGuests * numberOfNights / totalNumberOfNights;
        if (widget.services != null) {
          for (int i = 0; i < widget.services!.length; i++) {
            if (widget.services![i].dateTime.month == date.month &&
                widget.services![i].dateTime.year == date.year) {
              totalServices += widget.services![i].amount;
            }
          }
        }
        if (widget.expenses != null) {
          for (int i = 0; i < widget.expenses!.length; i++) {
            if (widget.expenses![i].date.month == date.month &&
                widget.expenses![i].date.year == date.year) {
              if (widget.expenses![i].type == 'Rent') rentExpense += widget.expenses![i].amount;
              if (widget.expenses![i].type == 'Daily') dailyExpense += widget.expenses![i].amount;
              if (widget.expenses![i].type == 'Electricity')
                electricityExpense += widget.expenses![i].amount;
              if (widget.expenses![i].type == 'Water') waterExpense += widget.expenses![i].amount;
              if (widget.expenses![i].type == 'Internet')
                internetExpense += widget.expenses![i].amount;
            }
          }
        }
        String netIncome = (netRoomRevenue -
                dailyExpense -
                rentExpense -
                electricityExpense -
                waterExpense -
                internetExpense)
            .toStringAsFixed(2);
        InkWell inkWell = InkWell(
          highlightColor: Colors.grey.shade100.withOpacity(0.8),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white.withOpacity(0.8),
              border: Border.all(color: Colors.orangeAccent, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [Spacer(), Text(theDate), Spacer()],
                ),
                Text('Month : ${months[date.month - 1]}'),
                Text('Total Nights: ${numberOfNights}'),
                Text('Occupancy Rate: ${roomOccupancy.toStringAsFixed(1)}'),
                Text('Total commission ${totalCommission.toStringAsFixed(1)}'),
                Text('Net Room Revenue${netRoomRevenue.toStringAsFixed(1)}'),
                Text('${dailyExpense.toStringAsFixed(1)}'),
                Text('${waterExpense.toStringAsFixed(1)}'),
                Text('${electricityExpense.toStringAsFixed(1)}'),
                Text('${internetExpense.toStringAsFixed(1)}'),
                Text('${rentExpense.toStringAsFixed(1)}'),
                Text('${totalServices.toStringAsFixed(1)}'),
                Text('${netIncome}'),
              ],
            ),
          ),
        );
        date = DateTime(date.year, date.month + 1);
        inkwells.add(inkWell);
      }
    return inkwells;
  }
}
