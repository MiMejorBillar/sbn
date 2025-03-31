import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/screens/home_screen.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp( ProviderScope(
    child: MyApp(routeObserver:routeObserver),
  ));
}

class MyApp extends StatelessWidget {
  final RouteObserver<ModalRoute> routeObserver;
  const MyApp({super.key, required this.routeObserver});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      home: HomeScreen(),
    );
  }
}
