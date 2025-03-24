import 'package:flutter/material.dart';
import 'dart:async';

class Scorecard extends StatefulWidget {

  const Scorecard ({
    super.key,
    this.playerName = 'Luis',
    this.handicap = 8,
    this.extensions = 2,
    this.isP2 = false,
    this.timerBarKey,
    });

  final String playerName;
  final int handicap;
  final int extensions;
  final bool isP2;
  final GlobalKey<TimerBarState>? timerBarKey;

  @override
  State<Scorecard> createState() => ScorecardState();
}



class ScorecardState extends State<Scorecard> {
  int _score = 0;
  double _average = 0;
  int _highRun = 0;
  int pendingPoints = 0;


Color _contColor(bool isP2){
  if (isP2 == false){
    return Colors.white;
  } else {
    return Colors.amber;
  }
}

void _endTurn() {
  setState(() {
    _score += pendingPoints;
    pendingPoints = 0;
  });
  widget.timerBarKey?.currentState?.resetTimer();
}

  @override
  Widget build(BuildContext context){
    return Container(
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
                    widget.isP2 ? 'assets/icons/creeper.png' :  'assets/icons/trophy.png' ,
                    width: 50,
                  )
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: Text(
                      widget.playerName,
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold, 
                        color: _contColor(widget.isP2)
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  decoration: BoxDecoration(),
                  child: Text(
                    '${widget.handicap}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold, 
                      color: _contColor(widget.isP2)
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SCORE AND EXTENSION
          Expanded(
            child: GestureDetector(
              onTap: () {
                _endTurn();
              },
              child: Container(
                color: _contColor(widget.isP2),
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
                                  '$_score',
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
                                widget.extensions,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  width: 32,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
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
              )
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
                                    fontSize: 16, color: _contColor(widget.isP2))),
                            Text(
                              _average.toStringAsFixed(3),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _contColor(widget.isP2)),
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
                                    fontSize: 16, color: _contColor(widget.isP2))),
                            Text(
                              '$_highRun',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _contColor(widget.isP2)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                Container(
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pendingPoints++;                            
                          });
                        },
                        child: Container(  
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          width: 100,
                          child: Text(
                            '$pendingPoints',
                            style: TextStyle(
                              color: _contColor(widget.isP2),
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
                              pendingPoints--;
                            }
                          });
                        },
                        child: Image.asset(widget.isP2 ? 'assets/icons/ybi.png' : 'assets/icons/wbi.png'))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],  
      ),
    );
  }
}

class InningCounter extends StatefulWidget {
  const InningCounter ({
    super.key
  });

  @override
  State<InningCounter> createState() => InningCounterState();
}

class InningCounterState extends State<InningCounter> {
  final int inning = 20;

  @override
  Widget build(BuildContext context){
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
            '$inning',
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

class TimerBar extends StatefulWidget {
  const TimerBar ({
    super.key,
    this.duration = 40,
  });

  final int duration;
  
  @override
  State<TimerBar> createState() => TimerBarState();
}

class TimerBarState extends State<TimerBar> {
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
  print('Building with remainingSeconds: $remainingSeconds');
  return LayoutBuilder(
    builder: (context, constraints) {
      const double paddingHorizontal = 8.0;
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: List.generate(widget.duration, (index) {
                    final isActive = index >= (widget.duration - remainingSeconds);
                    final color = _getSegmentColor(index, widget.duration, remainingSeconds, isActive);
                    return Expanded(
                      child: Container(
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
