// https://adventofcode.com/2021/day/13
import 'dart:io';

import 'instruction.dart';
import 'point.dart';

void main() {
  print('--- Day 13: Transparent Origami ---');

  final lines = File('input.txt').readAsLinesSync();
  var points = lines
      .where((element) => element.startsWith(RegExp(r'\d')))
      .map((e) => Point.fromList(e.split(',')));

  final instructions = lines
      .where((element) => element.startsWith('fold along'))
      .map((e) => Instruction(e.substring(11, 12) == 'y' ? Axis.y : Axis.x,
          int.parse(e.substring(13))))
      .toList();

  points = fold(points, instructions[0]);

  print('    Part 1: ${points.length}');
}

Iterable<Point> fold(Iterable<Point> points, Instruction instruction) {
  final newPoints = <Point>{};
  points.forEach((point) {
    switch(instruction.axis) {
      case Axis.x:
        final newX = point.x < instruction.value ? point.x : instruction.value - (point.x - instruction.value);
        var newPoint = Point(newX, point.y);
        if (!newPoints.contains(newPoint)) newPoints.add(newPoint);
        break;
      case Axis.y:
        final newY = point.y < instruction.value ? point.y : instruction.value - (point.y - instruction.value);
        var newPoint = Point(point.x, newY);
        if (!newPoints.contains(newPoint)) newPoints.add(newPoint);
        break;
    }
  });
  return newPoints;
}
