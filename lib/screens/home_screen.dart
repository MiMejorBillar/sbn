import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsb/screens/player_selection.dart';
import 'package:nsb/screens/screen_game.dart';
import 'package:nsb/screens/players_list.dart';
import 'package:nsb/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final ModalRoute? route = ModalRoute.of(context);
    if(route != null){
      routeObserver.subscribe(this,route);
    }
  }

  @override
  void didPopNext() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlayersList()));
                },
                child: Text('Players List')),
            ElevatedButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const PlayersSelectionDialog(),
                ).then((result) {
                  if (result == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ScreenGame()));
                  }
                });
              },
              child: const Text('Match'),
            )
          ],
        )));
  }
}
