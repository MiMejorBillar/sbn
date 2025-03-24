import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for Player's 1 points history
final p1PointsHistoryProvider = StateProvider<List<int>>((ref) => []);

// Provider for Player's 2 points history
final p2PointsHistoryProvider = StateProvider<List<int>>((ref) => []);

// Computed Provider for Player 1's total score
final p1TotalScoreProvider = Provider<int>((ref) {
  final history = ref.watch(p1PointsHistoryProvider);
  return history.fold(0, (sum, points) => sum + points);
});

// Computed Provider for Player 2's total score
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
