// https://adventofcode.com/2021/day/4
import 'dart:io';

import 'utils.dart';

const size = 5;

void main() {
  print('--- Day 4: Giant Squid ---');

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

  List<List<int>>? winner;
  int lastDrawnNumber = 0;

  foundWinner:
  for (int d = 0; d < drawSequence.length; d++) {
    lastDrawnNumber = drawSequence[d];
    for (int m = 0; m < nrOfMatrices; m++) {
      markDraw(matrices[m], lastDrawnNumber);
    }
    for (int m = 0; m < nrOfMatrices; m++) {
      winner = checkMatrix(matrices[m]);
      if (winner != null) {
        break foundWinner;
      }
    }
  }

  final sumOfAllUnmarkedNumbers = calculateSum(winner!);

  print('    Part 1: ${lastDrawnNumber * sumOfAllUnmarkedNumbers}');
}
