import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sb_elements/elements.dart';
import 'riverpod/providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home:ScreenGame(),
      )
    )
  );
}

class ScreenGame extends ConsumerWidget {
  const ScreenGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(gameStateProvider.select((state) => state.matchResult), (previous, next) {
      if (next != null && previous == null) {
        _showMatchEndDialog(context, ref, next);
      }
    });    

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      side: const BorderSide(color: Color.fromARGB(255, 85, 85, 85), width: 2),
    );
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
                    Expanded(child: Scorecard()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: InningCounter()
                          ),
                        ElevatedButton(
                          onPressed: (){
                            ref.read(gameStateProvider.notifier).undo();
                          } , 
                          style: buttonStyle,
                          child: Text(
                            'Fix',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            )
                          ),
                      ],
                    ),
                    Expanded(child: Scorecard(isP2: true)),
                    SizedBox(width: 8),
                  ],
                )
              ),
              Row(
                children:[
                  Expanded(
                    child: TimerBar(duration: 40)
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(timerActionProvider.notifier).state = 'pause';
                    },
                    style: buttonStyle,
                    child: Icon(Icons.pause, color: Colors.white,),                    
                  ),
                  ElevatedButton(
                    onPressed: (){
                      ref.read(timerActionProvider.notifier).state = 'resume'; 
                    },
                    style: buttonStyle,
                    child: Icon(Icons.play_arrow,color: Colors.white,),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      ref.read(gameStateProvider.notifier).useExtension(); 
                    },
                    style: buttonStyle,
                    child: Text(
                      'Ext.',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  )                                          
                ]
              ),
            ],
          )
        )
      )
    );
  }
  void _showMatchEndDialog(BuildContext context, WidgetRef ref, String result){
    final gameState = ref.read(gameStateProvider);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Match Ended'),
        content: Text(
          result == 'draw'
              ? 'It\'s a draw!'
              : result == 'P1'
                  ? '${gameState.p1Name} wins!'
                  : '${gameState.p2Name}Dick Jaspers wins!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameStateProvider.notifier).resetGame(
                p1Handicap: 40,
                p2Handicap: 40,
                equalizingInnings: true,
              );
            },
            child: const Text('New Game'),
          )
        ],
      )
    );
  }
}
