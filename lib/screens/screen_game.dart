import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/riverpod/providers.dart';
import 'package:nsb/sb_elements/elements.dart';
export 'screen_game.dart';

class ScreenGame extends ConsumerStatefulWidget {
  const ScreenGame({super.key});

  @override
  ConsumerState<ScreenGame> createState() => _ScreenGameState();
}

class _ScreenGameState extends ConsumerState<ScreenGame> {
  bool _isSwapped = false;
  bool _isBallColorSwapped = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
  void _swapScorecards() {
    setState(() {
      _isSwapped = !_isSwapped;
    });
  }

  void _swapBallColors () {
    final gameState = ref.read(gameStateProvider);
    if(!gameState.isFirstTurnTaken){
    setState(() {
      _isBallColorSwapped = !_isBallColorSwapped;
    });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ball colors can only be swapped before the first turn'
          )
        )
      );
    }
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
                  : '${gameState.p2Name} wins!',
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

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(gameStateProvider.select((state) => state.matchResult), (previous, next) {
      if (next != null && previous == null) {
        _showMatchEndDialog(context, ref, next);
      }
    });    

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      side: const BorderSide(color: Color.fromARGB(255, 85, 85, 85), width: 2),
    );

    return  Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 61, 110),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: _isSwapped 
                          ? Scorecard(isP2: true, isBallColorSwapped: _isBallColorSwapped) 
                          : Scorecard(isP2: false, isBallColorSwapped: _isBallColorSwapped)
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: InningCounter()
                        ),
                      ],
                    ),
                    Expanded(
                      child: _isSwapped 
                      ? Scorecard(isP2: false, isBallColorSwapped: _isBallColorSwapped,) 
                      : Scorecard(isP2: true, isBallColorSwapped: _isBallColorSwapped)
                      ),
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
                    child: Tooltip(
                      message: 'Pause timer',
                      child: Icon(
                        Icons.pause, 
                        color: Colors.white,
                      ),
                    ),                    
                  ),
                  ElevatedButton(
                    onPressed: (){
                      ref.read(timerActionProvider.notifier).state = 'resume'; 
                    },
                    style: buttonStyle,
                    child: Tooltip(
                      message: 'Resume timer',
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      ref.read(gameStateProvider.notifier).useExtension();
                    },
                    style: buttonStyle,
                    child: Tooltip(
                      message: 'Call an extension',
                      child: Text(
                        'Ext.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )                                          
                ]
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(gameStateProvider.notifier).undo();
                    },
                    style: buttonStyle, 
                    child: Tooltip(
                      message: 'Fix a previous inning',
                      child: Text(
                        'Fix',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    )
                  ),

                  ElevatedButton(
                    onPressed: () {
                      _swapScorecards();
                    },
                    style: buttonStyle,
                    child: Tooltip(
                      message: 'Swap cards position',
                      child: Icon(
                        Icons.swap_horiz, 
                        color: Colors.white,
                        ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _swapBallColors();
                    },
                    style: buttonStyle,
                    child: Tooltip(
                      message: 'Swap ball colors',
                      child: Icon(
                        Icons.swap_horizontal_circle, 
                        color: Colors.white,
                        ),
                    ),
                  ),
                ],
              )
            ],
          )
        )
      );
  }
}
