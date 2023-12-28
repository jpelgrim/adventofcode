// https://adventofcode.com/2021/day/13
import 'dart:io';

import 'instruction.dart';
import 'point.dart';

void main() {
  final lines = File('input.txt').readAsLinesSync();
  var points = lines
      .where((element) => element.startsWith(RegExp(r'\d')))
      .map((e) => Point.fromList(e.split(',')));

  final instructions = lines
      .where((element) => element.startsWith('fold along'))
      .map((e) => Instruction(e.substring(11, 12) == 'y' ? Axis.y : Axis.x,
          int.parse(e.substring(13))))
      .toList();

  for(int i=0; i < instructions.length; i++) {
    points = fold(points, instructions[i]);
  }

  final maxX = points.fold<int>(0, (previousValue, element) => element.x > previousValue ? element.x : previousValue);
  final maxY = points.fold<int>(0, (previousValue, element) => element.y > previousValue ? element.y : previousValue);
  final matrix = List<List<String>>.generate(maxY+1, (index) => List<String>.generate(maxX+1, (index) => ' '));
  points.forEach((element) {matrix[element.y][element.x]='█';});
  print('    Part 2:');
  matrix.forEach((element) {print('    ${element.join('')}');});
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
