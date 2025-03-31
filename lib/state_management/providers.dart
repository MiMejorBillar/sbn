import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/state_management/game_state.dart';
import '../state_management/players_logic.dart';
import '../state_management/timer_state.dart';

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

// PLAYERS PROVIDER ////////////

final playersProvider =
    StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  return PlayersNotifier();
});


// TIMER PROVIDER

final timerStateProvider = StateNotifierProvider<TimerStateNotifier, TimerState>(
  (ref)=> TimerStateNotifier(ref),
);
