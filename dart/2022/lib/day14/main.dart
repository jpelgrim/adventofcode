import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day 14: Regolith Reservoir ---');
  
  final filename = args.isNotEmpty ? args[0] : './lib/day14/input.txt';
  final input = File(filename)
      .readAsLinesSync()
      .map((e) => e.split(' -> ').map((e) => e.toPoint()).toList())
      .toList();

  final rocksAndSand = <Point<int>>{};
  for (var i = 0; i < input.length; i++) {
    for (var j = 0; j < input[i].length - 1; j++) {
      final startingPoint = input[i][j];
      final endingPoint = input[i][j + 1];
      if (startingPoint.x == endingPoint.x) {
        // traverse y-axis
        if (startingPoint.y <= endingPoint.y) {
          for (var y = startingPoint.y; y <= endingPoint.y; y++) {
            rocksAndSand.add(Point(startingPoint.x, y));
          }
        } else {
          for (var y = endingPoint.y; y <= startingPoint.y; y++) {
            rocksAndSand.add(Point(startingPoint.x, y));
          }
        }
      } else {
        // travers x-axis
        if (startingPoint.x <= endingPoint.x) {
          for (var x = startingPoint.x; x <= endingPoint.x; x++) {
            rocksAndSand.add(Point(x, startingPoint.y));
          }
        } else {
          for (var x = endingPoint.x; x <= startingPoint.x; x++) {
            rocksAndSand.add(Point(x, startingPoint.y));
          }
        }
      }
    }
  }

  final lowestPoint = rocksAndSand.fold<int>(
      0,
      (previousValue, element) =>
          (element.y > previousValue) ? element.y : previousValue);

  // Create bottom for part 2
  for (var x = 0; x < 1000; x++) rocksAndSand.add(Point(x, lowestPoint + 2));

  var part1 = 0;
  var part2 = 0;
  var sand = Point(500, 0);
  while (!rocksAndSand.contains(sand)) {
    if (sand.y == lowestPoint && part1 == 0) part1 = part2;
    if (rocksAndSand.contains(Point(sand.x, sand.y + 1))) {
      // There's something underneath
      if (rocksAndSand.contains(Point(sand.x - 1, sand.y + 1))) {
        // There's something in the left, try right
        if (rocksAndSand.contains(Point(sand.x + 1, sand.y + 1))) {
          // Time to settle down
          rocksAndSand.add(sand);
          sand = Point(500, 0);
          part2++;
        } else {
          // fall down right
          sand = Point(sand.x + 1, sand.y + 1);
        }
      } else {
        // fall down left
        sand = Point(sand.x - 1, sand.y + 1);
      }
    } else {
      // fall down
      sand = Point(sand.x, sand.y + 1);
    }
  }

  print('    Part 1: $part1');
  print('    Part 2: $part2');
}

extension on String {
  Point<int> toPoint() {
    final coords = split(',');
    return Point(int.parse(coords[0]), int.parse(coords[1]));
  }
}
