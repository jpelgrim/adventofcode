import 'dart:math';

import 'block.dart';

class Game {
  List<Point<int>> board = [
    Point(0, 0),
    Point(1, 0),
    Point(2, 0),
    Point(3, 0),
    Point(4, 0),
    Point(5, 0),
    Point(6, 0),
  ];

  Block? block;
  int blocksAdded = 0;
  int top = 0;

  void addBlock(Block block) {
    this.block = block;
    block.position = Point(2, top + 3);
  }

  bool canMoveLeft() {
    if (block == null) return false;
    if (block!
        .translatedPattern()
        .where((element) => element.x == 0)
        .isNotEmpty) return false;
    for (var point in block!.translatedPattern()) {
      if (board.contains(Point(point.x - 1, point.y))) return false;
    }
    return true;
  }

  bool canMoveRight() {
    if (block == null) return false;
    if (block!
        .translatedPattern()
        .where((element) => element.x == 6)
        .isNotEmpty) return false;
    for (var point in block!.translatedPattern()) {
      if (board.contains(Point(point.x + 1, point.y))) return false;
    }
    return true;
  }

  bool canMoveDown() {
    if (block == null) return false;
    for (var point in block!.translatedPattern()) {
      if (board.contains(Point(point.x, point.y - 1))) return false;
    }
    return true;
  }

  int key() {
    var result = '';
    var topBoard = block != null ? max(block!.top(), top) : top;
    for (var y = topBoard - 1; y >= max(topBoard - 100, 0); y--) {
      var row = y == 0 ? "+" : '|';
      for (var x = 0; x < 7; x++) {
        if (block != null) {
          row += board.contains(Point(x, y))
              ? y == 0 ? "-" : "#"
              : block!.contains(Point(x, y))
              ? "@"
              : ".";
        } else {
          row += board.contains(Point(x, y))
              ? y == 0 ? "-" : "#"
              : ".";
        }
      }
      row += y == 0 ? "+" : "|";
      result += '$row';
    }
    return result.hashCode;
  }


  @override
  String toString() {
    var result = '';
    var topBoard = block != null ? max(block!.top(), top) : top;
    for (var y = topBoard - 1; y >= 0; y--) {
      var row = y == 0 ? "+" : '|';
      for (var x = 0; x < 7; x++) {
        if (block != null) {
          row += board.contains(Point(x, y))
              ? y == 0 ? "-" : "#"
              : block!.contains(Point(x, y))
                  ? "@"
                  : ".";
        } else {
          row += board.contains(Point(x, y))
              ? y == 0 ? "-" : "#"
              : ".";
        }
      }
      row += y == 0 ? "+" : "|";
      result += '$row\n';
    }
    return result;
  }

  void moveLeft() => block!.position += (Point(-1, 0));

  void moveRight() => block!.position += (Point(1, 0));

  void moveDown() => block!.position += (Point(0, -1));

  void freezeBlock() {
    top = max(block!.top(), top);
    board.addAll(block!.translatedPattern());
    blocksAdded++;
    block = null;
    board.removeWhere((element) => element.y < top - 500);
  }
}
