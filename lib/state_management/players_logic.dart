import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier() : super(presetPlayers);

  void addPlayer(Player player) {
    state = [...state, player];
  }

  void removePlayer(String name) {
    state = state.where((player) => player.name != name).toList();
  }
}