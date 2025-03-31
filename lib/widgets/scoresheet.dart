import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:nsb/state_management/game_state.dart';
import 'package:share_plus/share_plus.dart';

Future<String> generateScoresheetPdf(GameState gameState) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Match Scoresheet',
              style: pw.TextStyle (fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Player 1: ${gameState.p1Name}'),
            pw.Text('Player 2: ${gameState.p2Name}'),
            pw.Text('Match Result: ${gameState.matchResult ?? "In Progress"}'),
            pw.SizedBox(height:20),
            pw.Text('Scores:'),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationCacheDirectory();
  final filePath = '${directory.path}/scoresheet.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return filePath;

  // TO SHARE THE File
  // final scoresheet = await Share.shareXFiles([XFile(filePath)], text: 'Here is the scoresheet');
  // if (scoresheet.status == ShareResultStatus.success) {
  //   print('Thank you for sharing the scoresheet');
  // }
}
