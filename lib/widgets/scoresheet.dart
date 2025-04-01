import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:nsb/state_management/game_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

Future<String> generateScoresheetPdf(GameState gameState) async {
  final pdf = pw.Document();

  // final int completeInnings = gameState.p1History.length < gameState.p2History.length
  //     ? gameState.p1History.length
  //     : gameState.p2History.length;

  // final bool hasIncompleteInning = gameState.p1History.length > gameState.p2History.length;
  final String currentDataTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  const int maxInningsPerTable = 25;    

  pw.Widget buildInningTable(List<int> history, int startIndex, int endIndex){
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: pw.FixedColumnWidth(25),
        1: pw.FixedColumnWidth(25),
        2: pw.FixedColumnWidth(25),
      },
      children: [
        pw.TableRow(
          children: [
            pw.Container(
              height:25,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                border: pw.Border(right: pw.BorderSide(color: PdfColors.white)),
                color: PdfColors.black,
              ),
              child:pw.Text(
                'In', 
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white), 
                textAlign: pw.TextAlign.center
              ),
            ),
            pw.Container(
              height: 25,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                border: pw.Border(right: pw.BorderSide(color: PdfColors.white)),
                color: PdfColors.black,
              ),
              child:pw.Text(
                'PS', 
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white), 
                textAlign: pw.TextAlign.center
              ),
            ),
            pw.Container(
              height: 25,
              alignment: pw.Alignment.center,
              color: PdfColors.black,
              child:pw.Text(
                'TS', 
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white), 
                textAlign: pw.TextAlign.center
              ),
            )
          ],  
        ),
        ...List.generate(
          endIndex - startIndex,
            (i){
            final inningIndex = startIndex + i;
            final partial = history[inningIndex];
            final int total = history.sublist(0, inningIndex + 1).fold(0, (a,b) => a+b);
            return pw.TableRow(
              children: [
                pw.Container(
                  height: 20,
                  alignment: pw.Alignment.center,
                  color: PdfColors.blueGrey200,
                  child:pw.Text('${inningIndex + 1}', style:pw.TextStyle(fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center), ),
                pw.Container(
                  alignment: pw.Alignment.center,
                  height: 20,
                  child:pw.Text('$partial', textAlign: pw.TextAlign.center),),
                pw.Container(
                  alignment: pw.Alignment.center,
                  height: 20,
                  child:pw.Text('$total', textAlign: pw.TextAlign.center),)
              ], 
            );
          },
        ),
      ]
    );
  }

  List<pw.Widget> buildWrappedHistory(List<int> history) {
    if(history.isEmpty) {
      return [pw.Text('No innings recorded')];
    }
    final List<pw.Widget> tables = [];
    for(int i = 0; i < history.length; i += maxInningsPerTable){
      final end = (i + maxInningsPerTable < history.length) ? i + maxInningsPerTable : history.length;
      tables.add(buildInningTable(history, i, end));
    }
    return tables;
  }


  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(child: pw.Text('MiBillar')), // MI BILLAR
                pw.Container(child: pw.Text(currentDataTime, style: pw.TextStyle(fontSize: 16))), // DATE AND TIME
              ]
            ),
            pw.SizedBox(height:20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start, // P1 COLUMN
                    children: [
                      pw.Container(                                  // P1 NAME
                        child: pw.Text(
                          '${gameState.p1Name ?? "Player 1"}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        )
                      ), 
                      pw.Container(                                 // Number of Extensions Used
                        child: pw.Text(
                          'Extensions Used: ${gameState.p1UsedExtensions}/${gameState.p1Extensions}',
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [...buildWrappedHistory(gameState.p1History)]
                      ), 

                      // pw.TableHelper.fromTextArray(
                      //   headers: ['Inning','Partial','Total'],                // History
                      //   data: List.generate(
                      //     gameState.p1History.length,
                      //     (i) {
                      //       final score = gameState.p1History[i];
                      //       final int cumulative = gameState.p1History.sublist(0, i+1).fold(0, (a,b) => a + b);
                      //       return ['${i + 1}', '$score','$cumulative'];
                      //     },
                      //   ),
                      //   border: pw.TableBorder.all(),
                      //   headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      //   cellAlignment: pw.Alignment.center,
                      // ),
                      pw.SizedBox(height: 10),   
                      pw.Row(         // P1 Summary
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            child: pw.Text('Total Points \n ${gameState.p1TotalScore}')
                          ), // P1 TS
                          pw.Container(
                            child: pw.Text('Total Innings \n ${gameState.p1History.length}')
                          ), // P1 TI,
                          pw.Container(
                            child: pw.Text('Average \n ${gameState.p1Average.toStringAsFixed(3)}')
                          ), // P1 avg
                          pw.Container(child: pw.Text('H.R. \n ${gameState.p1HighRun}')), //P1 HR
                        ]
                      )
                    ]
                  )
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start, // P2 COLUMN
                    children: [
                      pw.Container(                                  // P2 NAME
                        child: pw.Text(
                          '${gameState.p2Name ?? "Player 2"}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        )
                      ), 
                      pw.Container(                                 // Number of Extensions Used
                        child: pw.Text(
                          'Extensions Used: ${gameState.p2UsedExtensions}/${gameState.p2Extensions}',
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [...buildWrappedHistory(gameState.p2History)]
                      ), 

                      // pw.TableHelper.fromTextArray(
                      //   headers: ['Inning','Partial','Total'],                // History
                      //   data: List.generate(
                      //     gameState.p2History.length,
                      //     (i) {
                      //       final score = gameState.p2History[i];
                      //       final int cumulative = gameState.p2History.sublist(0, i+1).fold(0, (a,b) => a + b);
                      //       return ['${i + 1}', '$score','$cumulative'];
                      //     },
                      //   ),
                      //   border: pw.TableBorder.all(),
                      //   headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      //   cellAlignment: pw.Alignment.center,
                      // ),
                      pw.SizedBox(height: 10),   
                      pw.Row(         // P1 Summary
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            child: pw.Text('Total Points \n ${gameState.p2TotalScore}')
                          ), // P1 TS
                          pw.Container(
                            child: pw.Text('Total Innings \n ${gameState.p2History.length}')
                          ), // P1 TI,
                          pw.Container(
                            child: pw.Text('Average \n ${gameState.p2Average.toStringAsFixed(3)}')
                          ), // P1 avg
                          pw.Container(child: pw.Text('H.R. \n ${gameState.p2HighRun}')), //P1 HR
                        ]
                      )
                    ]
                  )
                ), // P2 COLUMN
              ]
            ),
            pw.SizedBox(height: 10),
            pw.Text('PS : Partial Score'),
            pw.Text('TS: Total Score'),
            // pw.SizedBox(height: 20),
            // pw.Text('Player 1: ${gameState.p1Name}'),
            // pw.Text('Player 2: ${gameState.p2Name}'),
            // pw.Text('Match Result: ${gameState.matchResult ?? "In Progress"}'),
            // pw.SizedBox(height:20),
            // pw.SizedBox(height: 10),
            // pw.TableHelper.fromTextArray(
            //   headers: [
            //     'Inning',
            //     gameState.p1Name ?? 'Player 1',
            //     'Cumulative',                
            //     gameState.p2Name ?? 'Player 2',
            //     'Cumulative'
            //   ],
            //   data: [
            //     ... List.generate(
            //       completeInnings,
            //       (i) {
            //         final p1Score = gameState.p1History[i];
            //         final p2Score = gameState.p2History[i];
            //         final int p1Cumulative = gameState.p1History.sublist(0, i +1).fold( 0, (a,b) => a + b);
            //         final int p2Cumulative = gameState.p2History.sublist(0, i + 1).fold( 0, (a,b) => a + b);
            //         return [
            //           '${i+1}',
            //           '$p1Score',
            //           '$p1Cumulative',
            //           '$p2Score',
            //           '$p2Cumulative',
            //         ];
            //       }
            //     ),
            //     if (hasIncompleteInning)
            //     [
            //       '${completeInnings + 1}',
            //       '${gameState.p1History[completeInnings]}',
            //       '-',
            //       '${gameState.p1TotalScore}',
            //       '${gameState.p2TotalScore}',
            //     ],
            //   ],
            //   border: pw.TableBorder.all(),
            //   headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //   cellAlignment: pw.Alignment.center,
            // ),
            // pw.SizedBox(height: 20),

            // pw.Text('Final Scores:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            // pw.Text('${gameState.p1Name}: ${gameState.p1TotalScore}'),
            // pw.Text('${gameState.p2Name}: ${gameState.p2TotalScore}'),
            // pw.SizedBox(height: 10),
            // pw.Text('Statistics:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            // pw.Text('${gameState.p1Name} High Run: ${gameState.p1HighRun}'),
            // pw.Text('${gameState.p2Name} High Run: ${gameState.p2HighRun}'),
            // pw.Text('${gameState.p1Name} Average: ${gameState.p1Average.toStringAsFixed(2)}'),
            // pw.Text('${gameState.p2Name} Average: ${gameState.p2Average.toStringAsFixed(2)}'),
            // pw.Text('${gameState.p1Name} Extensions Used: ${gameState.p1UsedExtensions}/${gameState.p1Extensions}'),
            // pw.Text('${gameState.p2Name} Extensions Used: ${gameState.p2UsedExtensions}/${gameState.p2Extensions}'),            
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
