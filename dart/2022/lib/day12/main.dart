import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import 'package:aoc2022/utils/matrix.dart';

void main(List<String> args) {
  print('--- Day 12: Hill Climbing Algorithm ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day12/input.txt';
  final input = File(filename).readAsLinesSync();

  final matrix = input.map((e) => e.runes.toList()).toList(growable: false);

  final S = findPosition(matrix, 'S'.codeUnitAt(0));
  final E = findPosition(matrix, 'E'.codeUnitAt(0));

  matrix[S.y][S.x] = 'a'.codeUnitAt(0);
  matrix[E.y][E.x] = 'z'.codeUnitAt(0);

  var answer = findShortestPath(matrix, S, E);

  print('    Part 1: $answer');

  var part2 = 99999999999;
  var aPoints = <Point<int>>[];
  for (var y = 0; y < matrix.length; y++) {
    for (var x = 0; x < matrix[0].length; x++) {
      if (matrix[y][x] == 'a'.codeUnitAt(0) &&
          (x == 0 || y == 0 ||
              x == matrix[0].length - 1 ||
              y == matrix.length - 1 ||
              matrix[y][x - 1] != 'a'.codeUnitAt(0) ||
              matrix[y][x + 1] != 'a'.codeUnitAt(0))) {
        aPoints.add(Point(x, y));
      }
    }
  }

  for (var p in aPoints) {
    var answer = findShortestPath(matrix, p, E);
    if (answer < part2) part2 = answer;
  }

  print('    Part 2: $part2');
}

Point<int> findPosition(List<List<int>> matrix, int codeUnit) {
  for (var y = 0; y < matrix.length; y++) {
    for (var x = 0; x < matrix[y].length; x++) {
      if (matrix[y][x] == codeUnit) return Point(x, y);
    }
  }
  throw Error();
}

// Calculating the lowest risk with Dijkstra's shortest path algorithm using
// a priority queue as described in pseudo code here
// https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm#Using_a_priority_queue
int findShortestPath(Matrix<int> input, Point<int> start, Point<int> end) {
  final largeInt = 9999999999;
  final pathLength = List.generate(input.length,
      (index) => List.generate(input[0].length, (index) => largeInt));
  pathLength[start.y][start.x] = 0;

  // Found this PriorityQueue implementation from the dart collection library
  // which for convenience I copy pasted in this project
  // https://github.com/dart-lang/collection/blob/master/lib/src/priority_queue.dart
  final toVisit = HeapPriorityQueue<Point<int>>(
      (p1, p2) => pathLength[p1.y][p1.x].compareTo(pathLength[p2.y][p2.x]));
  final visited = <Point<int>>{};
  toVisit.add(start);

  while (toVisit.isNotEmpty) {
    final point = toVisit.removeFirst();
    visited.add(point);

    var possibleMovesForPoint = possibleMoves(input, point);
    possibleMovesForPoint.forEach((node) {
      if (!visited.contains(node)) {
        final shortestPath = pathLength[point.y][point.x] + 1;
        if (shortestPath < pathLength[node.y][node.x]) {
          pathLength[node.y][node.x] = shortestPath;
          toVisit.add(node);
        }
      }
    });
  }

  return pathLength[end.y][end.x];
}

List<Point<int>> possibleMoves(Matrix<int> matrix, Point<int> point) => [
      if (point.x > 0 &&
          matrix[point.y][point.x - 1] - matrix[point.y][point.x] <= 1)
        Point<int>(point.x - 1, point.y),
      if (point.x + 1 < matrix[point.y].length &&
          matrix[point.y][point.x + 1] - matrix[point.y][point.x] <= 1)
        Point<int>(point.x + 1, point.y),
      if (point.y > 0 &&
          matrix[point.y - 1][point.x] - matrix[point.y][point.x] <= 1)
        Point<int>(point.x, point.y - 1),
      if (point.y + 1 < matrix.length &&
          matrix[point.y + 1][point.x] - matrix[point.y][point.x] <= 1)
        Point<int>(point.x, point.y + 1),
    ];
