// https://adventofcode.com/2021/day/15
import 'dart:io';

import 'matrix.dart';
import 'point.dart';

void main() {
  print('--- Day 15: Chiton ---');
  final matrix = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList(growable: false))
      .toList(growable: false);

  var cache = List.generate(matrix.length, (index) => List.generate(matrix[0].length, (index) => 0));

  var answer = calculateLowestRisk(Point(0,0), matrix, cache) - matrix[0][0];

  print('    Part 1: $answer');
}

int calculateLowestRisk(Point point, Matrix matrix, Matrix cache) {
  if (cache[point.y][point.x] > 0) return cache[point.y][point.x];
  var maxY = matrix.length - 1;
  var maxX = matrix[0].length - 1;
  var risk = matrix[point.y][point.x];
  if (point == Point(maxX,maxY)) return risk;
  final riskRight = point.x == maxX ? 99999999999 : calculateLowestRisk(Point(point.x + 1, point.y), matrix, cache);
  if (point.x < maxX) cache[point.y][point.x + 1] = riskRight;
  final riskDown = point.y == maxY ? 99999999999 : calculateLowestRisk(Point(point.x, point.y + 1), matrix, cache);
  if (point.y < maxY) cache[point.y + 1][point.x] = riskDown;
  return riskRight < riskDown ? risk + riskRight : risk + riskDown;
}
