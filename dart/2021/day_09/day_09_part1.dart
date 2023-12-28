// https://adventofcode.com/2021/day/9
import 'dart:io';

void main() {
  print('--- Day 9: Smoke Basin ---');

  final matrix = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList(growable: false))
      .toList(growable: false);

  var answer = 0;
  var maxY = matrix.length;
  for (int y = 0; y < maxY; y++) {
    final row = matrix[y];
    var maxX = row.length;
    for (int x = 0; x < maxX; x++) {
      final value = matrix[y][x];
      var lowest = true;
      if (y-1 >= 0) lowest &= value < matrix[y-1][x];
      if (lowest && y+1 < maxY) lowest &= value < matrix[y+1][x];
      if (lowest && x-1 >= 0) lowest &= value < matrix[y][x-1];
      if (lowest && x+1 < maxX) lowest &= value < matrix[y][x+1];
      if (lowest) answer += 1 + value;
    }
  }

  print('    Part 1: $answer');
}
