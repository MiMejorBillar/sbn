import 'package:flutter/material.dart';
import 'screen_game.dart';

class SetupMatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Players'
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Player Selection Screen'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenGame())
              );
            }, 
            child: Text('Start Game')
            )
        ],
      )
    );
  }
}