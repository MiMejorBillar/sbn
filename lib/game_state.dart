import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/riverpod/providers.dart';

class GameState {
  final int currentPlayer;
  final List<int> p1History;
  final List<int> p2History;
  final int inningCount;
  final int p1TotalScore;
  final int p2TotalScore;
  final int p1HighRun;
  final int p2HighRun;

  GameState({
    this.currentPlayer = 1,
    this.p1History = const [],
    this.p2History = const [],
    this.inningCount = 1,
    this.p1TotalScore = 0,
    this.p2TotalScore = 0,
    this.p1HighRun = 0,
    this.p2HighRun = 0,
  });

  GameState copyWith({
    int? currentPlayer,
    List<int>? p1History,
    List<int>? p2History,
    int? inningCount,
    int? p1TotalScore,
    int? p2TotalScore,
    int? p1HighRun,
    int? p2HighRun,
  }) {
    return GameState(
      currentPlayer: currentPlayer ?? this.currentPlayer,
      p1History: p1History ?? this.p1History,
      p2History: p2History ?? this.p2History,
      inningCount: inningCount ?? this.inningCount,
      p1TotalScore: p1TotalScore ?? this.p1TotalScore,
      p2TotalScore: p2TotalScore ?? this.p2TotalScore,
      p1HighRun: p1HighRun ?? this.p1HighRun,
      p2HighRun: p2HighRun ?? this.p2HighRun,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  final Ref ref;

  GameStateNotifier(this.ref) : super(GameState());


  bool endTurn(int player, int points) {
    if (state.currentPlayer != player) {
      return false;
    }

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
    );
    resetTimerController.add(true);

    if (state.p1History.length == state.p2History.length) {
      state = state.copyWith(inningCount: state.inningCount + 1);
    }
    return true;
  }
}