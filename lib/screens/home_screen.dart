import 'package:flutter/material.dart';
import 'package:nsb/screens/screen_game.dart';
import 'package:nsb/screens/setup_match.dart';


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
                  MaterialPageRoute(builder: (context) => SetupMatch() ));
              }, 
              child: Text(
                'Set up Match!'
                )
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScreenGame())
                );
              }, 
              child: Text(
                'Start Game'
              )
            )
          ],
        )
      )
    );
  }
}