import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nsb/screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot){
        if (snapshot.hasData && snapshot.data!.session != null){
          return const HomeScreen();
        }else {
        return LoginScreen();
        } 
      },
    );
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  await Supabase.initialize(
    url: 'https://mralsvhvhvmzvpkbjqbe.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yYWxzdmh2aHZtenZwa2JqcWJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMwNjUyNzEsImV4cCI6MjA1ODY0MTI3MX0.qCjWLkdQo3JLQZTXjNCjoIi85_TRMNrqPdbZxZkfw3k' 
  );
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
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Lato',
        ),
        primaryTextTheme: ThemeData.light().primaryTextTheme.apply(
          fontFamily: 'Lato'
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontFamily: 'Lato'),
          ),
        )
      ),
      navigatorObservers: [routeObserver],
      routes: {
        '/auth': (context) => const AuthWrapper(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      home: const AuthWrapper(),
    );
  }
}

// Color Pallete for the Project
// Scorecard name : const Color.fromARGB(255, 85, 85, 85),