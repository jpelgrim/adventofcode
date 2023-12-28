// https://adventofcode.com/2021/day/25
import 'dart:io';

void main() {
  print('--- Day 25: Sea Cucumber ---');

  final matrix = File('input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  var steps = 1;
  do {
    var movingEastFacingCucumbers = matrix.getMovingEastFacingCucumbers();
    var movingSouthFacingCucumbers = matrix.getMovingSouthFacingCucumbers();
    if (movingEastFacingCucumbers.isEmpty && movingSouthFacingCucumbers.isEmpty) break;
    matrix.moveCucumbersEast(movingEastFacingCucumbers);
    movingSouthFacingCucumbers = matrix.getMovingSouthFacingCucumbers();
    matrix.moveCucumbersSouth(movingSouthFacingCucumbers);
    steps++;
  } while (true);
  print('    Part 1: $steps');

}

extension on List<List<String>> {

  List<Point> getMovingEastFacingCucumbers() {
    var result = <Point>[];
    final width = this[0].length;
    for(int y=0; y < length; y++) {
      for(int x=0; x < width; x++) {
        if (this[y][x] == '>' && this[y][(x + 1) % width] == '.') {
          result.add(Point(x,y));
        }
      }
    }
    return result;
  }

  List<Point> getMovingSouthFacingCucumbers() {
    var result = <Point>[];
    final width = this[0].length;
    for(int y=0; y < length; y++) {
      for(int x=0; x < width; x++) {
        if (this[y][x] == 'v' && this[(y + 1) % length][x] == '.') {
          result.add(Point(x,y));
        }
      }
    }
    return result;
  }

  // East facing is '>'
  void moveCucumbersEast(List<Point> cucumbers) {
    final width = this[0].length;
    cucumbers.forEach((point) {
      this[point.y][point.x] = '.';
      this[point.y][(point.x + 1) % width] = '>';
    });
  }

  // South facing is 'v'
  void moveCucumbersSouth(List<Point> cucumbers) {
    cucumbers.forEach((point) {
      this[point.y][point.x] = '.';
      this[(point.y + 1) % length][point.x] = 'v';
    });
  }

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

