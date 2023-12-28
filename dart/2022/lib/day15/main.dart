import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day 15: Beacon Exclusion Zone ---');

  var spotCloud = <Point<int>>{};

  final filename = args.isNotEmpty ? args[0] : './lib/day15/input.txt';

  final input = File(filename).readAsLinesSync().map((line) {
    var matches = RegExp(r'(-?\d+)').allMatches(line).toList();
    var sensorPos = Point(int.parse(matches[0][0]!), int.parse(matches[1][0]!));
    var beaconPos = Point(int.parse(matches[2][0]!), int.parse(matches[3][0]!));
    var sensor = Sensor(sensorPos, beaconPos);
    spotCloud.add(beaconPos);
    return sensor;
  }).toList();

  var part1 = 0;
  var y = 2000000;
  for (var sensor in input) {
    if (sensor.pos.y - sensor.distance <= y ||
        sensor.pos.y + sensor.distance >= y) {
      for (var x = sensor.pos.x - (sensor.distance - (y - sensor.pos.y).abs());
          x <= sensor.pos.x + (sensor.distance - (y - sensor.pos.y).abs());
          x++) {
        var emptySpot = Point(x, y);
        if (!spotCloud.contains(emptySpot)) {
          spotCloud.add(emptySpot);
          part1++;
        }
      }
    }
  }
  print('    Part 1: $part1');

  var part2 = 0;
  final multiplier = 4000000;
  out:
  for (var y = 0; y <= multiplier; y++) {
    var x = 0;
    while (x <= multiplier) {
      var pointUnderTest = Point<int>(x, y);
      var scannedBorderRight =
          ifScannedStepsToRightBorder(input, pointUnderTest);
      if (scannedBorderRight > 0) {
        x += scannedBorderRight;
      } else {
        part2 = x * multiplier + y;
        break out;
      }
    }
  }
  print('    Part 2: $part2');
}

int ifScannedStepsToRightBorder(List<Sensor> input, Point<int> pointUnderTest) {
  for (var sensor in input) {
    var deltaBorderRight = sensor.deltaBorderRight(pointUnderTest);
    if (deltaBorderRight >= 0) {
      return deltaBorderRight + 1;
    }
  }
  return NOT_FOUND;
}

class Sensor {
  Sensor(this.pos, this.beacon)
      : this.distance = (pos.x - beacon.x).abs() + (pos.y - beacon.y).abs();

  final Point<int> pos;
  final Point<int> beacon;
  final int distance;

  int distanceTo(Point<int> other) =>
      (pos.x - other.x).abs() + (pos.y - other.y).abs();

  int deltaBorderRight(Point<int> other) {
    var distanceToOther = distanceTo(other);
    if (distanceToOther <= distance) {
      // The point is detected by this scanner. Return the delta to the right
      return distance - distanceToOther;
    }
    return NOT_FOUND;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sensor && runtimeType == other.runtimeType && pos == other.pos;

  @override
  int get hashCode => pos.hashCode;
}

const NOT_FOUND = -1;
