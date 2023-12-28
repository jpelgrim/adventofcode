import 'dart:io';
import 'dart:math';

import 'package:aoc2022/utils/matrix.dart';

void main(List<String> args) {
  print('--- Day 22: Monkey Map ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day22/input.txt';
  final input = File(filename).readAsLinesSync();

  final matrixHeight = input.length - 2;
  final matrixWidth =
      input.fold(0, (previousValue, element) => (element.length > previousValue) ? element.length : previousValue);

  Matrix<Cell> matrix = List.generate(
      matrixHeight, (int y) => List.generate(matrixWidth, (int x) => Cell(Type.nothing, Point(x + 1, y + 1))));

  Point<int>? startingPoint = null;
  for (var y = 0; y < matrixHeight; y++) {
    Cell? leftMostCell = null;
    Cell? rightMostCell = null;
    for (var x = 0; x < input[y].length; x++) {
      if (input[y][x] == '.') {
        if (startingPoint == null) startingPoint = Point(x, y);
        matrix[y][x] = Cell(Type.path, Point(x + 1, y + 1));
        if (leftMostCell == null) {
          leftMostCell = matrix[y][x];
        } else if (x == input[y].length - 1 || input[y][x + 1] == ' ') {
          rightMostCell = matrix[y][x];
        }
        if (x > 0 && matrix[y][x - 1].type == Type.path) {
          matrix[y][x].left = matrix[y][x - 1];
          matrix[y][x - 1].right = matrix[y][x];
        }
      }
      if (input[y][x] == '#') {
        matrix[y][x] = Cell(Type.wall, Point(x + 1, y + 1));
        if (leftMostCell == null) {
          leftMostCell = matrix[y][x];
        } else if (x == input[y].length - 1 || input[y][x + 1] == ' ') {
          rightMostCell = matrix[y][x];
        }
      }
    }
    if (leftMostCell != null &&
        leftMostCell.type == Type.path &&
        rightMostCell != null &&
        rightMostCell.type == Type.path) {
      leftMostCell.left = rightMostCell;
      rightMostCell.right = leftMostCell;
    }
  }

  for (var x = 0; x < matrixWidth; x++) {
    Cell? topMostCell = null;
    Cell? bottomMostCell = null;
    for (var y = 0; y < matrixHeight; y++) {
      if (matrix[y][x].type == Type.path) {
        if (topMostCell == null) {
          topMostCell = matrix[y][x];
        } else if (y == matrixHeight - 1 || matrix[y + 1][x].type == Type.nothing) {
          bottomMostCell = matrix[y][x];
        }
        if (y > 0 && matrix[y - 1][x].type == Type.path) {
          matrix[y][x].up = matrix[y - 1][x];
          matrix[y - 1][x].down = matrix[y][x];
        }
      }
      if (matrix[y][x].type == Type.wall) {
        if (topMostCell == null) {
          topMostCell = matrix[y][x];
        } else if (y == matrixHeight - 1 || matrix[y + 1][x].type == Type.nothing) {
          bottomMostCell = matrix[y][x];
        }
      }
    }
    if (topMostCell != null &&
        topMostCell.type == Type.path &&
        bottomMostCell != null &&
        bottomMostCell.type == Type.path) {
      topMostCell.up = bottomMostCell;
      bottomMostCell.down = topMostCell;
    }
  }

  final instructions = input[input.length - 1].replaceAll('R', ',R,').replaceAll('L', ',L,').split(',').map((e) {
    if (e == 'R') return 0;
    if (e == 'L') return -1;
    return int.parse(e);
  }).toList();

  var orientation = Orientation.right;

  Cell currentCell = matrix[startingPoint!.y][startingPoint.x];
  for (var instruction in instructions) {
    if (instruction == 0) {
      orientation = Orientation.values[(orientation.index + 1) % 4];
    } else if (instruction == -1) {
      orientation = Orientation.values[(orientation.index + 3) % 4];
    } else {
      label_instructions:
      for (var step = 0; step < instruction; step++) {
        switch (orientation) {
          case Orientation.right:
            if (currentCell.right == null) break label_instructions;
            currentCell = currentCell.right!;
            break;
          case Orientation.left:
            if (currentCell.left == null) break label_instructions;
            currentCell = currentCell.left!;
            break;
          case Orientation.up:
            if (currentCell.up == null) break label_instructions;
            currentCell = currentCell.up!;
            break;
          case Orientation.down:
            if (currentCell.down == null) break label_instructions;
            currentCell = currentCell.down!;
            break;
        }
      }
    }
  }

  print('    Part 1: ${(1000 * currentCell.pos.y) + (4 * currentCell.pos.x) + orientation.index}');

  // Re-map transition points for part 2
  //
  //  ┌──────────────┐┌──────────┐
  //  │┌────────────┐││┌────────┐│
  //  ││┌──────────┐││││┌──────┐││
  //  │││┌────────┐││││││┌────┐│││
  //  ││││┌───────11112222───┐││││
  //  │││││┌──────11112222──┐│││││
  //  ││││││┌─────11112222─┐││││││
  //  │││││││┌────11112222┐│││││││
  //  ││││││││┌───3333┘│││││││││││
  //  │││││││││┌──3333─┘││││││││││
  //  ││││││││││┌─3333──┘│││││││││
  //  │││││││││││┌3333───┘││││││││
  //  │││││││└44445555────┘│││││││
  //  ││││││└─44445555─────┘││││││
  //  │││││└──44445555──────┘│││││
  //  ││││└───44445555───────┘││││
  //  │││└────6666┘│││        ││││
  //  ││└─────6666─┘││        ││││
  //  │└──────6666──┘│        ││││
  //  └───────6666───┘        ││││
  //          │││└────────────┘│││
  //          ││└──────────────┘││
  //          │└────────────────┘│
  //          └──────────────────┘
  //
  /////////////////////////////////////////
  // From the perspective of the square: //
  /////////////////////////////////////////
  // Top square 1, move up -> Left Square 6, Orientation.right (LTR -> TTB)
  // Left square 1, move left -> Left square 4, Orientation.right (TTB -> BTT)
  //
  // Top square 2, move up --> Bottom square 6, Orientation.up (orientation stays the same) (LTR -> LTR)
  // Right square 2, move right -> Right square 5, Orientation.left (TTB -> BTT)
  // Bottom square 2, move down -> Right square 3, Orientation.left (LTR -> TTB)
  //
  // Right square 3, move right -> Bottom square 2, Orientation.up (TTB -> LTR)
  // Left square 3, move left -> Top Square 4, Orientation.down (TTB -> LTR)
  //
  // Top 4, move up -> Left 3, Orientation.right (LTR -> TTB)
  // Left 4, move left -> Left 1, Orientation.right (TTB -> BTT)
  //
  // Right 5, move right -> Right 2, Orientation.left (TTB -> BTT)
  // Bottom 5, move down -> Right 6, Orientation.left (LTR -> TTB)
  //
  // Left 6, move left -> Top 1, Orientation.down (TTB -> LTR)
  // Bottom 6, move down -> Top 2, Orientation.down (orientation stays the same) (LTR -> LTR)
  // Right 6, move right -> Bottom 5, Orientation.up (TTB -> LTR)
  //
  ///////////////////////////////
  // Logical pair perspective: //
  ///////////////////////////////
  //
  // Top square 1, move up -> Left Square 6, Orientation.right (LTR -> TTB)
  // Left 6, move left -> Top 1, Orientation.down (TTB -> LTR)
  //
  // Left square 1, move left -> Left square 4, Orientation.right (TTB -> BTT)
  // Left 4, move left -> Left 1, Orientation.right (TTB -> BTT)
  //
  // Top square 2, move up --> Bottom square 6, Orientation.up (orientation stays the same) (LTR -> LTR)
  // Bottom 6, move down -> Top 2, Orientation.down (orientation stays the same) (LTR -> LTR)
  //
  // Right square 2, move right -> Right square 5, Orientation.left (TTB -> BTT)
  // Right 5, move right -> Right 2, Orientation.left (TTB -> BTT)
  //
  // Bottom square 2, move down -> Right square 3, Orientation.left (LTR -> TTB)
  // Right square 3, move right -> Bottom square 2, Orientation.up (TTB -> LTR)
  //
  // Left square 3, move left -> Top Square 4, Orientation.down (TTB -> LTR)
  // Top 4, move up -> Left 3, Orientation.right (LTR -> TTB)
  //
  // Bottom 5, move down -> Right 6, Orientation.left (LTR -> TTB)
  // Right 6, move right -> Bottom 5, Orientation.up (TTB -> LTR)

  final cubeSize = 50;

  var topLeftSquare1 = Point(cubeSize, 0);

  var topLeftSquare2 = Point(2 * cubeSize, 0);
  var topRightSquare2 = Point(3 * cubeSize - 1, 0);
  var bottomLeftSquare2 = Point(2 * cubeSize, cubeSize - 1);

  var topLeftSquare3 = Point(cubeSize, cubeSize);
  var topRightSquare3 = Point(2 * cubeSize - 1, cubeSize);

  var topLeftSquare4 = Point(0, 2 * cubeSize);
  var bottomLeftSquare4 = Point(0, 3 * cubeSize - 1);

  var bottomLeftSquare5 = Point(cubeSize, 3 * cubeSize - 1);
  var bottomRightSquare5 = Point(2 * cubeSize - 1, 3 * cubeSize - 1);

  var topLeftSquare6 = Point(0, 3 * cubeSize);
  var topRightSquare6 = Point(cubeSize - 1, 3 * cubeSize);
  var bottomLeftSquare6 = Point(0, 4 * cubeSize - 1);

  for (var i = 0; i < cubeSize; i++) {
    if (matrix[topLeftSquare1.y][topLeftSquare1.x + i].type == Type.path && matrix[topLeftSquare6.y + i][topLeftSquare6.x].type == Type.path) {
      // Top square 1, move up -> Left Square 6, Orientation.right (LTR -> TTB)
      matrix[topLeftSquare1.y][topLeftSquare1.x + i].up = matrix[topLeftSquare6.y + i][topLeftSquare6.x].cloneWith(Orientation.right);
      // Left 6, move left -> Top 1, Orientation.down (TTB -> LTR)
      matrix[topLeftSquare6.y + i][topLeftSquare6.x].left = matrix[topLeftSquare1.y][topLeftSquare1.x + i].cloneWith(Orientation.down);
    } else {
      matrix[topLeftSquare1.y][topLeftSquare1.x + i].up = null;
      matrix[topLeftSquare6.y + i][topLeftSquare6.x].left = null;
    }

    if (matrix[topLeftSquare1.y + i][topLeftSquare1.x].type == Type.path && matrix[bottomLeftSquare4.y - i][bottomLeftSquare4.x].type == Type.path) {
      // Left square 1, move left -> Left square 4, Orientation.right (TTB -> BTT)
      matrix[topLeftSquare1.y + i][topLeftSquare1.x].left = matrix[bottomLeftSquare4.y - i][bottomLeftSquare4.x].cloneWith(Orientation.right);
      // Left 4, move left -> Left 1, Orientation.right (TTB -> BTT)
      matrix[bottomLeftSquare4.y - i][bottomLeftSquare4.x].left = matrix[topLeftSquare1.y + i][topLeftSquare1.x].cloneWith(Orientation.right);
    } else {
      matrix[topLeftSquare1.y + i][topLeftSquare1.x].left = null;
      matrix[bottomLeftSquare4.y - i][bottomLeftSquare4.x].left = null;
    }

    if (matrix[topLeftSquare2.y][topLeftSquare2.x + i].type == Type.path && matrix[bottomLeftSquare6.y][bottomLeftSquare6.x + i].type == Type.path) {
      // Top square 2, move up --> Bottom square 6, Orientation.up (orientation stays the same) (LTR -> LTR)
      matrix[topLeftSquare2.y][topLeftSquare2.x + i].up = matrix[bottomLeftSquare6.y][bottomLeftSquare6.x + i].cloneWith(Orientation.up);
      // Bottom 6, move down -> Top 2, Orientation.down (orientation stays the same) (LTR -> LTR)
      matrix[bottomLeftSquare6.y][bottomLeftSquare6.x + i].down = matrix[topLeftSquare2.y][topLeftSquare2.x + i].cloneWith(Orientation.down);
    } else {
      matrix[topLeftSquare2.y][topLeftSquare2.x + i].up = null;
      matrix[bottomLeftSquare6.y][bottomLeftSquare6.x + i].down = null;
    }
    //
    if (matrix[topRightSquare2.y + i][topRightSquare2.x].type == Type.path && matrix[bottomRightSquare5.y - i][bottomRightSquare5.x].type == Type.path) {
      // Right square 2, move right -> Right square 5, Orientation.left (TTB -> BTT)
      matrix[topRightSquare2.y + i][topRightSquare2.x].right = matrix[bottomRightSquare5.y - i][bottomRightSquare5.x].cloneWith(Orientation.left);
      // Right 5, move right -> Right 2, Orientation.left (TTB -> BTT)
      matrix[bottomRightSquare5.y - i][bottomRightSquare5.x].right = matrix[topRightSquare2.y + i][topRightSquare2.x].cloneWith(Orientation.left);
    } else {
      matrix[topRightSquare2.y + i][topRightSquare2.x].right = null;
      matrix[bottomRightSquare5.y - i][bottomRightSquare5.x].right = null;
    }

    if (matrix[bottomLeftSquare2.y][bottomLeftSquare2.x + i].type == Type.path && matrix[topRightSquare3.y + i][topRightSquare3.x].type == Type.path) {
      // Bottom square 2, move down -> Right square 3, Orientation.left (LTR -> TTB)
      matrix[bottomLeftSquare2.y][bottomLeftSquare2.x + i].down = matrix[topRightSquare3.y + i][topRightSquare3.x].cloneWith(Orientation.left);
      // Right square 3, move right -> Bottom square 2, Orientation.up (TTB -> LTR)
      matrix[topRightSquare3.y + i][topRightSquare3.x].right = matrix[bottomLeftSquare2.y][bottomLeftSquare2.x + i].cloneWith(Orientation.up);
    } else {
      matrix[bottomLeftSquare2.y][bottomLeftSquare2.x + i].down = null;
      matrix[topRightSquare3.y + i][topRightSquare3.x].right = null;
    }

    if (matrix[topLeftSquare3.y + i][topLeftSquare3.x].type == Type.path && matrix[topLeftSquare4.y][topLeftSquare4.x + i].type == Type.path) {
      // Left square 3, move left -> Top Square 4, Orientation.down (TTB -> LTR)
      matrix[topLeftSquare3.y + i][topLeftSquare3.x].left = matrix[topLeftSquare4.y][topLeftSquare4.x + i].cloneWith(Orientation.down);
      // Top 4, move up -> Left 3, Orientation.right (LTR -> TTB)
      matrix[topLeftSquare4.y][topLeftSquare4.x + i].up = matrix[topLeftSquare3.y + i][topLeftSquare3.x].cloneWith(Orientation.right);
    } else {
      matrix[topLeftSquare3.y + i][topLeftSquare3.x].left = null;
      matrix[topLeftSquare4.y][topLeftSquare4.x + i].up = null;
    }

    if (matrix[bottomLeftSquare5.y][bottomLeftSquare5.x + i].type == Type.path && matrix[topRightSquare6.y + i][topRightSquare6.x].type == Type.path) {
      // Bottom 5, move down -> Right 6, Orientation.left (LTR -> TTB)
      matrix[bottomLeftSquare5.y][bottomLeftSquare5.x + i].down = matrix[topRightSquare6.y + i][topRightSquare6.x].cloneWith(Orientation.left);
      // Right 6, move right -> Bottom 5, Orientation.up (TTB -> LTR)
      matrix[topRightSquare6.y + i][topRightSquare6.x].right = matrix[bottomLeftSquare5.y][bottomLeftSquare5.x + i].cloneWith(Orientation.up);
    } else {
      matrix[bottomLeftSquare5.y][bottomLeftSquare5.x + i].down = null;
      matrix[topRightSquare6.y + i][topRightSquare6.x].right = null;
    }
  }

  orientation = Orientation.right;

  currentCell = matrix[startingPoint.y][startingPoint.x];
  for (var instruction in instructions) {
    if (instruction == 0) {
      orientation = Orientation.values[(orientation.index + 1) % 4];
    } else if (instruction == -1) {
      orientation = Orientation.values[(orientation.index + 3) % 4];
    } else {
      label_instructions:
      for (var step = 0; step < instruction; step++) {
        switch (orientation) {
          case Orientation.right:
            if (currentCell.right == null) break label_instructions;
            currentCell = currentCell.right!;
            break;
          case Orientation.left:
            if (currentCell.left == null) break label_instructions;
            currentCell = currentCell.left!;
            break;
          case Orientation.up:
            if (currentCell.up == null) break label_instructions;
            currentCell = currentCell.up!;
            break;
          case Orientation.down:
            if (currentCell.down == null) break label_instructions;
            currentCell = currentCell.down!;
            break;
        }
        if (currentCell.orientation != null) orientation = currentCell.orientation!;
      }
    }
  }

  print('    Part 2: ${(1000 * currentCell.pos.y) + (4 * currentCell.pos.x) + orientation.index}');
}

enum Type {
  path,
  wall,
  nothing;
}

enum Orientation { right, down, left, up }

class Cell {
  Cell(this.type, this.pos);

  Type type;
  Point<int> pos;

  Cell? right;
  Cell? left;
  Cell? up;
  Cell? down;

  Orientation? orientation;

  @override
  String toString() {
    return 'Cell{pos: $pos}';
  }

  Cell cloneWith(Orientation orientation) {
    var newCell = Cell(type, pos);
    newCell.orientation = orientation;
    newCell.right = right;
    newCell.left = left;
    newCell.up = up;
    newCell.down = down;
    return newCell;
  }
}
