import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/game_state.dart';

// GAME STATE PROVIDER

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>(
  (ref) => GameStateNotifier(ref, p1Handicap: 45, p2Handicap: 30, p1Extensions: 2, p2Extensions: 5, equalizingInnings:true),
);

//Providers to signal resetTimer()
final resetTimerController = StreamController<bool>.broadcast();

final resetTimerProvider = StreamProvider.autoDispose<bool>((ref) {
  ref.onDispose(() {
    resetTimerController.close();
  });
  return resetTimerController.stream;
});

final timerActionProvider = StateProvider<String?> ((ref) => null);

