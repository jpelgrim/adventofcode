// https://adventofcode.com/2021/day/17
import 'dart:io';
import 'dart:math';

import 'area.dart';
import 'point.dart';

void main() {
  print('--- Day 17: Trick Shot ---');

  final points = File('input.txt')
      .readAsStringSync()
      .substring(13)
      .split(', ')
      .map((e) => e.substring(2).split('..').map((e) => int.parse(e)).toList());

  final minX = min(points.first[0], points.first[1]);
  final maxX = max(points.first[0], points.first[1]);
  final minY = min(points.last[0], points.last[1]);
  final maxY = max(points.last[0], points.last[1]);

  final targetArea = Area(Point(minX, minY), Point(maxX, maxY));

  var highestY = 0;
  final hits = <Point>{};

  for(int x=0; x <= maxX; x++) {
    for(int y=-1000; y < 1000; y++) {
      final hit = heightAndHit(Point(x,y), targetArea);
      if (hit.isNotEmpty) {
        hits.add(hit[1]);
        if (hit[0].y > highestY) highestY = hit[0].y;
      }
    }
  }

  print('    Part 1: $highestY');
  print('    Part 2: ${hits.length}');

}

List<Point> heightAndHit(Point point, Area targetArea) {
  var newXVelocity = point.x;
  var newYVelocity = point.y;
  var x = 0;
  var y = 0;
  var highestY = 0;
  do {
    x += newXVelocity;
    y += newYVelocity;
    if (y > highestY) {
      highestY = y;
    }
    var newPosition = Point(x, y);
    if (targetArea.hit(newPosition)) {
      return [Point(0,highestY), point];
    }
    if (targetArea.overshoot(newPosition)) {
      return [];
    }
    newXVelocity = max(0, newXVelocity - 1);
    newYVelocity--;
  } while (true);
}
