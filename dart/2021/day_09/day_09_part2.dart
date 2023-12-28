// https://adventofcode.com/2021/day/9
import 'dart:io';

typedef Matrix = List<List<int>>;
typedef Basin = Set<Point>;

void main() {
  final matrix = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList(growable: false))
      .toList(growable: false);

  final basins = List<Basin>.empty(growable: true);
  for (int y = 0; y < matrix.length; y++) {
    final row = matrix[y];
    for (int x = 0; x < row.length; x++) {
      final point = Point(x, y);
      if (matrix[y][x] != 9 && !basins.containsPoint(point)) {
        basins.add(matrix.explore(point, Set<Point>()));
      }
    }
  }
  final sortedBasins =
      (basins.map((e) => e.length).toList()..sort()).reversed.toList();
  final answer = sortedBasins[0] * sortedBasins[1] * sortedBasins[2];

  print('    Part 2: $answer');
}

class Point {
  Point(this.x, this.y);

  int x;
  int y;

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => 31 * x + y;
}

extension on List<Basin> {
  bool containsPoint(Point point) {
    for (int i = 0; i < length; i++) {
      if (this[i].contains(point)) return true;
    }
    return false;
  }
}

extension on Matrix {
  Set<Point> explore(Point point, Set<Point> basin) {
    if (basin.contains(point) || this[point.y][point.x] == 9) return basin;
    basin.add(point);
    var maxY = length;
    var maxX = this[0].length;
    if (point.y - 1 >= 0) explore(Point(point.x, point.y - 1), basin);
    if (point.y + 1 < maxY) explore(Point(point.x, point.y + 1), basin);
    if (point.x - 1 >= 0) explore(Point(point.x - 1, point.y), basin);
    if (point.x + 1 < maxX) explore(Point(point.x + 1, point.y), basin);
    return basin;
  }
}
