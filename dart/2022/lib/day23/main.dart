import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day 23: Unstable Diffusion ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day23/input.txt';
  final input = File(filename).readAsLinesSync();

  final elfPositions = <Point<int>>[];
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input.length; x++) {
      if (input[y][x] == "#") elfPositions.add(Point(x, y));
    }
  }

  for (var r = 0; r < 10000; r++) {
    var moves = <Move>[];
    var dupes = <Move>{};
    for (var elf in elfPositions) {
      if (nobodyAround(elf, elfPositions)) continue;
      Move? move = null;
      for (var direction = r; direction < r + 4; direction++) {
        if (move != null) break;
        switch (Direction.values[direction % 4]) {
          case Direction.north:
            if (!elfPositions.contains(Point(elf.x - 1, elf.y - 1)) &&
                !elfPositions.contains(Point(elf.x, elf.y - 1)) &&
                !elfPositions.contains(Point(elf.x + 1, elf.y - 1))) {
              move = Move(elf, Point<int>(elf.x, elf.y - 1));
            }
            break;
          case Direction.south:
            if (!elfPositions.contains(Point(elf.x - 1, elf.y + 1)) &&
                !elfPositions.contains(Point(elf.x, elf.y + 1)) &&
                !elfPositions.contains(Point(elf.x + 1, elf.y + 1))) {
              move = Move(elf, Point<int>(elf.x, elf.y + 1));
            }
            break;
          case Direction.west:
            if (!elfPositions.contains(Point(elf.x - 1, elf.y - 1)) &&
                !elfPositions.contains(Point(elf.x - 1, elf.y)) &&
                !elfPositions.contains(Point(elf.x - 1, elf.y + 1))) {
              move = Move(elf, Point<int>(elf.x - 1, elf.y));
            }
            break;
          case Direction.east:
            if (!elfPositions.contains(Point(elf.x + 1, elf.y - 1)) &&
                !elfPositions.contains(Point(elf.x + 1, elf.y)) &&
                !elfPositions.contains(Point(elf.x + 1, elf.y + 1))) {
              move = Move(elf, Point<int>(elf.x + 1, elf.y));
            }
            break;
        }
      }
      if (move != null) {
        if (moves.contains(move)) {
          moves.remove(move);
          dupes.add(move);
        } else if (!dupes.contains(move)) {
          moves.add(move);
        }
      }
    }
    if (moves.isEmpty) {
      print('    Part 2: ${r + 1}');
      break;
    }
    for (var move in moves) {
      elfPositions.remove(move.from);
      elfPositions.add(move.to);
    }
    if (r == 9) {
      var part1 = calculateEmptyPositions(elfPositions);
      print('    Part 1: $part1');
    }
  }
}

bool nobodyAround(Point<int> elf, List<Point<int>> positions) =>
    !positions.contains(Point(elf.x - 1, elf.y - 1)) &&
    !positions.contains(Point(elf.x - 1, elf.y)) &&
    !positions.contains(Point(elf.x - 1, elf.y + 1)) &&
    !positions.contains(Point(elf.x, elf.y - 1)) &&
    !positions.contains(Point(elf.x, elf.y + 1)) &&
    !positions.contains(Point(elf.x + 1, elf.y - 1)) &&
    !positions.contains(Point(elf.x + 1, elf.y)) &&
    !positions.contains(Point(elf.x + 1, elf.y + 1));

int calculateEmptyPositions(List<Point<int>> positions) {
  var left = positions.fold(9999999999, (p, e) => e.x < p ? e.x : p);
  var right = positions.fold(-9999999999, (p, e) => e.x > p ? e.x : p);
  var top = positions.fold(9999999999, (p, e) => e.y < p ? e.y : p);
  var bottom = positions.fold(-9999999999, (p, e) => e.y > p ? e.y : p);
  var totalNumberOfPositionsInGrid = (right - left + 1) * (bottom - top + 1);
  return totalNumberOfPositionsInGrid - positions.length;
}

enum Direction {
  north,
  south,
  west,
  east;
}

class Move {
  Move(this.from, this.to);

  Point<int> from;
  Point<int> to;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Move && runtimeType == other.runtimeType && to == other.to;

  @override
  int get hashCode => to.hashCode;
}
