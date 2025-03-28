import 'package:flutter/material.dart';
import 'package:nsb/screens/player_selection.dart';
import 'package:nsb/screens/screen_game.dart';
import 'package:nsb/screens/players_list.dart';


class HomeScreen extends StatelessWidget{
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