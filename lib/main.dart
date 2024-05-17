import 'package:flutter/material.dart';
import 'package:mango_haus/managers/available_beds.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/managers/services_manager.dart';
import 'screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => GuestManager()),
    ChangeNotifierProvider(create: (context)=> ReservationManager()),
    ChangeNotifierProvider(create: (context)=> CheckInManager()),
    ChangeNotifierProvider(create: (context)=> PaymentManager()),
    ChangeNotifierProvider(create: (context)=> ExpensesManager()),
    ChangeNotifierProvider(create: (context)=> ServicesManager()),
    ChangeNotifierProvider(create: (context)=> AvailableBeds()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner :false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}
