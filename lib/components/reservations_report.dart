import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/models/models.dart';

class ReservationsReport extends StatefulWidget {
  final List<CheckInOut>? allCheckIns;
  final List<Guest>? guests;
  final List<ReservationModel>? bookings;
  final List<Payment>? payments;

  const ReservationsReport(
      {required this.allCheckIns,
      required this.guests,
      required this.bookings,
      required this.payments,
      super.key});

  @override
  State<ReservationsReport> createState() => _ReservationsReportState();
}

class _ReservationsReportState extends State<ReservationsReport> {
  DateTime startDate = DateTime(2024, 1);
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
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
              Text(
                  'Check in Date: ${DateFormat('EEEE, d MMM, yyyy').format(startDate).toString()}'),
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
              Text('Check out Date: ${DateFormat('EEEE, d MMM, yyyy').format(endDate).toString()}'),
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
                  });
                },
                child: Text('change date'),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(columns: [
                DataColumn(label: Text('Guest Name')),
                DataColumn(label: Text('Room')),
                DataColumn(label: Text('Nationality')),
                DataColumn(label: Text('number of Guests')),
                DataColumn(label: Text('Check in date')),
                DataColumn(label: Text('Check out date')),
                DataColumn(label: Text('Nights')),
                DataColumn(label: Text('Total Charge')),
                DataColumn(label: Text('Commission')),
                DataColumn(label: Text('Net Price')),
                DataColumn(label: Text('total Payments')),
                DataColumn(label: Text('Remaining Balance')),
              ], rows: [
                // if (widget.bookings != null && widget.bookings!.length > 0)
                //   for (int i = 0; i < widget.bookings!.length; i++)
                //     if (DateFormat("EEEE, d MMM, yyyy")
                //             .parse(widget.bookings![i].checkIn)
                //             .isAfter(startDate) &&
                //         DateFormat("EEEE, d MMM, yyyy")
                //             .parse(widget.bookings![i].checkout)
                //             .isBefore(endDate))
                //       getDataRow(widget.bookings?[i])
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Future<DateTime> selectDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2123));
    if (date != null) {
      return date;
    }
    return DateTime.now();
  }

  DataRow getDataRow(ReservationModel? booking) {
    double totalPayment = 0, remaining = 0;
    String? country;
    // for (int j = 0; j < widget.guests!.length; j++) {
    //   if (booking?.guestName == widget.guests![j].name) {
    //     country = widget.guests![j].country;
    //   }
    // }
    // if (widget.payments != null && widget.payments?.length != 0)
    //   for (int j = 0; j < widget.payments!.length; j++) {
    //     if (booking?.guestName == widget.payments![j].guestName) {
    //       for (int k = 0; k < widget.payments![j].paymentAmounts.length; k++) {
    //         totalPayment += widget.payments![j].paymentAmounts[k];
    //       }
    //       remaining = widget.payments![j].remaining;
    //     }
    //   }
    // else{
    //   remaining = booking!.totalPrice;
    //   totalPayment = 0;
    // }

    return DataRow(cells: [
      DataCell(Text('')),//${booking?.guestName}
      DataCell(Text('${booking?.room}')),
      DataCell(country != null ? Text('$country') : Text('No Information')),
      DataCell(Text('${booking?.guestsCount}')),
      DataCell(Text('${booking?.checkIn}')),
      DataCell(Text('${booking?.checkout}')),
      DataCell(Text('${booking?.nights}')),
      DataCell(Text('${booking?.roomPrice}')),
      DataCell(Text('')),//{booking?.commission}
      DataCell(Text('')),//booking?.commission != null ? Text('${booking?.commission}') : Text('0')
      DataCell(Text('$totalPayment')),
      DataCell(Text('$remaining')),
    ]);
  }
}
