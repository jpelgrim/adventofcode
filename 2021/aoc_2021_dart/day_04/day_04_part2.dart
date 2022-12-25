// https://adventofcode.com/2021/day/4
import 'dart:io';

import 'utils.dart';

void main() {
  List<String> lines = File('input.txt').readAsLinesSync();
  List<int> drawSequence =
      lines[0].split(',').map((e) => int.parse(e)).toList();
  final nrOfMatrices = (lines.length - 1) ~/ 6;

  List<List<List<int>>> matrices = List.filled(nrOfMatrices, List.empty());
  for (int m = 0; m < nrOfMatrices; m++) {
    List<List<int>> matrix = List.filled(5, List.empty());
    for (int r = 0; r < 5; r++) {
      matrix[r] = lines[2 + m * 6 + r]
          .trim()
          .split(RegExp(r"[^\d]+"))
          .map((e) => int.parse(e))
          .toList();
    }
    matrices[m] = matrix;
  }

  int lastDrawnNumber = 0;
  late List<List<int>> lastWinner;
  List<List<List<int>>> matricesWithoutWins = List.empty(growable: true);
  for (int d = 0; d < drawSequence.length; d++) {
    lastDrawnNumber = drawSequence[d];
    for (int m = 0; m < matrices.length; m++) {
      markDraw(matrices[m], lastDrawnNumber);
      if (checkMatrix(matrices[m]) != null) {
        lastWinner = matrices[m];
      } else {
        matricesWithoutWins.add(matrices[m]);
      }
    }
    matrices = matricesWithoutWins;
    matricesWithoutWins = List.empty(growable: true);
    if (matrices.isEmpty) break;
  }

  final sumOfAllUnmarkedNumbers = calculateSum(lastWinner);

  final answer = lastDrawnNumber * sumOfAllUnmarkedNumbers;
  print('    Part 2: ${answer}');

}
