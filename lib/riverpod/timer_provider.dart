import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/game_state.dart';
import 'package:nsb/riverpod/providers.dart';

class TimerState {
  final int remainingSeconds;
  final int initialDuration;
  final bool isPaused;
  final bool isResetting;

  TimerState({
    required this.remainingSeconds,
    required this.initialDuration,
    this.isPaused = false,
    this.isResetting = false,
  });

  TimerState copyWith({
    int? remainingSeconds,
    int? initialDuration,
    bool? isPaused,
    bool? isResetting,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds, 
      initialDuration: initialDuration ?? this.initialDuration,
      isPaused: isPaused ?? this.isPaused,
      isResetting: isResetting ?? this.isResetting,
    );
  }
}

class TimerStateNotifier extends StateNotifier<TimerState> {
  final Ref ref;
  Timer? _timer;

  TimerStateNotifier(this.ref)
      : super(TimerState(
        remainingSeconds: ref.read(gameStateProvider).timerDuration,
        initialDuration: ref.read(gameStateProvider).timerDuration,
      )) {
        ref.listen<GameState>(gameStateProvider,(previous,next){
          if (next.timerDuration != state.initialDuration) {
            state = state.copyWith(
              initialDuration: next.timerDuration,
              remainingSeconds: next.timerDuration,
            );
            quickReset();
        }
    });        
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!state.isPaused && state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else if (state.remainingSeconds <= 0) {
        _timer?.cancel();
      }
    });
  }

  void pause() {
    if (!state.isPaused) {
      state = state.copyWith(isPaused: true);
      _timer?.cancel();
    }
  }

  void resume() {
    if(state.isPaused) {
      state = state.copyWith(isPaused: false);
      _startTimer();
    }
  }

  void quickReset() {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: state.initialDuration,
      isPaused: false,
      isResetting: false,
    );
    _startTimer();
  }

  void delayedReset(){
    if (state.isResetting) return;
    state = state.copyWith(isResetting: true);
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: state.initialDuration,
      isPaused: false,
    );
    Future.delayed(Duration(seconds: 3), () {
      _startTimer();
      state = state.copyWith(isResetting: false);
    });
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }
}

final timerStateProvider = StateNotifierProvider<TimerStateNotifier, TimerState>(
  (ref)=> TimerStateNotifier(ref),
);
