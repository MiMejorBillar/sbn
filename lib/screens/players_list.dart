import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsb/screens/add_player.dart';
import '../state_management/providers.dart';

class PlayersList extends ConsumerWidget {
  const PlayersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    onPressed: () {
                      playersNotifier.removePlayer(player.name);
                    },
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AddPlayer(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
