import 'package:flutter/material.dart';
import 'package:mango_haus/components/components.dart';
import 'package:provider/provider.dart';
import '../managers/managers.dart';
import '../models/models.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Widget? componentWidget;
  List<CheckInOut>? allCheckIns;
  List<Guest>? guests;
  List<ReservationModel>? bookings;
  List<Payment>? payments;
  List<Expenses>? expenses;
  List<Services>? services;
  String report = 'Report Name';

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    allCheckIns = await Provider.of<CheckInManager>(context, listen: false).getAllCheckIns();
    guests = await Provider.of<GuestManager>(context, listen: false).getAllGuests();
    bookings = await Provider.of<ReservationManager>(context, listen: false).getAllReservations();
    payments = await Provider.of<PaymentManager>(context, listen: false).getAllPayments();
    expenses = await Provider.of<ExpensesManager>(context, listen: false).getExpenses();
    services = await Provider.of<ServicesManager>(context, listen: false).getAllServices();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/mango.jpg'), fit: BoxFit.fitHeight),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white.withOpacity(0.5)),
              margin: EdgeInsets.only(top: 25, bottom: 15),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  'Reports',
                  style: TextStyle(
                      fontSize: 65, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  highlightColor: Colors.grey.shade100.withOpacity(0.8),
                  onTap: () async {
                    setState(() {
                      report = 'Reservation Report';
                      componentWidget = ReservationsReport(
                          allCheckIns: allCheckIns,
                          guests: guests,
                          bookings: bookings,
                          payments: payments);
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white.withOpacity(0.8),
                      border: Border.all(color: Colors.orangeAccent, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 20),
                        Icon(
                          Icons.list_alt,
                          color: Colors.green,
                          size: 35,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Reservations',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  highlightColor: Colors.grey.shade100.withOpacity(0.8),
                  onTap: () async {
                    setState(() {
                      report = 'Financial Report';
                      componentWidget = FinancialReport(
                          allCheckIns: allCheckIns,
                          guests: guests,
                          bookings: bookings,
                          payments: payments,
                          expenses: expenses,
                          services: services);
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.orangeAccent, width: 1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 20),
                          Icon(
                            Icons.list_alt,
                            color: Colors.green,
                            size: 35,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Financial Report',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                        color: Colors.orange,
                      )),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                  )),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text('$report'),
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                        color: Colors.orange,
                      )),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            componentWidget != null ? componentWidget! : Container(),
          ],
        ),
      ),
    );
  }
}
