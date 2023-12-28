// https://adventofcode.com/2021/day/5
import 'dart:io';
import 'dart:math';

typedef Instruction = List<Point>;
typedef Line = List<Point>;
typedef Matrix<T> = List<List<T>>;

void main() {
  print('--- Day 5: Hydrothermal Venture ---');

  List<String> lines = File('input.txt').readAsLinesSync();
  List<Instruction> instructions = lines.map((e) {
    final points = e.split(' -> ');
    final from = points[0].split(',').map((e) => int.parse(e)).toList();
    final to = points[1].split(',').map((e) => int.parse(e)).toList();
    return [Point.fromList(from), Point.fromList(to)];
  }).toList();
  final size = calculateSize(instructions);
  List<Line> instructionLines =
      instructions.map((e) => e[0].toLine(e[1])).toList();

  Matrix<int> matrix = List.generate(
      size.x + 1, (int index) => List.generate(size.y + 1, (int index) => 0));

  markPoints(instructionLines, matrix);

  var answer = matrix.fold<int>(0, (columnSum, row) {
    return columnSum +
        row.fold<int>(0, (rowSum, value) => value > 1 ? rowSum + 1 : rowSum);
  });

  print('    Part 1: ${answer}');
}

void markPoints(List<Line> instructionLines, Matrix<int> matrix) {
  instructionLines.forEach((listOfPoints) {
    if (!listOfPoints.isEmpty) {
      listOfPoints.forEach((point) {
        matrix[point.x][point.y] = matrix[point.x][point.y] + 1;
      });
    }
  });
}

Point calculateSize(List<Instruction> instructions) {
  return instructions.fold(Point(0, 0), (previousValue, instruction) {
    var maxX = previousValue.x;
    var maxY = previousValue.y;
    final from = instruction[0];
    final to = instruction[1];
    if (from.x > maxX) maxX = from.x;
    if (from.y > maxY) maxY = from.y;
    if (to.x > maxX) maxX = to.x;
    if (to.y > maxY) maxY = to.y;
    return Point(maxX, maxY);
  });
}

class Point {
  Point(this.x, this.y);

  Point.fromList(List<int> coordinates) : this(coordinates[0], coordinates[1]);

  Line toLine(Point other) {
    if (x != other.x && y != other.y) return List.empty();
    final maxX = max(x, other.x);
    final minX = min(x, other.x);
    final maxY = max(y, other.y);
    final minY = min(y, other.y);
    var result = List<Point>.empty(growable: true);
    for (int i = minX; i <= maxX; i++) {
      for (int j = minY; j <= maxY; j++) {
        result.add(Point(i, j));
      }
    }
    return result;
  }

  int x;
  int y;
}
