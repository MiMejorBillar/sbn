import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/widgets/scoresheet.dart';
import 'package:open_file/open_file.dart';
import '/state_management/providers.dart';
import 'package:nsb/widgets/elements.dart';
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
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _swapScorecards() {
    setState(() {
      _isSwapped = !_isSwapped;
    });
  }

  void _swapBallColors() {
    final gameState = ref.read(gameStateProvider);
    if (!gameState.isFirstTurnTaken) {
      setState(() {
        _isBallColorSwapped = !_isBallColorSwapped;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Ball colors can only be swapped before the first turn')));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(gameStateProvider.select((state) => state.matchResult),
        (previous, next) {
      if (next != null && previous == null) {
        _showMatchEndDialog(context, ref, next);
      }
    });

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      side: const BorderSide(color: Color.fromARGB(255, 85, 85, 85), width: 2),
    );

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end:Alignment.bottomCenter,
              colors:[
                Colors.black,
                const Color.fromARGB(255, 0, 61, 110),

              ]
            )
          ),
          child: SafeArea(
              child: Column(
                children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Scorecard(
                    isP2: _isSwapped, isBallColorSwapped: _isBallColorSwapped),
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(padding: EdgeInsets.all(4), child: InningCounter()),
                ],
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Scorecard(
                  isP2: !_isSwapped,
                  isBallColorSwapped: _isBallColorSwapped,
                ),
              )),
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              Expanded(child: TimerBar()),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          ref.read(gameStateProvider.notifier).undo();
                        },
                        style: buttonStyle,
                        child: Tooltip(
                          message: 'Fix a previous inning',
                          child: Text('Fix',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )),
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
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.read(timerStateProvider.notifier).pause();
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
                      onPressed: () {
                        ref.read(timerStateProvider.notifier).resume();
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
                      onPressed: () {
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
                  ],
                ),
              ],
            ),
          )
                ],
              )),
        ));
  }

  void _showMatchEndDialog(BuildContext context, WidgetRef ref, String result) {
    final gameState = ref.read(gameStateProvider);
    final winnerText = result == 'draw'
        ? 'It\'s a draw!'
        : result == 'P1'
            ? '${gameState.p1Name} wins!'
            : '${gameState.p2Name} wins';

    showDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        useSafeArea: true,
        builder: (context) => PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              child: Dialog(
                backgroundColor: Colors.grey.shade900.withValues(alpha: 0.9),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Match Ended!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      winnerText,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final filePath =
                                await generateScoresheetPdf(gameState);
                            final result = await OpenFile.open(filePath);
                            if (result.type != ResultType.done) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Couldn\'t open PDF. No viewer found')));
                            }
                          },
                          child: const Text('View Scoresheet'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: const Text('Back to Home'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
