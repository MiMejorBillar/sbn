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
  final String icon; 
  Player({required this.name, required this.handicap, required this.icon});
}
final List<Player> presetPlayers = [
  Player(name: 'Luis', handicap: 20, icon: 'assets/flags/peru.png'),
  Player(name: 'Seddy Merckx', handicap: 18, icon: 'assets/flags/canada.png'),
  Player(name: 'Kyungoh', handicap: 22, icon: 'assets/flags/korea.png'),
  Player(name: 'Shinpata', handicap: 18, icon: 'assets/flags/korea.png'),
  Player(name: 'Jongnetti', handicap: 15, icon: 'assets/flags/korea.png'),
];
final playersProvider =
    StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  return PlayersNotifier();
});

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier() : super(presetPlayers);

  void addPlayer(Player player) {
    state = [...state, player];
  }

  void removePlayer(String name) {
    state = state.where((player) => player.name != name).toList();
  }
}
