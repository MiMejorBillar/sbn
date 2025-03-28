import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/providers.dart';

class PlayersList extends ConsumerWidget {
  const PlayersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final players = ref.watch(playersProvider);
    final playersNotifier = ref.read(playersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Players')),
      body: players.isEmpty
          ? const Center(child: Text('No players added yet'))
          : ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                title: Text(player.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: (){
                    playersNotifier.removePlayer(player.name);
                  },
                ),
              );
            }
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newPlayerName = '';
              return AlertDialog(
                title: const Text('Add Player'),
                content: TextField(
                  onChanged: (value) => newPlayerName = value,
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if(newPlayerName.isNotEmpty) {
                        playersNotifier.addPlayer(newPlayerName);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a name')
                          )
                        );
                      }
                    },
                    child: const Text('Add')
                  )
                ],
              );
            }
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}