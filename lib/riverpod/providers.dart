import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/game_state.dart';

// GAME STATE PROVIDER

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>(
  (ref) => GameStateNotifier(
    ref,
    p1Name: 'Jose Luis Perales',
    p2Name: 'Juan Gabriel',
    p1Handicap: 15,
    p2Handicap: 20,
    p1Extensions: 2,
    p2Extensions: 2,
    equalizingInnings: false,
    timerDuration: 40,
  ),
);

// PLAYER MANAGEMENT ////////////
class Player {
  final String name;
  final int handicap;
  Player({required this.name, required this.handicap});
}

final playersProvider =
    StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  return PlayersNotifier();
});

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier() : super([]);

  void addPlayer(Player player) {
    state = [...state, player];
  }

  void removePlayer(String name) {
    state = state.where((player) => player.name != name).toList();
  }
}
