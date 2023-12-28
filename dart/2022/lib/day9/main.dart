import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day  9: Rope Bridge ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day9/input.txt';
  final input = File(filename).readAsLinesSync();
  final instructions = input.map((e) => e.split(' ')).toList();

  var head = Point(0, 0);
  var tail = Point(0, 0);
  final visitedPart1 = { Point(0, 0)};

  for (var instruction in instructions) {
    var steps = int.parse(instruction[1]);
    switch (instruction[0]) {
      case 'L':
        for (var i = 0; i < steps; i++) {
          head = Point(head.x - 1, head.y);
          if (head.distanceTo(tail) > sqrt(2)) {
            tail = Point(head.x + 1, head.y);
            visitedPart1.add(tail);
          }
        }
        break;
      case 'R':
        for (var i = 0; i < steps; i++) {
          head = Point(head.x + 1, head.y);
          if (head.distanceTo(tail) > sqrt(2)) {
            tail = Point(head.x - 1, head.y);
            visitedPart1.add(tail);
          }
        }
        break;
      case 'U':
        for (var i = 0; i < steps; i++) {
          head = Point(head.x, head.y + 1);
          if (head.distanceTo(tail) > sqrt(2)) {
            tail = Point(head.x, head.y - 1);
            visitedPart1.add(tail);
          }
        }
        break;
      default: // Down
        for (var i = 0; i < steps; i++) {
          head = Point(head.x, head.y - 1);
          if (head.distanceTo(tail) > sqrt(2)) {
            tail = Point(head.x, head.y + 1);
            visitedPart1.add(tail);
          }
        }
        break;
    }
  }


  print('    Part 1: ${visitedPart1.length}');

  var knots = List.generate(10, (index) => Point(0, 0));
  final visitedPart2 = { Point(0, 0)};
  for (var instruction in instructions) {
    var steps = int.parse(instruction[1]);
    switch (instruction[0]) {
      case 'L':
        for (var i = 0; i < steps; i++) {
          knots[0] = Point(knots[0].x - 1, knots[0].y);
          updateKnots(knots);
          visitedPart2.add(knots[9]);
        }
        break;
      case 'R':
        for (var i = 0; i < steps; i++) {
          knots[0] = Point(knots[0].x + 1, knots[0].y);
          updateKnots(knots);
          visitedPart2.add(knots[9]);
        }
        break;
      case 'U':
        for (var i = 0; i < steps; i++) {
          knots[0] = Point(knots[0].x, knots[0].y + 1);
          updateKnots(knots);
          visitedPart2.add(knots[9]);
        }
        break;
      default: // Down
        for (var i = 0; i < steps; i++) {
          knots[0] = Point(knots[0].x, knots[0].y - 1);
          updateKnots(knots);
          visitedPart2.add(knots[9]);
        }
        break;
    }
  }

  print('    Part 2: ${visitedPart2.length}');
}

void updateKnots(List<Point<int>> knots) {
  for (var j = 1; j < 10; j++) {
    if (knots[j - 1].distanceTo(knots[j]) > sqrt(2)) {
      knots[j] = updatePosition(knots[j - 1], knots[j]);
    }
  }
}

Point<int> updatePosition(Point<int> head, Point<int> tail) {
  if (head.x > tail.x + 1) {
    // head is 2 steps to the right of tail
    if (head.y > tail.y + 1) {
      // head is also 2 steps above tail
      return Point(head.x - 1, head.y - 1);
    } else if (head.y < tail.y - 1) {
      // head is 2 steps below tail
      return Point(head.x - 1, head.y + 1);
    }
    return Point(head.x - 1, head.y);
  }
  if (head.x < tail.x - 1) {
    // head is 2 steps to the left of tail
    if (head.y > tail.y + 1) {
      // head is also 2 steps above tail
      return Point(head.x + 1, head.y - 1);
    } else if (head.y < tail.y - 1) {
      // head is 2 steps below tail
      return Point(head.x + 1, head.y + 1);
    }
    return Point(head.x + 1, head.y);
  }
  if (head.y > tail.y + 1) {
    // head is 2 steps to the left of tail
    return Point(head.x, head.y - 1);
  }
  return Point(head.x, head.y + 1);
}
