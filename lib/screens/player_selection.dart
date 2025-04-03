import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/providers.dart';

class PlayersSelectionDialog extends ConsumerStatefulWidget {
  const PlayersSelectionDialog({super.key});

  @override
  ConsumerState<PlayersSelectionDialog> createState() =>
      _PlayersSelectionDialogState();
}

class _PlayersSelectionDialogState
    extends ConsumerState<PlayersSelectionDialog> {
  String? selectedP1;
  String? selectedP2;
  String? selectedIconP1;
  String? selectedIconP2;
  int? selectedHandicapP1;
  int? selectedHandicapP2;
  bool equalizingInnings = true;
  int selectedDuration = 40;
  int selectedExtension = 3;

  final List<int> durationOptions = [25, 30, 40];
  final List<int> extensionOptions = [2, 3, 5];

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    print('Building dialog: selectedDuration=$selectedDuration, selectedExtension=$selectedExtension');
    if (players.isEmpty) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No players available. Add players in the Players List'),
        ),
      );
    }
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Players and Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Player 1'),
                value: selectedP1,
                items: players
                    .map((player) => DropdownMenuItem(
                          value: player.name,
                          child: Text(
                              '${player.name} (handicap : ${player.handicap})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedP1 = value;
                    selectedHandicapP1 =
                        players.firstWhere((p) => p.name == value).handicap;
                    selectedIconP1 = 
                        players.firstWhere((p) => p.name == value).icon;
                      if (selectedP2 == value) {
                        selectedP2 = null;
                      }
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Player 2'),
                value: selectedP2,
                items: players
                    .where((player) => player.name != selectedP1)
                    .map((player) => DropdownMenuItem(
                          value: player.name,
                          child: Text(
                              '${player.name} (handicap : ${player.handicap})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedP2 = value;
                    selectedHandicapP2 =
                        players.firstWhere((p) => p.name == value).handicap;
                    selectedIconP2 = players.firstWhere((p) => p.name == value).icon;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Timer Duration'),
                value: selectedDuration,
                items: durationOptions
                    .map((duration) => DropdownMenuItem(
                          value: duration,
                          child: Text('$duration'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDuration = value!;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Extensions'),
                value: selectedExtension,
                items: extensionOptions
                    .map((extension) => DropdownMenuItem(
                          value: extension,
                          child: Text('$extension')
                        ))
                      .toList(), 
                onChanged: (value) {
                  setState(() {
                    selectedExtension = value!;
                    print('Extensions changed to: $selectedExtension');  
                  });
                }
              ),
              const SizedBox(
                height: 16,
              ),
              SwitchListTile(
                title: const Text('Equalizing Innings'),
                value: equalizingInnings,
                onChanged: (value) {
                  setState(() {
                    equalizingInnings = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedP1 != null &&
                          selectedP2 != null &&
                          selectedP1 != selectedP2) {
                        ref.read(gameStateProvider.notifier).startNewGame(
                            p1Name: selectedP1!,
                            p2Name: selectedP2!,
                            iconP1: selectedIconP1!,
                            iconP2: selectedIconP2!,
                            p1Handicap: selectedHandicapP1!,
                            p2Handicap: selectedHandicapP2!,
                            p1Extensions: selectedExtension,
                            p2Extensions: selectedExtension,
                            equalizingInnings: equalizingInnings,
                            timerDuration: selectedDuration);
                            print('startNewGame is called');
                            print(
                            'startNewGame called with extensions: $selectedExtension');
                        Navigator.of(context).pop(true);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please select two different players'),
                        ));
                      }
                    },
                    child: const Text('Start Match'),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
