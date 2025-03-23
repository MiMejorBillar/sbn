import 'package:flutter/material.dart';
import 'sb_elements/elements.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final timerBarKey = GlobalKey<TimerBarState>();
    
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 61, 110),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 8),
                  Expanded(child: ScoreboardP1(p1Name: 'Marco Zanetti',handicap: 40, extensions:5)),
                  Container(padding: EdgeInsets.all(8),child: InningCounter()),
                  Expanded(child: ScoreboardP1(p1Name: 'Dick Jaspers', handicap: 40, extensions: 5, isP2: true)),
                  SizedBox(width: 8),
                ],
              )),
              Row(
              ),
              Row(
                children:[
                  Expanded(
                    child: TimerBar(duration: 30, key: timerBarKey,)
                  ),
                  ElevatedButton(
                    onPressed: () {
                      timerBarKey.currentState?.pauseTimer();
                    },
                    child: Icon(Icons.pause),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      timerBarKey.currentState?.resumeTimer(); 
                    },
                    child: Icon(Icons.loop),
                  )                  
                ]
              ),
            ],
          )
        )
      )
    );
  }
}