import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/providers.dart';

class PlayersSelectionDialog extends ConsumerStatefulWidget {
  const PlayersSelectionDialog({super.key});

  @override
  ConsumerState<PlayersSelectionDialog> createState() => _PlayersSelectionDialogState();
}

class _PlayersSelectionDialogState extends ConsumerState<PlayersSelectionDialog> {
  String? selectedP1;
  String? selectedP2;
  int? selectedHandicapP1;
  int? selectedHandicapP2;
  bool equalizingInnings = true;
  int selectedDuration = 40;

  final List<int> durationOptions = [25, 30, 40]; 

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    if (players.isEmpty) {
      return const Dialog(
        child:Padding(
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
                        child: Text('${player.name} (handicap : ${player.handicap})'),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedP1 = value;
                  selectedHandicapP1 = players.firstWhere((p) => p.name == value).handicap;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Player 2'),
              value: selectedP2,
              items: players
                  .map((player) => DropdownMenuItem(
                        value: player.name,
                        child: Text('${player.name} (handicap : ${player.handicap})'),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedP2 = value;
                  selectedHandicapP2 = players.firstWhere((p) => p.name == value).handicap;
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
            const SizedBox(height: 16,),
            SwitchListTile(
              title: const Text('Equalizing Innings'),
              value: equalizingInnings,
              onChanged: (value) {
                setState(() {
                  equalizingInnings = value;
                });
              },
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  } ,
                  child: const Text('Cancel') ,
                ),
                ElevatedButton(
                  onPressed: (){
                    if (selectedP1 != null && selectedP2 != null && selectedP1 != selectedP2) {
                      ref.read(gameStateProvider.notifier).resetGame(
                        p1Name: selectedP1,
                        p2Name: selectedP2,
                        p1Handicap: selectedHandicapP1,
                        p2Handicap: selectedHandicapP2,
                        equalizingInnings: equalizingInnings,
                        timerDuration: selectedDuration
                      );
                      Navigator.of(context).pop(true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select two different players'),
                        )
                      );
                    }
                  },
                  child: const Text('Start Match'),
                ),
              ],
            )                        
          ],
        ),
      )
    );
  }
}