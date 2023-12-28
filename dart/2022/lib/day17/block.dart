import 'dart:math';

class Block {
  Block(this.pattern);

  List<Point<int>> pattern;
  Point<int> position = Point(0, 0);

  int width() =>
      pattern.fold(0, (previousValue, element) =>
      (element.x > previousValue)
          ? element.x
          : previousValue) + 1;

  int height() =>
      pattern.fold(0, (previousValue, element) =>
      (element.y > previousValue)
          ? element.y
          : previousValue) + 1;

  int top() => height() + position.y;

  List<Point<int>> translatedPattern() => pattern.map((e) => e + position).toList();

  @override
  String toString() {
    var result = '';
    for (var y = height() - 1; y >= 0; y--) {
      String row = "";
      for (var x = 0; x < width(); x++) {
        row += pattern.contains(Point(x, y)) ? "@" : " ";
      }
      result += '$row\n';
    }
    return result;
  }

  contains(Point<int> point) => translatedPattern().contains(point);
}
