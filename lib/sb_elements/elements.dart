import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../riverpod/providers.dart';

class Scorecard extends ConsumerStatefulWidget {
  const Scorecard ({
    super.key,
    this.isP2 = false,
    this.isBallColorSwapped = false,
    });
  
  final bool isP2;
  final bool isBallColorSwapped;


  @override
  ConsumerState<Scorecard> createState() => ScorecardState();
}

class ScorecardState extends ConsumerState<Scorecard> {

Color _contColor(bool isP2, bool isBallColorSwapped){

  bool useYellowScheme = (isP2 && !isBallColorSwapped) || (!isP2 && isBallColorSwapped);
  return useYellowScheme ? Colors.amber : const Color.fromARGB(255, 249, 246, 238);
}

void _endTurn() {
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  final gameState = ref.read(gameStateProvider);
  final playerName = widget.isP2 ? gameState.p2Name : gameState.p1Name;
  final turnEnded = gameStateNotifier.endTurn(widget.isP2 ? 2 : 1);
  if(turnEnded && gameState.currentPlayer == 1 && !gameState.isFirstTurnTaken){
    final p1BallColor = widget.isBallColorSwapped ? 'yellow' : 'white';
    final p2BallColor = widget.isBallColorSwapped ? 'white' : 'yellow';
    gameStateNotifier.setBallColors(p1BallColor, p2BallColor);
  }
  if (turnEnded){
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          'Turn ended for $playerName', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _contColor(widget.isP2, widget.isBallColorSwapped),
            shadows:[
              Shadow(
                color: Colors.black.withValues(alpha: 0.50),
                offset: Offset(0, 0),
                blurRadius: 10,
              )
            ]
            )
        )
      ),
      width: 250,
      duration: Duration(seconds: 1),
      backgroundColor: Colors.green.withValues(alpha: 0.90),
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.symmetric(vertical: 10),
      // shape:Border.all(
      //   color: Colors.black
      // ) ,
    ),
  );
  }
}

  @override
  Widget build(BuildContext context){
          
    return Consumer(
      builder: (context, ref, child) {
              //Existing Variables
        final gameState = ref.watch(gameStateProvider);
        final playerName = widget.isP2 ? gameState.p2Name : gameState.p1Name;
        final handicap = widget.isP2 ? gameState.p2Handicap : gameState.p1Handicap;
        final extensions = widget.isP2 ? gameState.p2Extensions : gameState.p1Extensions;
        final usedExtensions = widget.isP2 ? gameState.p2UsedExtensions : gameState.p1UsedExtensions;
        final pendingPoints = widget.isP2 ? gameState.p2PendingPoints : gameState.p1PendingPoints;
        final totalScore = ref.watch(gameStateProvider.select((state) => widget.isP2? state.p2TotalScore : state.p1TotalScore));
        final highRun = ref.watch(gameStateProvider.select((state) => widget.isP2? state.p2HighRun : state.p1HighRun));
        final average = ref.watch(gameStateProvider.select((state) => widget.isP2? state.p2Average : state.p1Average));
        final currentPlayer = ref.watch(gameStateProvider.select((state) => state.currentPlayer));
        final activePlayerColor = _contColor(currentPlayer == 2, widget.isBallColorSwapped) ;
        final isActive = (widget.isP2 ? 2 : 1) == currentPlayer;
        final activePlayerName = currentPlayer == 1? gameState.p1Name : gameState.p2Name;
        //Ball color changes
        final bool showYellowBall = (widget.isP2 && !widget.isBallColorSwapped) || (!widget.isP2 && widget.isBallColorSwapped);
        final String ballIcon = showYellowBall ? 'assets/icons/ybi.png' : 'assets/icons/wbi.png';
        final String headerIcon = widget.isP2 ? 'assets/icons/creeper.png' : 'assets/icons/trophy.png';  
      return Stack(
        children: [
          Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(134, 0, 0, 0).withValues(alpha: 0.90),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ICON NAME AND HANDICAP
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color.fromARGB(255, 85, 85, 85),
                      width: 8
                    )
                  ),
                  color: const Color.fromARGB(255, 36, 36, 36),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Image.asset(
                        headerIcon ,
                        width: 50,
                      )
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: widget.isBallColorSwapped
                          ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: playerName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: _contColor(widget.isP2, widget.isBallColorSwapped),
                                  ),
                                ),
                                TextSpan(
                                  text: widget.isP2 ? ' (P2)' : ' (P1)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: _contColor(widget.isP2, widget.isBallColorSwapped),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Text(
                            '$playerName',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _contColor(widget.isP2, widget.isBallColorSwapped)
                            ),
                          ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 50,
                      decoration: BoxDecoration(),
                      child: Text(
                        '$handicap',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold, 
                          color: _contColor(widget.isP2,widget.isBallColorSwapped)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SCORE AND EXTENSION
              Expanded(
                child: Consumer(
                  builder: (context, ref, child){
                  return GestureDetector(
                    onTap: isActive ? _endTurn : null,
                    child: Container(
                      color: _contColor(widget.isP2,widget.isBallColorSwapped),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '$totalScore',
                                        style: const TextStyle(
                                          fontSize: 80,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned.fill(
                                child:Align(
                                  alignment: Alignment.bottomRight,
                                  child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center, //EXTENSION COLUMN
                                    children: List.generate(
                                      extensions,
                                      (index) => Container(
                                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                        width: 32,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: index < usedExtensions ? Colors.grey : Colors.green,
                                          borderRadius: BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              spreadRadius: 0.4,
                                              blurRadius: 1,
                                            )
                                          ]
                                        )
                                      ),
                                    )
                                  )
                                )
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  } 
                ),
              ),
              // STATS AND COUNTER
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 36, 36, 36),
                  border: Border(
                    top: BorderSide(
                      color: const Color.fromARGB(255, 85, 85, 85),
                      width: 8
                    )
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
                height: 70,
                // AVERAGE AND HIGH RUN
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child:Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //AVERAGE
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Avg.',
                                    style: TextStyle(
                                        fontSize: 16, color: _contColor(widget.isP2, widget.isBallColorSwapped))),
                                Text(
                                  average.toStringAsFixed(3),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _contColor(widget.isP2, widget.isBallColorSwapped)),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: const Color.fromARGB(255, 85, 85, 85
                                    ),
                                    width: 2,
                                  )
                                ),
                              ),
                            ),
                            // HIGH RUN
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('H.R.',
                                    style: TextStyle(
                                        fontSize: 16, color: _contColor(widget.isP2, widget.isBallColorSwapped))),
                                Text(
                                  '$highRun',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _contColor(widget.isP2, widget.isBallColorSwapped)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                    Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(8))
                      ),
                      child: isActive 
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (totalScore + pendingPoints + 1 > handicap){
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Cannot add more points. You\'ve reached your handicap of $handicap'),
                                            duration: Duration(seconds: 2),));
                              } else {
                                final newPendingPoints = pendingPoints + 1;
                                ref.read(gameStateProvider.notifier).updatePendingPoints(widget.isP2 ? 2 : 1, newPendingPoints );
                              }
                            },
                            child: Container(  
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              width: 100,
                              child: Text(
                                '$pendingPoints',
                                style: TextStyle(
                                  color: _contColor(widget.isP2, widget.isBallColorSwapped),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                                ),                                                                              
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(pendingPoints > 0) {
                                  final newPendingPoints = pendingPoints - 1;
                                  ref.read(gameStateProvider.notifier).updatePendingPoints(widget.isP2 ? 2 : 1, newPendingPoints);
                                }
                              });
                            },
                            child: Image.asset(ballIcon, width: 60,)
                          )
                        ],
                      )
                    : Center(
                      child: Text(
                        '$activePlayerName \n is playing...',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: activePlayerColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    )
                  ],
                ),
              ),
            ],  
          ),
        ),
        if(!isActive)
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(70),
            borderRadius: BorderRadius.circular(8)
          ),
        )
        ]
      );
    },
    );
  }
}

class InningCounter extends ConsumerWidget {
  const InningCounter ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final inningCount = ref.watch(gameStateProvider.select((state) => state.inningCount));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: const Color.fromARGB(134, 0, 0, 0).withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$inningCount',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class TimerBar extends ConsumerStatefulWidget {
  final int duration;
  const TimerBar ({
    super.key,
    this.duration = 40,
  });


  
  @override
  ConsumerState<TimerBar> createState() => TimerBarState();
}

class TimerBarState extends ConsumerState<TimerBar> {
  
  late int remainingSeconds;
  Timer? myTimer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.duration;
    startTimer();
  }


  void startTimer(){
    myTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0 && !isPaused){
        setState(() {
          remainingSeconds--;
        });
      } else if (remainingSeconds <= 0) {
        timer.cancel();
      }
    });
  }


  void pauseTimer(){
    if (myTimer?.isActive ?? false) {
      print('Pausing timer');
      isPaused = true;
      myTimer?.cancel();
    } else {
      print('Timer is not active or already paused');
    }
  }

  void resumeTimer(){
    if(isPaused && remainingSeconds > 0) {
      print('Resuming timer');
      isPaused = false;
      myTimer?.cancel();
      myTimer = Timer.periodic(const Duration(seconds:1), (timer) {
        if (remainingSeconds > 0 && !isPaused) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          timer.cancel();
        }
      });
    } else {
      print('Cannot resume: not paused or timer finished');
    }
  }

  void resetTimer(){
    myTimer?.cancel();
    setState(() {
      remainingSeconds = widget.duration;
      isPaused = false;
    });
    startTimer();
  }

  @override
  void dispose() {
    myTimer?.cancel();
    super.dispose();
  }

  Color _getSegmentColor (int index, int duration, int remainingSeconds, bool isActive) {
    Color baseColor;

    if (duration == 40) {
      int second = duration - index;
      if (second >= 25 && second <= 40) {
        baseColor = Colors.green;
      } else if (second >= 11 && second <= 24){
        baseColor = Colors.amber;
      } else if (second >=1 && second <= 10) {
        baseColor = Colors.red;
      } else {
        baseColor = Colors.grey;
      }
    } else if (duration == 30) {
      int second = duration - index;
      if (second >= 21 && second <= 30){
        baseColor = Colors.green;
      } else if (second >= 11 && second <=20) {
        baseColor = Colors.amber;
      } else if (second >= 1 && second <=10) {
        baseColor = Colors.red;
      } else {
        baseColor = Colors.grey;
      }
    } else {
      if (isActive) {
        baseColor = remainingSeconds > 20
            ? Colors.green
            : remainingSeconds >= 10
                ? Colors.amber
                : Colors.red;
      } else {
        return Colors.grey.withValues(alpha: 0.90);
      }
    }

    return isActive ? baseColor: Colors.grey.withValues(alpha: 0.90);
  }

  Color _getTextColor(int duration, int remainingSeconds, bool isPaused){

    if (isPaused || remainingSeconds <= 0) {
      return Colors.grey.withValues(alpha: 0.90);
      }
    Color textColor;

    if (duration == 40) {
      if (remainingSeconds >= 25 && remainingSeconds <= 40){
        textColor = Colors.green;
      } else if (remainingSeconds >= 11 && remainingSeconds <= 24){
        textColor = Colors.amber;
      } else if (remainingSeconds >= 1 && remainingSeconds <= 10) {
        textColor = Colors.red;
      } else {
        textColor = Colors.grey;
      }
    } else if (duration == 30) {
      if (remainingSeconds >= 21 && remainingSeconds <= 30){
        textColor = Colors.green;
      } else if (remainingSeconds >= 11 && remainingSeconds <= 20){
        textColor = Colors.amber;
      } else if (remainingSeconds >= 1 && remainingSeconds <= 10) {
        textColor = Colors.red;
      } else {
        textColor = Colors.grey;
      }      
    } else {
      if (remainingSeconds > 20) {
        textColor = Colors.green;
      } else if (remainingSeconds >= 10) {
        textColor = Colors.amber;
      } else {
        textColor = Colors.red;
      }
    }

    return textColor;
  }

  @override
  Widget build(BuildContext context) {
  ref.listen(resetTimerProvider, (previous, next){
    if(next is AsyncData<bool>){
      final shouldReset = next.value;
      if(shouldReset){
        resetTimer();
      }
    }
  });
  ref.listen<String?>(timerActionProvider, (previous,action){
    if(action == 'pause') pauseTimer();
    if(action == 'resume') resumeTimer();
    ref.read(timerActionProvider.notifier).state = null;
  });


    print('Building with remainingSeconds: $remainingSeconds');
    return LayoutBuilder(
      builder: (context, constraints) {
        const double paddingTimer = 8.0;
        
        return Padding(
          padding: const EdgeInsets.all(paddingTimer),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [BoxShadow(
                color: Colors.black,
                spreadRadius: 2,
                blurRadius: 5,
              )]
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(widget.duration, (index) {
                      final isActive = index >= (widget.duration - remainingSeconds);
                      final color = _getSegmentColor(index, widget.duration, remainingSeconds, isActive);
                      return Expanded(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds:800),
                          height: 40,
                          decoration: BoxDecoration(
                            border : Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1),
                            color: color
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  width: 25.0,
                  child: Text(
                    '$remainingSeconds',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(widget.duration,remainingSeconds, isPaused),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
