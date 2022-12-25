// https://adventofcode.com/2021/day/19
import 'dart:io';
import 'dart:math';

void main() {
  print('--- Day 19: Beacon Scanner ---');

  final scanners = <Scanner>[];
  var lines = File('input.txt').readAsLinesSync();
  final points = <String>[];
  var scannerIndex = 0;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].startsWith('---')) {
      points.clear();
      continue;
    }
    if (lines[i].isNotEmpty) points.add(lines[i]);
    if (lines[i].isEmpty || i == lines.length - 1) {
      scanners.add(Scanner.fromIndexAndLines(scannerIndex++, points));
    }
  }

  final beaconCloud = <Beacon>{};
  beaconCloud.addAll(scanners[0].beacons);

  final overlappingScanners = [scanners[0]];
  final scannersToCheck = scanners.skip(1).toList();

  for (int j = 0; j < overlappingScanners.length; j++) {
    final overlappingScanner = overlappingScanners[j];

    // Traversing scanners to check from last to first so we can remove them if
    // they prove to be overlapping with some other overlapping scanner
    var lastPosition = scannersToCheck.length - 1;
    for (int i = lastPosition; i >= 0 && scannersToCheck.isNotEmpty; i--) {
      final scannerToCheck = scannersToCheck[i];
      if (overlappingScanner.hasOverlappingBeacons(scannerToCheck)) {
        scannerToCheck.translation =
            overlappingScanner.translation + scannerToCheck.translation;
        final orientation = scannerToCheck.rotation;
        scannerToCheck.rotation =
            (p) => overlappingScanner.rotation(orientation(p));
        scannersToCheck.removeAt(i);
        overlappingScanners.add(scannerToCheck);
        beaconCloud.addAll(scannerToCheck.beacons.map(
            (p) => scannerToCheck.rotation(p) + scannerToCheck.translation));
      }
    }
  }

  print('    Part 1: ${beaconCloud.length}');

  int largestManhattanDistance = 0;
  for (int i = 0; i < scanners.length - 1; i++) {
    for (int j = i + 1; j < scanners.length; j++) {
      final difference = scanners[j].translation - scanners[i].translation;
      final distance = difference.manhattanDistance();
      largestManhattanDistance = max(largestManhattanDistance, distance);
    }
  }

  print('    Part 2: $largestManhattanDistance');
}

typedef Rotation<Beacon> = Beacon Function(Beacon);

final rotations = <Rotation<Beacon>>[
  // Positive y is up
  (p) => Beacon(p.x, p.y, p.z),
  (p) => Beacon(-p.x, p.y, -p.z),
  (p) => Beacon(p.z, p.y, -p.x),
  (p) => Beacon(-p.z, p.y, p.x),
  // Negative y is up
  (p) => Beacon(p.z, -p.y, p.x),
  (p) => Beacon(-p.z, -p.y, -p.x),
  (p) => Beacon(p.x, -p.y, -p.z),
  (p) => Beacon(-p.x, -p.y, p.z),
  // Positive x is up
  (p) => Beacon(p.z, p.x, p.y),
  (p) => Beacon(-p.z, p.x, -p.y),
  (p) => Beacon(p.y, p.x, -p.z),
  (p) => Beacon(-p.y, p.x, p.z),
  // Negative x is up
  (p) => Beacon(p.z, -p.x, -p.y),
  (p) => Beacon(-p.z, -p.x, p.y),
  (p) => Beacon(p.y, -p.x, p.z),
  (p) => Beacon(-p.y, -p.x, -p.z),
  // Positive z is up
  (p) => Beacon(p.x, p.z, -p.y),
  (p) => Beacon(-p.x, p.z, p.y),
  (p) => Beacon(p.y, p.z, p.x),
  (p) => Beacon(-p.y, p.z, -p.x),
  // Negative z is up
  (p) => Beacon(p.x, -p.z, p.y),
  (p) => Beacon(-p.x, -p.z, -p.y),
  (p) => Beacon(p.y, -p.z, -p.x),
  (p) => Beacon(-p.y, -p.z, p.x),
];

class Beacon {
  const Beacon(this.x, this.y, this.z);

  final int x, y, z;

  factory Beacon.fromList(List<int> list) => Beacon(list[0], list[1], list[2]);

  Beacon operator +(Beacon o) => Beacon(x + o.x, y + o.y, z + o.z);

  Beacon operator -(Beacon o) => Beacon(x - o.x, y - o.y, z - o.z);

  bool operator ==(Object o) => o is Beacon && o.x == x && o.y == y && o.z == z;

  int get hashCode => x + 31 * y + 17 * 31 * z;

  int sum() => x + y + z;

  int distance() => x * x + y * y + z * z;

  int manhattanDistance() => x.abs() + y.abs() + z.abs();

  @override
  String toString() => '($x,$y,$z)';
}

class Scanner {
  Scanner({
    required this.id,
    required this.beacons,
  });

  final int id;
  final List<Beacon> beacons;

  Beacon translation = const Beacon(0, 0, 0);

  Rotation<Beacon> rotation = (p) => p;

  late final distances = {
    for (int i = 0; i < beacons.length; i++)
      for (int j = 0; j < beacons.length; j++)
        if (i != j) (beacons[j] - beacons[i]).distance(),
  };
  late final distancesFromPoint = [
    for (int i = 0; i < beacons.length; i++)
      [
        for (int j = 0; j < beacons.length; j++)
          if (i != j) (beacons[j] - beacons[i]).distance(),
      ],
  ];

  late final rotatedPoints = List.generate(
    rotations.length,
    (r) => List.generate(beacons.length, (i) => rotations[r](beacons[i])),
  );

  factory Scanner.fromIndexAndLines(int id, Iterable<String> lines) => Scanner(
        id: id,
        beacons: lines.map((e) {
          var list = e.split(',').map(int.parse).toList();
          return Beacon.fromList(list);
        }).toList(),
      );

  bool hasOverlappingBeacons(Scanner other) {
    final minimumOverlap = 12;
    final commonDistances = distances.intersection(other.distances);
    if (commonDistances.length < minimumOverlap) return false;

    final myBeacons = <Beacon>[];
    for (int i = 0; i < beacons.length; i++) {
      if (distancesFromPoint[i].any(commonDistances.contains)) {
        myBeacons.add(beacons[i]);
      }
    }
    final theirBeacons = <Beacon>[];
    for (int j = 0; j < other.beacons.length; j++) {
      if (other.distancesFromPoint[j].any(commonDistances.contains)) {
        theirBeacons.add(other.beacons[j]);
      }
    }
    // Try rotating the other scanner beacons to see if we find matches with
    // our scanner beacons.
    for (int i = 0; i < rotations.length; i++) {
      final _rotation = rotations[i];
      final translatedBeaconCount = <Beacon, int>{};
      for (int j = 0; j < theirBeacons.length; j++) {
        for (int k = 0; k < myBeacons.length; k++) {
          final translatedBeacon = myBeacons[k] - _rotation(theirBeacons[j]);
          final value = (translatedBeaconCount[translatedBeacon] ?? 0) + 1;
          if (value == minimumOverlap) {
            // We've found 12 beacons which are the same. Now it's time to draw
            // some conclusions. The other translation is the matching point
            // difference rotated in our orientation
            var translationCoordinates = rotation(translatedBeacon);
            other.translation = translationCoordinates;
            // The other's rotation is the rotation we are currently working with
            other.rotation = _rotation;
            return true;
          }
          translatedBeaconCount[translatedBeacon] = value;
        }
      }
    }
    return false;
  }
}
