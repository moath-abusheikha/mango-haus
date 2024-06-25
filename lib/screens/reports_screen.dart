import 'package:flutter/material.dart';
import 'package:mango_haus/subscreens/subscreens.dart';
import 'package:provider/provider.dart';
import '../managers/managers.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('images/paint-stain.png'), fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orange, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.5, 0.9],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 10, left: 10, right: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'Reports',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    highlightColor: Colors.grey.shade100,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => FinancialReport()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            offset: Offset(3, 0),
                          ),
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            offset: Offset(0, 3),
                          ),
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.inner,
                            offset: Offset(-3, 0),
                          ),
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.inner,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 20),
                          Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.green,
                            size: 35,
                          ),
                          SizedBox(height: 20),
                          Text('Financial Report')
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    highlightColor: Colors.grey.shade100,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => ReservationsReport()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            offset: Offset(3, 0),
                          ),
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            offset: Offset(0, 3),
                          ),
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.inner,
                            offset: Offset(-3, 0),
                          ),
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.inner,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 20),
                          Icon(
                            Icons.my_library_books_outlined,
                            color: Colors.green,
                            size: 35,
                          ),
                          SizedBox(height: 20),
                          Text('Reservations Report')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 10, bottom: 3, right: 10, left: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurStyle: BlurStyle.outer,
                        offset: Offset(3, 0),
                      ),
                      BoxShadow(
                        color: Colors.black,
                        blurStyle: BlurStyle.outer,
                        offset: Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.black,
                        blurStyle: BlurStyle.inner,
                        offset: Offset(-3, 0),
                      ),
                      BoxShadow(
                        color: Colors.black,
                        blurStyle: BlurStyle.inner,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Rooms Available Beds'),
                      SizedBox(height: 15,),
                      Container(
                        child: Row(
                          children: [
                            Spacer(),
                            Column(
                              children: [
                                Text('Alfonso'),
                                FutureBuilder(
                                  future: Provider.of<AvailableBeds>(context, listen: false)
                                      .getRoomAvailableBeds('alfonso'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return Container(
                                          width: 25,
                                          height: 125,
                                          margin: EdgeInsets.only(top: 5),
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) => Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text('${snapshot.data![index]?.bedNumber}')),
                                          ),
                                        );
                                      } else
                                        return CircularProgressIndicator();
                                    } else
                                      return Text('No Data');
                                  },
                                )
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text('Mallika'),
                                FutureBuilder(
                                  future: Provider.of<AvailableBeds>(context, listen: false)
                                      .getRoomAvailableBeds('mallika'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return Container(
                                          width: 25,
                                          height: 125,
                                          margin: EdgeInsets.only(top: 5),
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) => Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text('${snapshot.data![index]?.bedNumber}')),
                                          ),
                                        );
                                      } else
                                        return CircularProgressIndicator();
                                    } else
                                      return Text('No Data');
                                  },
                                )
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text('Kent'),
                                FutureBuilder(
                                  future: Provider.of<AvailableBeds>(context, listen: false)
                                      .getRoomAvailableBeds('kent'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return Container(
                                          width: 25,
                                          height: 125,
                                          margin: EdgeInsets.only(top: 5),
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) => Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text('${snapshot.data![index]?.bedNumber}')),
                                          ),
                                        );
                                      } else
                                        return CircularProgressIndicator();
                                    } else
                                      return Text('No Data');
                                  },
                                )
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text('Tent'),
                                FutureBuilder(
                                  future: Provider.of<AvailableBeds>(context, listen: false)
                                      .getRoomAvailableBeds('tent'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return Container(
                                          width: 25,
                                          height: 125,
                                          margin: EdgeInsets.only(top: 5),
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) => Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text('${snapshot.data![index]?.bedNumber}')),
                                          ),
                                        );
                                      } else
                                        return CircularProgressIndicator();
                                    } else
                                      return Text('No Data');
                                  },
                                )
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
