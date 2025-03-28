import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsb/screens/player_selection.dart';
import 'package:nsb/screens/screen_game.dart';
import 'package:nsb/screens/players_list.dart';


class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose(){
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
        title: Text(
          'Home'
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => PlayersList() ));
              }, 
              child: Text(
                'Players List'
                )
            ),
            ElevatedButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const PlayersSelectionDialog(),
                ).then((confirmed) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScreenGame())
                  );
                });
              },
              child: const Text('Start Match') ,
            )
          ],
        )
      )
    );
  }
}