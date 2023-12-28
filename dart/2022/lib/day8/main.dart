import 'dart:io';

import 'package:aoc2022/utils/matrix.dart';

void main(List<String> args) {
  print('--- Day  8: Treetop Tree House ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day8/input.txt';
  final input = File(filename).readAsLinesSync();
  final matrix = toIntMatrix(input);

  Matrix<bool> result = List.generate(matrix[0].length,
      (int index) => List.generate(matrix.length, (int index) => false));

  for (var i = 1; i < matrix.length - 1; i++) {
    // From left to right
    var max = matrix[i][0];
    for (var j = 1; j < matrix[i].length - 1; j++) {
      if (matrix[i][j] > max) {
        max = matrix[i][j];
        result[i][j] = true;
      }
    }
    // From right to left
    max = matrix[i][matrix[i].length - 1];
    for (var j = matrix[i].length - 2; j > 0; j--) {
      if (matrix[i][j] > max) {
        max = matrix[i][j];
        result[i][j] = true;
      }
    }
  }

  for (var j = 1; j < matrix[0].length - 1; j++) {
    // From up to down
    var max = matrix[0][j];
    for (var i = 1; i < matrix.length - 1; i++) {
      if (matrix[i][j] > max) {
        max = matrix[i][j];
        result[i][j] = true;
      }
    }
  }

  for (var j = 1; j < matrix[0].length - 1; j++) {
    // From down to up
    var max = matrix[matrix[0].length - 1][j];
    for (var i = matrix.length - 2; i > 0; i--) {
      if (matrix[i][j] > max) {
        max = matrix[i][j];
        result[i][j] = true;
      }
    }
  }

  final sizeOfBorder = 2 * matrix[0].length + 2 * matrix.length - 4;
  final part1 = result.fold(
          0,
          (previousValue, List<bool> element) =>
              previousValue +
              element.fold(
                  0,
                  (previousValue, element) =>
                      previousValue + (element ? 1 : 0))) +
      sizeOfBorder;

  print('    Part 1: $part1');

  var bestView = 0;
  for (var y = 1; y < matrix.length - 1; y++) {
    for (var x = 1; x < matrix[0].length - 1; x++) {
      var hutHeight = matrix[y][x];

      // Look left
      var scoreLeft = 0;
      for (var iX = x - 1; iX >= 0; iX--) {
        scoreLeft++;
        if (matrix[y][iX] >= hutHeight) break;
      }

      // Look right
      var scoreRight = 0;
      for (var iX = x + 1; iX < matrix[0].length; iX++) {
        scoreRight++;
        if (matrix[y][iX] >= hutHeight) break;
      }
      // Look up
      var scoreUp = 0;
      for (var iY = y - 1; iY >= 0; iY--) {
        scoreUp++;
        if (matrix[iY][x] >= hutHeight) break;
      }
      // Look down
      var scoreDown = 0;
      for (var iY = y + 1; iY < matrix.length; iY++) {
        scoreDown++;
        if (matrix[iY][x] >= hutHeight) break;
      }
      var score = scoreLeft * scoreRight * scoreUp * scoreDown;
      if (score > bestView) bestView = score;
    }
  }

  final part2 = bestView;
  print('    Part 2: $part2');
}

final Matrix<int> Function(List<String>) toIntMatrix = (List<String> lines) =>
    lines.map((e) => e.split('').map((e) => int.parse(e)).toList()).toList();
