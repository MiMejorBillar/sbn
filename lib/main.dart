import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sb_elements/elements.dart';
import 'riverpod/providers.dart';

void main() {
  runApp(const ProviderScope(child: ScreenGame()));
}

class ScreenGame extends ConsumerWidget {
  const ScreenGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final timerBarKey = GlobalKey<TimerBarState>();

    //Listen to changes in bothTurnsEndedProvider
    ref.listen<bool>(bothTurnsEndedProvider, (previous, current){
      if (current) {
        // Increment inning count and reset turn statuses
        ref.read(inningCountProvider.notifier).state++;
        ref.read(p1TurnEndedProvider.notifier).state = false;
        ref.read(p2TurnEndedProvider.notifier).state = false;
      }
    });
    
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
                    Expanded(child: Scorecard(playerName: 'Marco Zanetti',handicap: 40, extensions:5, timerBarKey: timerBarKey,)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: InningCounter()
                          ),
                      ],
                    ),
                    Expanded(child: Scorecard(playerName: 'Dick Jaspers', handicap: 40, extensions: 5, isP2: true, timerBarKey: timerBarKey,)),
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
                      ),
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