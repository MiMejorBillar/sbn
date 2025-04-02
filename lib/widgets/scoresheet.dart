import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:nsb/state_management/game_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

Future<String> generateScoresheetPdf(GameState gameState) async {
  final pdf = pw.Document();
  final String currentDataTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  const int maxInningsPerTable = 25;
  final summaryTextStyle = pw.TextStyle(color: PdfColors.black,fontWeight: pw.FontWeight.bold);
  final summaryValueTS = pw.TextStyle(color: PdfColors.black,fontWeight: pw.FontWeight.bold, fontSize: 16);   
  final summaryCellStyle = pw.BoxDecoration(color: PdfColors.white);
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
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,// P1 COLUMN
                    children: [
                      pw.Container(                                  // P1 NAME
                        child: pw.Text(
                          '${gameState.p1Name ?? "Player 1"}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16
                          ),
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
                        children: [...buildWrappedHistory(gameState.p1History)]
                      ), 
                      pw.SizedBox(height: 10),   
                    ]
                  )
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start, 
                    children: [
                      pw.Container(                                  
                        child: pw.Text(
                          '${gameState.p2Name ?? "Player 2"}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      ), 
                      pw.Container(                                
                        child: pw.Text(
                          'Extensions Used: ${gameState.p2UsedExtensions}/${gameState.p2Extensions}',
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [...buildWrappedHistory(gameState.p2History)]
                      ), 
                      pw.SizedBox(height: 10),   
                    ]
                  )
                ), // P2 COLUMN
              ]
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'Total\nPoints', 
                                style: summaryTextStyle,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'Total\nInnings', 
                                style: summaryTextStyle,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'Average', 
                                style: summaryTextStyle, 
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'HR', 
                                style: summaryTextStyle,
                                textAlign: pw.TextAlign.center
                              ),
                            ),                                                                                                        
                          ]
                        ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                '${gameState.p1TotalScore}', 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                '${gameState.p1History.length}', 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                gameState.p1Average.toStringAsFixed(3), 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                '${gameState.p1HighRun}', 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),                                                                                                        
                          ]
                        )                      
                      ]
                    )
                  ]
                ),                         
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'Total\nPoints', 
                                style: summaryTextStyle, 
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'Total\nInnings', 
                                style: summaryTextStyle,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'Average', 
                                style: summaryTextStyle,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                'HR', 
                                style: summaryTextStyle,
                                textAlign: pw.TextAlign.center
                              ),
                            ),                                                                                                        
                          ]
                        ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                '${gameState.p2TotalScore}', 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                '${gameState.p2History.length}', 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                gameState.p2Average.toStringAsFixed(3), 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                            pw.Container(
                              height:40,
                              alignment: pw.Alignment.center,
                              decoration: summaryCellStyle,
                              child:pw.Text(
                                '${gameState.p2HighRun}', 
                                style: summaryValueTS,
                                textAlign: pw.TextAlign.center
                              ),
                            ),                                                                                                        
                          ]
                        )                      
                      ]
                    )
                  ]
                ),         
              ]
            ),
            pw.SizedBox(height: 10),
            pw.Text('PS : Partial Score'),
            pw.Text('TS: Total Score'),        
          ],
        );
      },
    ),
  );
  
  final currentDataTimeFile = DateFormat('MM-dd-yyyy_HH:mm').format(DateTime.now());
  final directory = await getApplicationCacheDirectory();
  final filePath = '${directory.path}/${gameState.p1Name}_vs_${gameState.p2Name}_$currentDataTimeFile.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return filePath;

  // TO SHARE THE File
  // final scoresheet = await Share.shareXFiles([XFile(filePath)], text: 'Here is the scoresheet');
  // if (scoresheet.status == ShareResultStatus.success) {
  //   print('Thank you for sharing the scoresheet');
  // }
}
