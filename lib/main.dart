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
              Expanded(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 8),
                    Expanded(child: ScoreboardP1(p1Name: 'Marco Zanetti',handicap: 40, extensions:5)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: InningCounter()
                          ),
                        Container(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 36, 36, 36),
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 85, 85, 85),
                                        width: 2,
                                      )),
                                  child: Icon(Icons.plus_one,
                                      color: Colors.white)),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 36, 36, 36),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 85, 85, 85),
                                      width: 2,
                                    )),
                                child: Icon(Icons.exposure_minus_1,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: ScoreboardP1(p1Name: 'Dick Jaspers', handicap: 40, extensions: 5, isP2: true)),
                    SizedBox(width: 8),
                  ],
                )
              ),
              Row(
                children:[
                  Expanded(
                    child: TimerBar(duration: 40, key: timerBarKey,)
                  ),
                  ElevatedButton(
                    onPressed: () {
                      timerBarKey.currentState?.pauseTimer();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 85, 85, 85),
                        width: 2,
                      )
                    ),
                    child: Icon(Icons.pause, color: Colors.white,),                    
                  ),
                  ElevatedButton(
                    onPressed: (){
                      timerBarKey.currentState?.resumeTimer(); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 85, 85, 85),
                        width: 2,
                      )
                    ),
                    child: Icon(Icons.play_arrow,color: Colors.white,),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      timerBarKey.currentState?.resetTimer(); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 85, 85, 85),
                        width: 2,
                      )
                    ),
                    child: Icon(Icons.loop,color: Colors.white,),
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