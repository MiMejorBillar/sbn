import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/providers.dart';

class AddPlayer extends ConsumerStatefulWidget{
  const AddPlayer({super.key});

  @override
  ConsumerState<AddPlayer> createState() => AddPlayerState();
}

class AddPlayerState extends ConsumerState<AddPlayer> {
  String? errorMessage;
  late TextEditingController nameController;
  late TextEditingController handicapController;

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController();
    handicapController = TextEditingController();
  }

  @override
  void dispose(){
    nameController.dispose();
    handicapController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    final playersNotifier = ref.read(playersProvider.notifier);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Players',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'New Player Name'),
              onChanged: (value) {
                if (errorMessage != null) {
                  setState(() {
                    errorMessage = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16,),
            TextFormField(
              controller: handicapController,
              decoration: const InputDecoration(labelText: 'Handicap'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if(errorMessage != null) {
                  setState(() {
                    errorMessage = null;
                  });
                }
              },
            ),
            if(errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:  () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(height: 16,),
                  TextButton(
                    onPressed: () {
                      String name = nameController.text.trim();
                      String handicapText = handicapController.text.trim();

                      if (name.isEmpty || handicapText.isEmpty) {
                        setState(() {
                          errorMessage = 'Please enter both name and handicap';
                        });
                        return;
                      }
                      int? handicap = int.tryParse(handicapText);
                      if (handicap == null) {
                        setState(() {
                          errorMessage = 'Invalid handicap value';
                        });
                        return;
                      }
                      playersNotifier.addPlayer(Player(name: name, handicap:handicap));
                      Navigator.of(context).pop();
                    } ,
                    child: const Text('Add') ,
                  ),
                ],
              ),
          ],
        )
      )
    );
  }
}