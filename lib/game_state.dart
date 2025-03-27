import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/riverpod/providers.dart';

class GameState {
  final String? p1Name;
  final String? p2Name;
  final int currentPlayer;
  final List<int> p1History;
  final List<int> p2History;
  final int inningCount;
  final bool isFirstTurnTaken;
  final int p1TotalScore;
  final int p2TotalScore;
  final int p1HighRun;
  final int p2HighRun;
  final int p1PendingPoints;
  final int p2PendingPoints;
  final int p1Handicap;
  final int p2Handicap;
  final int p1Extensions;
  final int p2Extensions;
  final int p1UsedExtensions;
  final int p2UsedExtensions;
  final String p1BallColor;
  final String p2BallColor;
  final bool equalizingInnings;
  final String? matchResult;

  GameState({
    this.p1Name = 'Player 1',
    this.p2Name = 'Player 2',
    this.currentPlayer = 1,
    this.p1History = const [],
    this.p2History = const [],
    this.inningCount = 1,
    this.isFirstTurnTaken = false,
    this.p1TotalScore = 0,
    this.p2TotalScore = 0,
    this.p1HighRun = 0,
    this.p2HighRun = 0,
    this.p1PendingPoints = 0,
    this.p2PendingPoints = 0,
    this.p1Handicap = 40,
    this.p2Handicap = 40,
    this.p1Extensions = 2,
    this.p2Extensions = 2,
    this.p1UsedExtensions = 0,
    this.p2UsedExtensions = 0,
    this.p1BallColor = 'white',
    this.p2BallColor = 'yellow',
    this.equalizingInnings = true,
    this.matchResult,
  });

  GameState copyWith({
    String? p1Name,
    String? p2Name,
    int? currentPlayer,
    List<int>? p1History,
    List<int>? p2History,
    int? inningCount,
    bool? isFirstTurnTaken,
    int? p1TotalScore,
    int? p2TotalScore,
    int? p1HighRun,
    int? p2HighRun,
    int? p1PendingPoints,
    int? p2PendingPoints,
    int? p1Handicap,
    int? p2Handicap,
    int? p1Extensions,
    int? p2Extensions,
    int? p1UsedExtensions,
    int? p2UsedExtensions,
    String? p1BallColor,
    String? p2BallColor,
    bool? equalizingInnings,
    String? matchResult,
  }) {
    return GameState(
      p1Name: p1Name ?? this.p1Name,
      p2Name: p2Name ?? this.p2Name,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      p1History: p1History ?? this.p1History,
      p2History: p2History ?? this.p2History,
      inningCount: inningCount ?? this.inningCount,
      isFirstTurnTaken: isFirstTurnTaken ?? this.isFirstTurnTaken,
      p1TotalScore: p1TotalScore ?? this.p1TotalScore,
      p2TotalScore: p2TotalScore ?? this.p2TotalScore,
      p1HighRun: p1HighRun ?? this.p1HighRun,
      p2HighRun: p2HighRun ?? this.p2HighRun,
      p1PendingPoints: p1PendingPoints ?? this.p1PendingPoints,
      p2PendingPoints: p2PendingPoints ?? this.p2PendingPoints,
      p1Handicap: p1Handicap ?? this.p1Handicap,
      p2Handicap: p2Handicap ?? this.p2Handicap,
      p1Extensions: p1Extensions ?? this.p1Extensions,
      p2Extensions: p2Extensions ?? this.p2Extensions,
      p1UsedExtensions: p1UsedExtensions ?? this.p1UsedExtensions,
      p2UsedExtensions: p2UsedExtensions ?? this.p2UsedExtensions,
      p1BallColor: p1BallColor ?? this.p1BallColor,
      p2BallColor: p2BallColor ?? this.p2BallColor,
      equalizingInnings: equalizingInnings ?? this.equalizingInnings,
      matchResult: matchResult ?? this.matchResult,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  final Ref ref;
  List<GameState> stateHistory = [];
  int? potentialWinner;

  GameStateNotifier(
    this.ref, {
      String p1Name = 'Player 1',
      String p2Name = 'Player 2',
      int p1Handicap = 40, 
      int p2Handicap = 40, 
      int p1Extensions = 2, 
      int p2Extensions = 2, 
      bool equalizingInnings = true
  }) : super(GameState(
        p1Name: p1Name,
        p2Name: p2Name,
        p1Handicap: p1Handicap, 
        p2Handicap: p2Handicap, 
        p1Extensions: p1Extensions,
        p2Extensions: p2Extensions,
        equalizingInnings:equalizingInnings 
      ));

  void updatePendingPoints(int player, int points){
    if (player == 1) {
      state = state.copyWith(p1PendingPoints: points);
    } else {
      state = state.copyWith(p2PendingPoints: points);
    }
  }

  void useExtension() {
    if(state.currentPlayer == 1 && state.p1UsedExtensions < state.p1Extensions) {
      state = state.copyWith(p1UsedExtensions: state.p1UsedExtensions + 1);
      resetTimerController.add(true);
    } else if (state.currentPlayer == 2 && state.p2UsedExtensions < state.p2Extensions){
      state = state.copyWith(p2UsedExtensions: state.p2UsedExtensions + 1);
      resetTimerController.add(true);
    }      
  }
  void setBallColors(String p1BallColor, String p2BallColor){
    state = state.copyWith(p1BallColor: p1BallColor, p2BallColor: p2BallColor);
  }

  bool endTurn(int player) {
    if (state.currentPlayer != player) {
      return false;
    }

    stateHistory.add(state.copyWith());

    final points = player == 1 ? state.p1PendingPoints : state.p2PendingPoints;

    List<int> newHistory;
    int newTotalScore;
    int newHighRun;

    if(player == 1) {
      newHistory = [...state.p1History, points];
      newTotalScore = newHistory.fold(0, (sum, p) => sum + p);
      newHighRun = newHistory.isEmpty ? 0 : newHistory.reduce((a,b) => a > b ? a : b);
    } else {
      newHistory = [...state.p2History, points];
      newTotalScore = newHistory.fold(0, (sum, p) => sum + p);
      newHighRun = newHistory.isEmpty ? 0 : newHistory.reduce((a,b) => a > b ? a : b);      
    }

    state = state.copyWith(
      currentPlayer: player == 1 ? 2 : 1,
      p1History: player == 1 ? newHistory : state.p1History,
      p2History: player == 2 ? newHistory : state.p2History,
      p1TotalScore: player == 1 ? newTotalScore : state.p1TotalScore,
      p2TotalScore: player == 2 ? newTotalScore : state.p2TotalScore,
      p1HighRun: player == 1 ? newHighRun : state.p1HighRun,
      p2HighRun: player == 2 ? newHighRun : state.p2HighRun,
      p1PendingPoints: player == 1 ? 0 : state.p1PendingPoints,
      p2PendingPoints: player == 2 ? 0 : state.p2PendingPoints,
      isFirstTurnTaken: state.isFirstTurnTaken || player == 1,
    );
    resetTimerController.add(true);

    if (state.p1History.length == state.p2History.length) {
      state = state.copyWith(inningCount: state.inningCount + 1);
    }
    print('Player $player ended turn. P1 Score: ${state.p1TotalScore}, P2 Score: ${state.p2TotalScore}');
    checkMatchEnd();
    return true;
  }

  void undo() {
    if (stateHistory.isNotEmpty) {
      state = stateHistory.removeLast();

      if (state.p1History.isEmpty && state.p2History.isEmpty) {
        state = state.copyWith(
          isFirstTurnTaken: false,
          p1BallColor: 'white',
          p2BallColor: 'yellow'
          );
      }
    }
  }

  void checkMatchEnd() {
    final p1Reached = state.p1TotalScore >= state.p1Handicap;
    final p2Reached = state.p2TotalScore >= state.p2Handicap;
    print('Check match end: P1 Score: ${state.p1TotalScore}/${state.p1Handicap}, P2 Score: ${state.p2TotalScore}/${state.p2Handicap}, Potential Winner: $potentialWinner, Current Player: ${state.currentPlayer}');
    //Allowed Equalizing innings
    if (state.equalizingInnings){
      //No one has potentially won yet
      if(potentialWinner == null) {
        if(p1Reached && !p2Reached) {
          potentialWinner = 1;
          print('P1 reached first, potentialWinner set to 1');
        } else if(p2Reached) {
          _endMatch('P2');
          print('P2 reached first, ending with P2 win');
        }
      } else if (potentialWinner == 1 && state.currentPlayer == 1) {
        if (p2Reached){
          _endMatch('draw');
          print('P2 also reached, ending with draw');
        } else {
          _endMatch('P1');
          print('P2 did not reach, ending with P1 win');
        }
        potentialWinner = null;
      }
    } else {
      //No equalizing innings
      if (p1Reached) {
        _endMatch('P1');
        print('No equalizing, P1 wins');
      } else if (p2Reached) {
        _endMatch('P2');
        print('No equalizing, P2 wins');
      }
    }
  }
  void _endMatch(String result){
    print('Match ended with result: $result');
    print('Player 1: ${state.p1Name} used ${state.p1BallColor} ball');
    print('Player 2: ${state.p2Name} used ${state.p2BallColor} ball');
    state = state.copyWith(matchResult: result);
    potentialWinner = null;
  }

  void resetGame({int? p1Handicap, int? p2Handicap, bool? equalizingInnings}) {
    stateHistory.clear();
    potentialWinner = null;
    state = GameState(
      p1Handicap: p1Handicap ?? state.p1Handicap,
      p2Handicap: p2Handicap ?? state.p2Handicap,
      equalizingInnings: equalizingInnings ?? state.equalizingInnings,
      p1Name: state.p1Name,
      p2Name: state.p2Name,
    );
    resetTimerController.add(true);
  }
}