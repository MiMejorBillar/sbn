import 'package:flutter_riverpod/flutter_riverpod.dart';

// History for both players
final p1PointsHistoryProvider = StateProvider<List<int>>((ref) => []);

final p2PointsHistoryProvider = StateProvider<List<int>>((ref) => []);

// Total Score for both players
final p1TotalScoreProvider = Provider<int>((ref) {
  final history = ref.watch(p1PointsHistoryProvider);
  return history.fold(0, (sum, points) => sum + points);
});


final p2TotalScoreProvider = Provider<int>((ref) {
  final history = ref.watch(p2PointsHistoryProvider);
  return history.fold(0, (sum, points) => sum + points);
});

// Provider for the inning count, starting at 1
final inningCountProvider = StateProvider<int>((ref) => 1);

// Provider for Player 1's turn status, initially false which means that turn isn't ended.
final p1TurnEndedProvider = StateProvider<bool>((ref) => false);

// Provider for Player 2's turn status, initially false which means that turn isn't ended.
final p2TurnEndedProvider = StateProvider<bool>((ref) => false);

final bothTurnsEndedProvider = Provider<bool>((ref) {
  final p1Ended = ref.watch(p1TurnEndedProvider);
  final p2Ended = ref.watch(p2TurnEndedProvider);
  return p1Ended && p2Ended;
});


//Averages

final p1AverageProvider = Provider<double>((ref) {
  final history = ref.watch(p1PointsHistoryProvider);
  if (history.isEmpty) {
    return 0.0;
  }
  final totalPoints = ref.watch(p1TotalScoreProvider);
  return totalPoints / history.length;
});

final p2AverageProvider = Provider<double>((ref) {
  final history = ref.watch(p2PointsHistoryProvider);
  if (history.isEmpty) {
    return 0.0;
  }
  final totalPoints = ref.watch(p2TotalScoreProvider);
  return totalPoints / history.length;
});

// HR

final p1HighRunProvider = Provider<int>((ref) {
  final history = ref.watch(p1PointsHistoryProvider);
  if (history.isEmpty) {
    return 0;
  }
  return history.reduce((a, b) => a > b ? a : b);
});

final p2HighRunProvider = Provider<int>((ref) {
  final history = ref.watch(p2PointsHistoryProvider);
  if (history.isEmpty) {
    return 0;
  }
  return history.reduce((a, b) => a > b ? a : b);
});