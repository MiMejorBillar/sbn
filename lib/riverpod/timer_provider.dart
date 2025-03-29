import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/game_state.dart';
import 'package:nsb/riverpod/providers.dart';

class TimerState{
  final int remainingSeconds;
  final bool isPaused;

  TimerState({required this.remainingSeconds, this.isPaused = false});
  TimerState copyWith({int? remainingSeconds, bool? isPaused}) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isPaused: isPaused ?? this.isPaused
      );
  }
}

class TimerStateNotifier extends StateNotifier<TimerState> {
  final Ref ref;
  Timer? _timer;
  int _currentDuration; // dynamic duration
  bool _isDelayedResetting = false;

  TimerStateNotifier(this.ref)
      : _currentDuration = ref.read(gameStateProvider).timerDuration,
      super(TimerState(remainingSeconds: ref.read(gameStateProvider).timerDuration)) {

        ref.listen<GameState>(gameStateProvider, (previous, next) {
          if(next.timerDuration !=_currentDuration){
            _currentDuration = next.timerDuration;
          }
        });
      }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPaused && state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else if (state.remainingSeconds <= 0){
        timer.cancel();
      }
    });
  }

  void pause() {
    if(!state.isPaused) {
      state = state.copyWith(isPaused: true);
      _timer?.cancel();
    }
  }

  void resume() {
    if(state.isPaused){
      state = state.copyWith(isPaused: false);
      _startTimer();
    }
  }

  void quickReset() {
    _timer?.cancel();
    state = state.copyWith(remainingSeconds: _currentDuration, isPaused: false);
    _startTimer();
  }

  void delayedReset() {
    _isDelayedResetting = true;
    _timer?.cancel();
    print('delayedReset called with duration: $_currentDuration');
    state = state.copyWith(remainingSeconds: _currentDuration , isPaused: false);
    Future.delayed(const Duration(seconds: 3), (){
      _startTimer();
      _isDelayedResetting = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
// Provider definition(default duration of 40 seconds)
final timerStateProvider = StateNotifierProvider<TimerStateNotifier, TimerState>
  ((ref) => TimerStateNotifier(ref),
);
final timerActionProvider = StateProvider<String?>((ref) => null);