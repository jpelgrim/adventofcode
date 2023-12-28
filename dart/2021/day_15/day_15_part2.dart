// https://adventofcode.com/2021/day/15
import 'dart:io';

import 'matrix.dart';
import 'point.dart';
import 'priority_queue.dart';

void main() {
  final matrix = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList(growable: false))
      .toList(growable: false);

  List<List<int>> expandedMatrix = expandMatrix(matrix);

  var answer = calculateLowestRisk(expandedMatrix);
  print('    Part 2: $answer');
}

List<List<int>> expandMatrix(List<List<int>> matrix) {
  var maxY = matrix.length;
  var maxX = matrix[0].length;

  var matrixTimes5 = List.generate(matrix.length * 5,
      (index) => List.generate(matrix[0].length * 5, (index) => 0));
  for (int hor = 0; hor < 5; hor++) {
    for (int ver = 0; ver < 5; ver++) {
      for (int y = 0; y < maxY; y++) {
        for (int x = 0; x < maxX; x++) {
          if (hor == 0 && ver == 0) {
            // Just copy the first matrix
            matrixTimes5[y][x] = matrix[y][x];
          } else if (hor >= ver) {
            // Look left
            var newY = y + (ver * maxY);
            var newX = x + (hor * maxX);
            var xLeft = x + ((hor - 1) * maxX);
            var newValue = matrixTimes5[newY][xLeft] + 1;
            if (newValue == 10) newValue = 1;
            matrixTimes5[newY][newX] = newValue;
          } else {
            var newY = y + (ver * maxY);
            var newX = x + (hor * maxX);
            // Look up
            var yUp = y + ((ver - 1) * maxY);
            var newValue = matrixTimes5[yUp][newX] + 1;
            if (newValue == 10) newValue = 1;
            matrixTimes5[newY][newX] = newValue;
          }
        }
      }
    }
  }
  return matrixTimes5;
}

// Calculating the lowest risk with Dijkstra's shortest path algorithm using
// a priority queue as described in pseudo code here
// https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm#Using_a_priority_queue
int calculateLowestRisk(Matrix input) {
  final calculatedRisk = List.generate(input.length,
      (index) => List.generate(input[0].length, (index) => 9999999999));
  calculatedRisk[0][0] = 0;

  // Found this PriorityQueue implementation from the dart collection library
  // which for convenience I copy pasted in this project
  // https://github.com/dart-lang/collection/blob/master/lib/src/priority_queue.dart
  final toVisit = HeapPriorityQueue<Point>((p1, p2) =>
      calculatedRisk[p1.y][p1.x].compareTo(calculatedRisk[p2.y][p2.x]));
  final visited = <Point>{};
  toVisit.add(Point(0, 0));

  while (toVisit.isNotEmpty) {
    final point = toVisit.removeFirst();
    visited.add(point);

    neighbours(point.y, point.x, Point(input[0].length - 1, input.length - 1))
        .forEach((n) {
      if (!visited.contains(n)) {
        final newRisk = calculatedRisk[point.y][point.x] + input[n.y][n.x];
        if (newRisk < calculatedRisk[n.y][n.x]) {
          calculatedRisk[n.y][n.x] = newRisk;
          toVisit.add(n);
        }
      }
    });
  }

  return calculatedRisk[calculatedRisk.length - 1]
      [calculatedRisk[0].length - 1];
}

List<Point> neighbours(int y, int x, Point max) => [
      if (x > 0) Point(x - 1, y),
      if (y > 0) Point(x, y - 1),
      if (x < max.x) Point(x + 1, y),
      if (y < max.y) Point(x, y + 1),
    ];
