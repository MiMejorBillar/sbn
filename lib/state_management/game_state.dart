import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/providers.dart';

class GameState {
  final String? p1Name;
  final String? p2Name;
  final String? iconP1;
  final String? iconP2;
  final int currentPlayer;
  final List<Turn> p1History;
  final List<Turn> p2History;
  final int inningCount;
  final bool isFirstTurnTaken;
  final int p1TotalScore;
  final int p2TotalScore;
  final int p1HighRun;
  final int p2HighRun;
  final int p1PendingPoints;
  final int p2PendingPoints;
  final String? handicapType;
  final int p1Handicap;
  final int p2Handicap;
  final int p1Extensions;
  final int p2Extensions;
  final int p1UsedExtensions;
  final int p2UsedExtensions;
  final String? p1BallColor;
  final String? p2BallColor;
  final bool equalizingInnings;
  final int timerDuration;
  final String? matchResult;
  final DateTime? matchStartTime;
  final DateTime? matchEndTime;

  double get p1Average =>
      p1History.isEmpty ? 0.0 : p1TotalScore / p1History.length;
  Duration get p1TotalTime =>
      p1History.fold(Duration.zero, (sum, turn) => sum + turn.duration);

  double get p2Average =>
      p2History.isEmpty ? 0.0 : p2TotalScore / p2History.length;
  Duration get p2TotalTime =>
      p2History.fold(Duration.zero, (sum, turn) => sum + turn.duration);      

  GameState({
    this.p1Name = 'Player 1',
    this.p2Name = 'Player 2',
    this.iconP1 = 'assets/flags/canada.png',
    this.iconP2 = 'assets/flags/korea.png',
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
    this.handicapType = 'fixed',
    this.p1Handicap = 40,
    this.p2Handicap = 40,
    this.p1Extensions = 2,
    this.p2Extensions = 2,
    this.p1UsedExtensions = 0,
    this.p2UsedExtensions = 0,
    this.p1BallColor = 'white',
    this.p2BallColor = 'yellow',
    this.equalizingInnings = true,
    this.timerDuration = 40,
    this.matchResult,
    this.matchStartTime,
    this.matchEndTime,
  });

  GameState copyWith({
    String? p1Name,
    String? p2Name,
    String? iconP1,
    String? iconP2,
    int? currentPlayer,
    List<Turn>? p1History,
    List<Turn>? p2History,
    int? inningCount,
    bool? isFirstTurnTaken,
    int? p1TotalScore,
    int? p2TotalScore,
    int? p1HighRun,
    int? p2HighRun,
    int? p1PendingPoints,
    int? p2PendingPoints,
    String? handicapType,
    int? p1Handicap,
    int? p2Handicap,
    int? p1Extensions,
    int? p2Extensions,
    int? p1UsedExtensions,
    int? p2UsedExtensions,
    String? p1BallColor,
    String? p2BallColor,
    bool? equalizingInnings,
    int? timerDuration,
    String? matchResult,
    DateTime? matchStartTime,
    DateTime? matchEndTime,
  }) {
    return GameState(
      p1Name: p1Name ?? this.p1Name,
      p2Name: p2Name ?? this.p2Name,
      iconP1: iconP1 ?? this.iconP1,
      iconP2: iconP2 ?? this.iconP2,
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
      handicapType: handicapType ?? this.handicapType,
      p1Handicap: p1Handicap ?? this.p1Handicap,
      p2Handicap: p2Handicap ?? this.p2Handicap,
      p1Extensions: p1Extensions ?? this.p1Extensions,
      p2Extensions: p2Extensions ?? this.p2Extensions,
      p1UsedExtensions: p1UsedExtensions ?? this.p1UsedExtensions,
      p2UsedExtensions: p2UsedExtensions ?? this.p2UsedExtensions,
      p1BallColor: p1BallColor ?? this.p1BallColor,
      p2BallColor: p2BallColor ?? this.p2BallColor,
      equalizingInnings: equalizingInnings ?? this.equalizingInnings,
      timerDuration: timerDuration ?? this.timerDuration,
      matchResult: matchResult ?? this.matchResult,
      matchStartTime: matchStartTime ?? this. matchStartTime,
      matchEndTime: matchEndTime ?? this.matchEndTime,
    );
  }
}

class Turn {
  final int score;
  final Duration duration;

  Turn({
    required this.score,
    required this.duration,
  });
}

class GameStateNotifier extends StateNotifier<GameState> {
  final Ref ref;
  DateTime? _currentTurnStartTime;
  List<GameState> stateHistory = [];
  int? potentialWinner;

  GameStateNotifier(
    this.ref, {
    String p1Name = 'Player 1',
    String p2Name = 'Player 2',
    String iconP1 = 'assets/flags/canada.png',
    String iconP2 = 'assets/flags/korea.png',
    int p1Handicap = 40,
    int p2Handicap = 40,
    int p1Extensions = 2,
    int p2Extensions = 2,
    bool equalizingInnings = true,
    int timerDuration = 40,
  }) : super(GameState(
          p1Name: p1Name,
          p2Name: p2Name,
          iconP1: iconP1,
          iconP2: iconP2,
          p1Handicap: p1Handicap,
          p2Handicap: p2Handicap,
          p1Extensions: p1Extensions,
          p2Extensions: p2Extensions,
          equalizingInnings: equalizingInnings,
          timerDuration: timerDuration,
        ));

  void updatePendingPoints(int player, int points) {
    if (player == 1) {
      state = state.copyWith(p1PendingPoints: points);
    } else {
      state = state.copyWith(p2PendingPoints: points);
    }
    ref.read(timerStateProvider.notifier).delayedReset();
  }

  void useExtension() {
    if (state.currentPlayer == 1 &&
        state.p1UsedExtensions < state.p1Extensions) {
      state = state.copyWith(p1UsedExtensions: state.p1UsedExtensions + 1);
      ref.read(timerStateProvider.notifier).quickReset();
    } else if (state.currentPlayer == 2 &&
        state.p2UsedExtensions < state.p2Extensions) {
      state = state.copyWith(p2UsedExtensions: state.p2UsedExtensions + 1);
      ref.read(timerStateProvider.notifier).quickReset();
    }
  }

  void setBallColors(String p1BallColor, String p2BallColor) {
    state = state.copyWith(p1BallColor: p1BallColor, p2BallColor: p2BallColor);
  }

  bool endTurn(int player) {
    if (state.currentPlayer != player) {
      return false;
    }

    stateHistory.add(state.copyWith());

    final points = player == 1 ? state.p1PendingPoints : state.p2PendingPoints;
    final duration = DateTime.now().difference(_currentTurnStartTime!);
    final newTurn = Turn(score: points, duration: duration);

    List<Turn> newHistory;
    int newTotalScore;
    int newHighRun;

    if (player == 1) {
      newHistory = [...state.p1History, newTurn];
      newTotalScore = newHistory.fold(0, (sum, turn) => sum + turn.score);
      newHighRun = newHistory.isEmpty 
          ? 0
          : newHistory.map((t) => t.score).reduce((a, b) => a > b ? a : b);
    } else {
      newHistory = [...state.p2History, newTurn];
      newTotalScore = newHistory.fold(0, (sum, turn) => sum + turn.score);
      newHighRun = newHistory.isEmpty 
          ? 0
          : newHistory.map((t) => t.score).reduce((a, b) => a > b ? a : b);
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
    checkMatchEnd();

    if (state.matchResult == null){
      ref.read(timerStateProvider.notifier).delayedReset();
    }
    

    if (state.p1History.length == state.p2History.length) {
      state = state.copyWith(inningCount: state.inningCount + 1);
    }
    
    startTurn();
    return true;
  }

  void undo() {
    if (stateHistory.isNotEmpty) {
      state = stateHistory.removeLast();

      if (state.p1History.isEmpty && state.p2History.isEmpty) {
        state = state.copyWith(
            isFirstTurnTaken: false,
            p1BallColor: 'white',
            p2BallColor: 'yellow');
      }
    }
  }

  void checkMatchEnd() {
    final p1Reached = state.p1TotalScore >= state.p1Handicap;
    final p2Reached = state.p2TotalScore >= state.p2Handicap;
    //Allowed Equalizing innings
    if (state.equalizingInnings) {
      //No one has potentially won yet
      if (potentialWinner == null) {
        if (p1Reached && !p2Reached) {
          potentialWinner = 1;
        } else if (p2Reached) {
          _endMatch('P2');
        }
      } else if (potentialWinner == 1 && state.currentPlayer == 1) {
        if (p2Reached) {
          _endMatch('draw');
        } else {
          _endMatch('P1');
        }
        potentialWinner = null;
      }
    } else {
      //No equalizing innings
      if (p1Reached) {
        _endMatch('P1');
      } else if (p2Reached) {
        _endMatch('P2');
      }
    }
  }

  //NEED TO ADD HANDICAP TYPE
  void _endMatch(String result) { 
    ref.read(timerStateProvider.notifier).stopTimer();
    state = state.copyWith(
      matchResult: result,
      matchEndTime: DateTime.now(),
      );
    potentialWinner = null;
    print('Timer stopped and matchended at print ${state.matchEndTime}');
    
  }

  void resetGame({
    String? p1Name,
    String? p2Name,
    int? p1Handicap,
    int? p2Handicap,
    bool? equalizingInnings,
    int? timerDuration,
  }) {
    stateHistory.clear();
    potentialWinner = null;
    state = GameState(
      p1Name: p1Name ?? state.p1Name,
      p2Name: p2Name ?? state.p2Name,
      p1Handicap: p1Handicap ?? state.p1Handicap,
      p2Handicap: p2Handicap ?? state.p2Handicap,
      equalizingInnings: equalizingInnings ?? state.equalizingInnings,
      timerDuration: timerDuration ?? state.timerDuration,
      matchStartTime: null,
      matchEndTime: null,
    );
    ref.read(timerStateProvider.notifier).quickReset();

  }

  void startNewGame({
    required String p1Name,
    required String p2Name,
    required String iconP1,
    required String iconP2,
    required int p1Handicap,
    required int p2Handicap,
    required bool equalizingInnings,
    required int timerDuration,
    required int p1Extensions,
    required int p2Extensions,
    required String handicapType,
    String p1BallColor = 'white',
    String p2BallColor = 'yellow',
  }) {
    stateHistory.clear();
    potentialWinner = null;
    state = GameState(
      p1Name: p1Name,
      p2Name: p2Name,
      iconP1: iconP1,
      iconP2: iconP2,
      p1Handicap: p1Handicap,
      p2Handicap: p2Handicap,
      equalizingInnings: equalizingInnings,
      timerDuration: timerDuration,
      p1Extensions: p1Extensions,
      p2Extensions: p2Extensions,
      handicapType: handicapType,
      p1BallColor: p1BallColor,
      p2BallColor: p2BallColor,
      matchStartTime: DateTime.now(),
      matchEndTime: null,
    );
    ref.read(timerStateProvider.notifier).delayedReset();
    startTurn();
    print("Match started at ${state.matchStartTime}");

  }

  void startTurn() {
    _currentTurnStartTime = DateTime.now();
  }
  
}

